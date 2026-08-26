unit nc_local_completion_host;

interface

uses
    Winapi.Windows,
    System.SysUtils,
    System.Classes,
    System.SyncObjs,
    nc_engine_intf;

type
    TncLocalCompletionHost = class;

    TncLocalCompletionTask = record
        session_id: string;
        session_instance_id: UInt64;
        candidate_generation: UInt64;
        request: TncLongNeuralCompletionRequest;
    end;

    TncLocalCompletionResultEvent = reference to procedure(
        const task: TncLocalCompletionTask;
        const completion_result: TncLongNeuralCompletionResult);

    TncLocalCompletionFinishedEvent = reference to procedure(
        const task: TncLocalCompletionTask; const accepted: Boolean;
        const completion_result: TncLongNeuralCompletionResult);

    TncLocalCompletionWorker = class(TThread)
    private
        m_owner: TncLocalCompletionHost;
    protected
        procedure Execute; override;
    public
        constructor create(const owner: TncLocalCompletionHost);
        procedure detach_owner;
    end;

    TncLocalCompletionHost = class
    private type
        TncLcCreate = function(const model_path, index_path: PWideChar;
            const intra_threads: Integer; const error_text: PWideChar;
            const error_capacity: Integer): Pointer; cdecl;
        TncLcRun = function(const handle: Pointer;
            const context, query_syllables, top1_text, top1_path,
            top2_text, top2_path: PWideChar;
            const minimum_confidence: Single;
            const output_suffix_text: PWideChar;
            const output_suffix_text_capacity: Integer;
            const output_suffix_pinyin: PWideChar;
            const output_suffix_pinyin_capacity: Integer;
            const output_suffix_path: PWideChar;
            const output_suffix_path_capacity: Integer;
            const output_base_rank: PInteger;
            const output_confidence: PSingle;
            const error_text: PWideChar;
            const error_capacity: Integer): Integer; cdecl;
        TncLcDestroy = procedure(const handle: Pointer); cdecl;
    private
        m_base_directory: string;
        m_lock: TCriticalSection;
        m_wakeup: TEvent;
        m_worker: TncLocalCompletionWorker;
        m_pending_task: TncLocalCompletionTask;
        m_has_pending_task: Boolean;
        m_result_event: TncLocalCompletionResultEvent;
        m_finished_event: TncLocalCompletionFinishedEvent;
        m_module: HMODULE;
        m_onnx_runtime_module: HMODULE;
        m_onnx_provider_module: HMODULE;
        m_session: Pointer;
        m_run_function: TncLcRun;
        m_destroy_function: TncLcDestroy;
        m_minimum_confidence: Single;
        m_ready: Boolean;
        m_last_error: string;
        procedure worker_execute;
        procedure load_runtime;
        function pop_task(out task: TncLocalCompletionTask): Boolean;
        function run_task(const task: TncLocalCompletionTask;
            out completion_result: TncLongNeuralCompletionResult): Boolean;
        procedure queue_finished(const task: TncLocalCompletionTask;
            const accepted: Boolean;
            const completion_result: TncLongNeuralCompletionResult);
        procedure deliver_finished(const task: TncLocalCompletionTask;
            const accepted: Boolean;
            const completion_result: TncLongNeuralCompletionResult);
        procedure disable(const error_text: string);
        procedure log_message(const level_text, message_text: string);
    public
        constructor create(const base_directory: string;
            const result_event: TncLocalCompletionResultEvent;
            const finished_event: TncLocalCompletionFinishedEvent = nil);
        destructor Destroy; override;
        procedure enqueue(const task: TncLocalCompletionTask);
        function ready: Boolean;
        function last_error: string;
    end;

implementation

uses
    System.IOUtils,
    System.JSON,
    System.Hash,
    System.Math,
    nc_log;

const
    c_model_threads = 4;
    c_result_timeout_ms = 40;

constructor TncLocalCompletionWorker.create(
    const owner: TncLocalCompletionHost);
begin
    inherited create(True);
    FreeOnTerminate := False;
    Priority := tpLower;
    m_owner := owner;
end;

procedure TncLocalCompletionWorker.detach_owner;
begin
    m_owner := nil;
end;

procedure TncLocalCompletionWorker.Execute;
var
    owner: TncLocalCompletionHost;
begin
    owner := m_owner;
    if owner <> nil then
    begin
        owner.worker_execute;
    end;
end;

constructor TncLocalCompletionHost.create(const base_directory: string;
    const result_event: TncLocalCompletionResultEvent;
    const finished_event: TncLocalCompletionFinishedEvent);
begin
    inherited create;
    m_base_directory := base_directory;
    m_lock := TCriticalSection.Create;
    m_wakeup := TEvent.Create(nil, False, False, '');
    m_pending_task := Default(TncLocalCompletionTask);
    m_has_pending_task := False;
    m_result_event := result_event;
    m_finished_event := finished_event;
    m_module := 0;
    m_onnx_runtime_module := 0;
    m_onnx_provider_module := 0;
    m_session := nil;
    m_run_function := nil;
    m_destroy_function := nil;
    m_minimum_confidence := 0.0;
    m_ready := False;
    m_last_error := '';
    m_worker := TncLocalCompletionWorker.create(Self);
    m_worker.Start;
end;

destructor TncLocalCompletionHost.Destroy;
begin
    m_result_event := nil;
    m_finished_event := nil;
    if m_worker <> nil then
    begin
        m_worker.Terminate;
        m_wakeup.SetEvent;
        m_worker.WaitFor;
        TThread.RemoveQueuedEvents(m_worker);
        m_worker.detach_owner;
        m_worker.Free;
        m_worker := nil;
    end;
    if (m_session <> nil) and Assigned(m_destroy_function) then
    begin
        m_destroy_function(m_session);
        m_session := nil;
    end;
    if m_module <> 0 then
    begin
        FreeLibrary(m_module);
        m_module := 0;
    end;
    if m_onnx_runtime_module <> 0 then
    begin
        FreeLibrary(m_onnx_runtime_module);
        m_onnx_runtime_module := 0;
    end;
    if m_onnx_provider_module <> 0 then
    begin
        FreeLibrary(m_onnx_provider_module);
        m_onnx_provider_module := 0;
    end;
    m_wakeup.Free;
    m_wakeup := nil;
    m_lock.Free;
    m_lock := nil;
    inherited Destroy;
end;

procedure TncLocalCompletionHost.log_message(const level_text,
    message_text: string);
begin
    append_log_line_shared(get_default_log_path,
        FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' [' + level_text +
        '] local-completion ' + message_text + sLineBreak);
end;

procedure TncLocalCompletionHost.disable(const error_text: string);
begin
    m_lock.Acquire;
    try
        m_ready := False;
        m_last_error := error_text;
    finally
        m_lock.Release;
    end;
    log_message('WARN', 'disabled: ' + error_text);
end;

procedure TncLocalCompletionHost.load_runtime;
var
    wrapper_path: string;
    runtime_path: string;
    provider_path: string;
    model_directory: string;
    model_path: string;
    index_path: string;
    manifest_path: string;
    root_value: TJSONValue;
    root_object: TJSONObject;
    gate_object: TJSONObject;
    dev_object: TJSONObject;
    index_object: TJSONObject;
    threshold_value: TJSONValue;
    format_value: TJSONValue;
    model_file_value: TJSONValue;
    model_hash_value: TJSONValue;
    vocab_hash_value: TJSONValue;
    index_file_value: TJSONValue;
    index_hash_value: TJSONValue;
    index_vocab_hash_value: TJSONValue;
    model_hash: string;
    vocab_hash: string;
    index_hash: string;
    index_vocab_hash: string;
    create_function: TncLcCreate;
    error_buffer: array[0..511] of WideChar;
begin
    wrapper_path := TPath.Combine(m_base_directory,
        'cassotis_pinyin_transformer_ort.dll');
    runtime_path := TPath.Combine(m_base_directory, 'onnxruntime.dll');
    provider_path := TPath.Combine(m_base_directory,
        'onnxruntime_providers_shared.dll');
    model_directory := TPath.Combine(m_base_directory, 'local_completion');
    model_path := TPath.Combine(model_directory,
        'local_completion_path_ranker_int8.onnx');
    index_path := TPath.Combine(model_directory,
        'local_completion_index.bin');
    manifest_path := TPath.Combine(model_directory, 'model_manifest.json');
    if not FileExists(wrapper_path) then
    begin
        raise EFileNotFoundException.Create(wrapper_path);
    end;
    if not FileExists(runtime_path) then
    begin
        raise EFileNotFoundException.Create(runtime_path);
    end;
    if not FileExists(provider_path) then
    begin
        raise EFileNotFoundException.Create(provider_path);
    end;
    if not FileExists(model_path) then
    begin
        raise EFileNotFoundException.Create(model_path);
    end;
    if not FileExists(index_path) then
    begin
        raise EFileNotFoundException.Create(index_path);
    end;
    if not FileExists(manifest_path) then
    begin
        raise EFileNotFoundException.Create(manifest_path);
    end;

    root_value := TJSONObject.ParseJSONValue(
        TFile.ReadAllText(manifest_path, TEncoding.UTF8));
    try
        if not (root_value is TJSONObject) then
        begin
            raise EInvalidOp.Create('invalid local-completion manifest');
        end;
        root_object := TJSONObject(root_value);
        format_value := root_object.GetValue('format');
        model_file_value := root_object.GetValue('model');
        if (not (format_value is TJSONNumber)) or
            (StrToIntDef(format_value.Value, 0) <> 1) or
            (not (model_file_value is TJSONString)) or
            (not SameText(model_file_value.Value,
            ExtractFileName(model_path))) then
        begin
            raise EInvalidOp.Create(
                'local-completion manifest format is invalid');
        end;
        gate_object := root_object.GetValue('gate') as TJSONObject;
        if gate_object = nil then
        begin
            raise EInvalidOp.Create('local-completion gate is absent');
        end;
        dev_object := gate_object.GetValue('dev') as TJSONObject;
        if dev_object = nil then
        begin
            raise EInvalidOp.Create('local-completion development gate is absent');
        end;
        threshold_value := dev_object.GetValue('threshold');
        if not (threshold_value is TJSONNumber) then
        begin
            raise EInvalidOp.Create('local-completion threshold is invalid');
        end;
        m_minimum_confidence := TJSONNumber(threshold_value).AsDouble;
        if IsNan(m_minimum_confidence) or IsInfinite(m_minimum_confidence) or
            (m_minimum_confidence < 0.0) or
            (m_minimum_confidence > 1000.0) then
        begin
            raise EInvalidOp.Create('local-completion threshold is out of range');
        end;
        model_hash_value := root_object.GetValue('model_sha256');
        vocab_hash_value := root_object.GetValue('vocab_sha256');
        index_object := root_object.GetValue('runtime_index') as TJSONObject;
        if (not (model_hash_value is TJSONString)) or
            (not (vocab_hash_value is TJSONString)) or
            (index_object = nil) then
        begin
            raise EInvalidOp.Create(
                'local-completion asset identity is absent');
        end;
        index_file_value := index_object.GetValue('file');
        index_hash_value := index_object.GetValue('sha256');
        index_vocab_hash_value := index_object.GetValue('vocab_sha256');
        if (not (index_file_value is TJSONString)) or
            (not SameText(index_file_value.Value,
            ExtractFileName(index_path))) or
            (not (index_hash_value is TJSONString)) or
            (not (index_vocab_hash_value is TJSONString)) then
        begin
            raise EInvalidOp.Create(
                'local-completion index identity is invalid');
        end;
        model_hash := LowerCase(model_hash_value.Value);
        vocab_hash := LowerCase(vocab_hash_value.Value);
        index_hash := LowerCase(index_hash_value.Value);
        index_vocab_hash := LowerCase(index_vocab_hash_value.Value);
        if (Length(model_hash) <> 64) or (Length(vocab_hash) <> 64) or
            (Length(index_hash) <> 64) or
            (not SameText(vocab_hash, index_vocab_hash)) then
        begin
            raise EInvalidOp.Create(
                'local-completion vocabulary identity is inconsistent');
        end;
    finally
        root_value.Free;
    end;
    if not SameText(LowerCase(THashSHA2.GetHashStringFromFile(model_path)),
        model_hash) then
    begin
        raise EInvalidOp.Create('local-completion model checksum mismatch');
    end;
    if not SameText(LowerCase(THashSHA2.GetHashStringFromFile(index_path)),
        index_hash) then
    begin
        raise EInvalidOp.Create('local-completion index checksum mismatch');
    end;

    m_onnx_provider_module := LoadLibraryEx(PChar(provider_path), 0,
        LOAD_WITH_ALTERED_SEARCH_PATH);
    if m_onnx_provider_module = 0 then
    begin
        raise EOSError.CreateFmt('LoadLibrary failed (%d): %s',
            [GetLastError, provider_path]);
    end;
    m_onnx_runtime_module := LoadLibraryEx(PChar(runtime_path), 0,
        LOAD_WITH_ALTERED_SEARCH_PATH);
    if m_onnx_runtime_module = 0 then
    begin
        raise EOSError.CreateFmt('LoadLibrary failed (%d): %s',
            [GetLastError, runtime_path]);
    end;
    m_module := LoadLibraryEx(PChar(wrapper_path), 0,
        LOAD_WITH_ALTERED_SEARCH_PATH);
    if m_module = 0 then
    begin
        raise EOSError.CreateFmt('LoadLibrary failed (%d): %s',
            [GetLastError, wrapper_path]);
    end;
    create_function := TncLcCreate(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lc_create'))));
    m_run_function := TncLcRun(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lc_run'))));
    m_destroy_function := TncLcDestroy(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lc_destroy'))));
    if (not Assigned(create_function)) or
        (not Assigned(m_run_function)) or
        (not Assigned(m_destroy_function)) then
    begin
        raise EInvalidOp.Create('invalid local-completion wrapper ABI');
    end;
    FillChar(error_buffer, SizeOf(error_buffer), 0);
    m_session := create_function(PChar(model_path), PChar(index_path),
        c_model_threads, @error_buffer[0], Length(error_buffer));
    if m_session = nil then
    begin
        raise EInvalidOp.Create(string(PWideChar(@error_buffer[0])));
    end;
    m_lock.Acquire;
    try
        m_ready := True;
        m_last_error := '';
    finally
        m_lock.Release;
    end;
    log_message('INFO', Format(
        'weight-quantized model and mapped index loaded threshold=%.4f',
        [m_minimum_confidence]));
end;

function TncLocalCompletionHost.pop_task(
    out task: TncLocalCompletionTask): Boolean;
begin
    task := Default(TncLocalCompletionTask);
    m_lock.Acquire;
    try
        Result := m_has_pending_task;
        if Result then
        begin
            task := m_pending_task;
            m_pending_task := Default(TncLocalCompletionTask);
            m_has_pending_task := False;
        end;
    finally
        m_lock.Release;
    end;
end;

function TncLocalCompletionHost.run_task(
    const task: TncLocalCompletionTask;
    out completion_result: TncLongNeuralCompletionResult): Boolean;
var
    suffix_text: array[0..127] of WideChar;
    suffix_pinyin: array[0..255] of WideChar;
    suffix_path: array[0..127] of WideChar;
    error_buffer: array[0..511] of WideChar;
    base_rank: Integer;
    confidence: Single;
    started_at: UInt64;
    elapsed_ms: UInt64;
begin
    completion_result := Default(TncLongNeuralCompletionResult);
    FillChar(suffix_text, SizeOf(suffix_text), 0);
    FillChar(suffix_pinyin, SizeOf(suffix_pinyin), 0);
    FillChar(suffix_path, SizeOf(suffix_path), 0);
    FillChar(error_buffer, SizeOf(error_buffer), 0);
    base_rank := 0;
    confidence := 0.0;
    started_at := GetTickCount64;
    Result := m_run_function(m_session,
        PChar(task.request.context_text),
        PChar(task.request.query_syllables),
        PChar(task.request.top1_text),
        PChar(task.request.top1_anchor_path),
        PChar(task.request.top2_text),
        PChar(task.request.top2_anchor_path),
        m_minimum_confidence,
        @suffix_text[0], Length(suffix_text),
        @suffix_pinyin[0], Length(suffix_pinyin),
        @suffix_path[0], Length(suffix_path),
        @base_rank, @confidence, @error_buffer[0],
        Length(error_buffer)) <> 0;
    elapsed_ms := GetTickCount64 - started_at;
    if (not Result) and (error_buffer[0] <> #0) then
    begin
        disable(string(PWideChar(@error_buffer[0])));
        Exit;
    end;
    if Result and (elapsed_ms > c_result_timeout_ms) then
    begin
        Result := False;
        Exit;
    end;
    if Result then
    begin
        completion_result.suffix_text :=
            string(PWideChar(@suffix_text[0]));
        completion_result.suffix_pinyin_path :=
            string(PWideChar(@suffix_pinyin[0]));
        completion_result.suffix_path :=
            string(PWideChar(@suffix_path[0]));
        completion_result.base_rank := base_rank;
        completion_result.confidence := confidence;
    end;
end;

procedure TncLocalCompletionHost.queue_finished(
    const task: TncLocalCompletionTask; const accepted: Boolean;
    const completion_result: TncLongNeuralCompletionResult);
var
    task_copy: TncLocalCompletionTask;
    accepted_copy: Boolean;
    result_copy: TncLongNeuralCompletionResult;
begin
    task_copy := task;
    accepted_copy := accepted;
    result_copy := completion_result;
    TThread.Queue(m_worker,
        procedure
        begin
            deliver_finished(task_copy, accepted_copy, result_copy);
        end);
end;

procedure TncLocalCompletionHost.deliver_finished(
    const task: TncLocalCompletionTask; const accepted: Boolean;
    const completion_result: TncLongNeuralCompletionResult);
var
    handler: TncLocalCompletionResultEvent;
    finished_handler: TncLocalCompletionFinishedEvent;
begin
    handler := m_result_event;
    if accepted and Assigned(handler) then
    begin
        handler(task, completion_result);
    end;
    finished_handler := m_finished_event;
    if Assigned(finished_handler) then
    begin
        finished_handler(task, accepted, completion_result);
    end;
end;

procedure TncLocalCompletionHost.worker_execute;
var
    task: TncLocalCompletionTask;
    completion_result: TncLongNeuralCompletionResult;
    accepted: Boolean;
begin
    try
        load_runtime;
    except
        on e: Exception do
        begin
            disable(e.Message);
            Exit;
        end;
    end;
    while (m_worker <> nil) and (not m_worker.Terminated) do
    begin
        if not pop_task(task) then
        begin
            m_wakeup.WaitFor(250);
            if m_worker.Terminated then
            begin
                Break;
            end;
            if not pop_task(task) then
            begin
                Continue;
            end;
        end;
        if m_worker.Terminated then
        begin
            Break;
        end;
        accepted := run_task(task, completion_result);
        // Production only needs accepted results. The optional finished event
        // lets synchronous benchmark bridges observe abstentions without
        // adding no-op main-thread callbacks to the normal Host path.
        if accepted or Assigned(m_finished_event) then
        begin
            queue_finished(task, accepted, completion_result);
        end;
        if not ready then
        begin
            Break;
        end;
    end;
end;

procedure TncLocalCompletionHost.enqueue(
    const task: TncLocalCompletionTask);
begin
    if (task.session_id = '') or
        (task.request.query_prefix = '') or
        (task.request.top1_anchor_path = '') then
    begin
        Exit;
    end;
    m_lock.Acquire;
    try
        // Keep the latest task while the model is loading, but do not keep
        // feeding a runtime that has already failed closed.
        if (not m_ready) and (m_last_error <> '') then
        begin
            Exit;
        end;
        m_pending_task := task;
        m_has_pending_task := True;
    finally
        m_lock.Release;
    end;
    m_wakeup.SetEvent;
end;

function TncLocalCompletionHost.ready: Boolean;
begin
    m_lock.Acquire;
    try
        Result := m_ready;
    finally
        m_lock.Release;
    end;
end;

function TncLocalCompletionHost.last_error: string;
begin
    m_lock.Acquire;
    try
        Result := m_last_error;
    finally
        m_lock.Release;
    end;
end;

end.

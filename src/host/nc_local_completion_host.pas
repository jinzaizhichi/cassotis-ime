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
            const phonetic_only: Integer;
            const minimum_confidence: Single;
            const output_suffix_text: PWideChar;
            const output_suffix_text_capacity: Integer;
            const output_suffix_pinyin: PWideChar;
            const output_suffix_pinyin_capacity: Integer;
            const output_suffix_path: PWideChar;
            const output_suffix_path_capacity: Integer;
            const output_base_rank: PInteger;
            const output_replace_units: PInteger;
            const output_confidence: PSingle;
            const error_text: PWideChar;
            const error_capacity: Integer): Integer; cdecl;
        TncLcRunPool = function(const handle: Pointer;
            const context, query_syllables, top1_text, top1_path,
            top2_text, top2_path: PWideChar;
            const phonetic_only: Integer;
            const output_suffix_texts: PWideChar;
            const output_suffix_text_stride: Integer;
            const output_suffix_pinyins: PWideChar;
            const output_suffix_pinyin_stride: Integer;
            const output_suffix_paths: PWideChar;
            const output_suffix_path_stride: Integer;
            const output_base_ranks: PInteger;
            const output_replace_units: PInteger;
            const output_scores: PSingle;
            const output_capacity: Integer;
            const output_abstain_score: PSingle;
            const output_candidate_count: PInteger;
            const error_text: PWideChar;
            const error_capacity: Integer): Integer; cdecl;
        TncLcDestroy = procedure(const handle: Pointer); cdecl;
        TncLcgCreate = function(const model_path, index_path: PWideChar;
            const intra_threads: Integer; const error_text: PWideChar;
            const error_capacity: Integer): Pointer; cdecl;
        TncLcgRun = function(const handle: Pointer;
            const context, query_syllables, top1_text, top2_text: PWideChar;
            const minimum_confidence: Single;
            const output_suffix_text: PWideChar;
            const output_suffix_text_capacity: Integer;
            const output_suffix_pinyin: PWideChar;
            const output_suffix_pinyin_capacity: Integer;
            const output_suffix_path: PWideChar;
            const output_suffix_path_capacity: Integer;
            const output_confidence: PSingle;
            const error_text: PWideChar;
            const error_capacity: Integer): Integer; cdecl;
        TncLcgDestroy = procedure(const handle: Pointer); cdecl;
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
        m_generator_session: Pointer;
        m_run_function: TncLcRun;
        m_run_pool_function: TncLcRunPool;
        m_destroy_function: TncLcDestroy;
        m_generator_run_function: TncLcgRun;
        m_generator_destroy_function: TncLcgDestroy;
        m_minimum_confidence: Single;
        m_result_timeout_ms: UInt64;
        m_capture_candidate_pool: Boolean;
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
            const finished_event: TncLocalCompletionFinishedEvent = nil;
            const deterministic_benchmark: Boolean = False;
            const capture_candidate_pool: Boolean = False);
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
    c_generator_minimum_confidence: Single = -2.8333864;
    c_completion_pool_capacity = 32;
    c_completion_text_stride = 128;
    c_completion_pinyin_stride = 256;
    c_completion_path_stride = 128;

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
    const finished_event: TncLocalCompletionFinishedEvent;
    const deterministic_benchmark: Boolean;
    const capture_candidate_pool: Boolean);
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
    m_generator_session := nil;
    m_run_function := nil;
    m_run_pool_function := nil;
    m_destroy_function := nil;
    m_generator_run_function := nil;
    m_generator_destroy_function := nil;
    m_minimum_confidence := 0.0;
    m_capture_candidate_pool := capture_candidate_pool;
    if deterministic_benchmark then
    begin
        m_result_timeout_ms := 0;
    end
    else
    begin
        m_result_timeout_ms := c_result_timeout_ms;
    end;
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
    if (m_generator_session <> nil) and
        Assigned(m_generator_destroy_function) then
    begin
        m_generator_destroy_function(m_generator_session);
        m_generator_session := nil;
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
    generator_model_path: string;
    index_path: string;
    manifest_path: string;
    root_value: TJSONValue;
    root_object: TJSONObject;
    gate_object: TJSONObject;
    dev_object: TJSONObject;
    index_object: TJSONObject;
    generator_object: TJSONObject;
    threshold_value: TJSONValue;
    format_value: TJSONValue;
    model_file_value: TJSONValue;
    model_hash_value: TJSONValue;
    vocab_hash_value: TJSONValue;
    index_file_value: TJSONValue;
    index_hash_value: TJSONValue;
    index_vocab_hash_value: TJSONValue;
    generator_hash_value: TJSONValue;
    model_hash: string;
    vocab_hash: string;
    index_hash: string;
    index_vocab_hash: string;
    generator_hash: string;
    create_function: TncLcCreate;
    generator_create_function: TncLcgCreate;
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
    generator_model_path := TPath.Combine(model_directory,
        'local_completion_generator_int8.onnx');
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
            (m_minimum_confidence < -1000.0) or
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
        generator_object := root_object.GetValue(
            'fallback_generator') as TJSONObject;
        generator_hash := '';
        if generator_object <> nil then
        begin
            generator_hash_value := generator_object.GetValue('model_sha256');
            if generator_hash_value is TJSONString then
            begin
                generator_hash := LowerCase(generator_hash_value.Value);
            end;
        end;
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
    if FileExists(generator_model_path) and
        ((Length(generator_hash) <> 64) or
        (not SameText(LowerCase(THashSHA2.GetHashStringFromFile(
        generator_model_path)), generator_hash))) then
    begin
        raise EInvalidOp.Create(
            'local-completion generator checksum mismatch');
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
    m_run_pool_function := TncLcRunPool(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lc_run_pool'))));
    m_destroy_function := TncLcDestroy(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lc_destroy'))));
    generator_create_function := TncLcgCreate(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lcg_create'))));
    m_generator_run_function := TncLcgRun(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lcg_run'))));
    m_generator_destroy_function := TncLcgDestroy(GetProcAddress(m_module,
        PAnsiChar(AnsiString('nc_lcg_destroy'))));
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
    if FileExists(generator_model_path) and
        Assigned(generator_create_function) and
        Assigned(m_generator_run_function) and
        Assigned(m_generator_destroy_function) then
    begin
        FillChar(error_buffer, SizeOf(error_buffer), 0);
        m_generator_session := generator_create_function(
            PChar(generator_model_path), PChar(index_path), c_model_threads,
            @error_buffer[0], Length(error_buffer));
        if m_generator_session = nil then
        begin
            log_message('WARN', 'generator disabled: ' +
                string(PWideChar(@error_buffer[0])));
        end;
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
    replace_units: Integer;
    confidence: Single;
    pool_suffix_texts: array[0..
        c_completion_pool_capacity * c_completion_text_stride - 1] of WideChar;
    pool_suffix_pinyins: array[0..
        c_completion_pool_capacity * c_completion_pinyin_stride - 1] of WideChar;
    pool_suffix_paths: array[0..
        c_completion_pool_capacity * c_completion_path_stride - 1] of WideChar;
    pool_base_ranks: array[0..c_completion_pool_capacity - 1] of Integer;
    pool_replace_units: array[0..c_completion_pool_capacity - 1] of Integer;
    pool_scores: array[0..c_completion_pool_capacity - 1] of Single;
    pool_abstain_score: Single;
    pool_candidate_count: Integer;
    pool_idx: Integer;
    second_score: Single;
    started_at: UInt64;
    elapsed_ms: UInt64;
begin
    completion_result := Default(TncLongNeuralCompletionResult);
    FillChar(suffix_text, SizeOf(suffix_text), 0);
    FillChar(suffix_pinyin, SizeOf(suffix_pinyin), 0);
    FillChar(suffix_path, SizeOf(suffix_path), 0);
    FillChar(error_buffer, SizeOf(error_buffer), 0);
    base_rank := 0;
    replace_units := 0;
    confidence := 0.0;
    pool_abstain_score := 0.0;
    pool_candidate_count := 0;
    started_at := GetTickCount64;
    if m_capture_candidate_pool and Assigned(m_run_pool_function) then
    begin
        FillChar(pool_suffix_texts, SizeOf(pool_suffix_texts), 0);
        FillChar(pool_suffix_pinyins, SizeOf(pool_suffix_pinyins), 0);
        FillChar(pool_suffix_paths, SizeOf(pool_suffix_paths), 0);
        FillChar(pool_base_ranks, SizeOf(pool_base_ranks), 0);
        FillChar(pool_replace_units, SizeOf(pool_replace_units), 0);
        FillChar(pool_scores, SizeOf(pool_scores), 0);
        if m_run_pool_function(m_session,
            PChar(task.request.context_text),
            PChar(task.request.query_syllables),
            PChar(task.request.top1_text),
            PChar(task.request.top1_anchor_path),
            PChar(task.request.top2_text),
            PChar(task.request.top2_anchor_path),
            Ord(task.request.phonetic_only),
            @pool_suffix_texts[0], c_completion_text_stride,
            @pool_suffix_pinyins[0], c_completion_pinyin_stride,
            @pool_suffix_paths[0], c_completion_path_stride,
            @pool_base_ranks[0], @pool_replace_units[0], @pool_scores[0],
            c_completion_pool_capacity, @pool_abstain_score,
            @pool_candidate_count, @error_buffer[0],
            Length(error_buffer)) <> 0 then
        begin
            pool_candidate_count := EnsureRange(pool_candidate_count, 0,
                c_completion_pool_capacity);
            SetLength(completion_result.candidates, pool_candidate_count);
            for pool_idx := 0 to pool_candidate_count - 1 do
            begin
                completion_result.candidates[pool_idx].suffix_text :=
                    string(PWideChar(@pool_suffix_texts[
                    pool_idx * c_completion_text_stride]));
                completion_result.candidates[pool_idx].suffix_pinyin_path :=
                    string(PWideChar(@pool_suffix_pinyins[
                    pool_idx * c_completion_pinyin_stride]));
                completion_result.candidates[pool_idx].suffix_path :=
                    string(PWideChar(@pool_suffix_paths[
                    pool_idx * c_completion_path_stride]));
                completion_result.candidates[pool_idx].base_rank :=
                    pool_base_ranks[pool_idx];
                completion_result.candidates[pool_idx].replace_units :=
                    pool_replace_units[pool_idx];
                completion_result.candidates[pool_idx].score :=
                    pool_scores[pool_idx];
            end;
            Result := pool_candidate_count > 0;
            if Result then
            begin
                second_score := pool_abstain_score;
                if pool_candidate_count > 1 then
                begin
                    second_score := Max(second_score, pool_scores[1]);
                end;
                confidence := pool_scores[0] - second_score;
                // The calibrated threshold may be negative. In that case the
                // joint KEEP/SWITCH/ABSTAIN model intentionally permits a
                // candidate just below ABSTAIN when its development-set
                // evidence is strong enough. Do not add a second hard gate
                // that silently discards the learned calibration.
                Result := confidence >= m_minimum_confidence;
                if Result then
                begin
                    completion_result.suffix_text :=
                        completion_result.candidates[0].suffix_text;
                    completion_result.suffix_pinyin_path :=
                        completion_result.candidates[0].suffix_pinyin_path;
                    completion_result.suffix_path :=
                        completion_result.candidates[0].suffix_path;
                    completion_result.base_rank :=
                        completion_result.candidates[0].base_rank;
                    completion_result.replace_units :=
                        completion_result.candidates[0].replace_units;
                    completion_result.confidence := confidence;
                end;
            end;
        end
        else
        begin
            Result := False;
        end;
    end
    else
    begin
        Result := m_run_function(m_session,
            PChar(task.request.context_text),
            PChar(task.request.query_syllables),
            PChar(task.request.top1_text),
            PChar(task.request.top1_anchor_path),
            PChar(task.request.top2_text),
            PChar(task.request.top2_anchor_path),
            Ord(task.request.phonetic_only),
            m_minimum_confidence,
            @suffix_text[0], Length(suffix_text),
            @suffix_pinyin[0], Length(suffix_pinyin),
            @suffix_path[0], Length(suffix_path),
            @base_rank, @replace_units, @confidence, @error_buffer[0],
            Length(error_buffer)) <> 0;
    end;
    if (not Result) and (not task.request.phonetic_only) and
        (error_buffer[0] = #0) and
        (m_generator_session <> nil) and
        Assigned(m_generator_run_function) then
    begin
        FillChar(suffix_text, SizeOf(suffix_text), 0);
        FillChar(suffix_pinyin, SizeOf(suffix_pinyin), 0);
        FillChar(suffix_path, SizeOf(suffix_path), 0);
        confidence := 0.0;
        Result := m_generator_run_function(m_generator_session,
            PChar(task.request.context_text),
            PChar(task.request.query_syllables),
            PChar(task.request.top1_text),
            PChar(task.request.top2_text),
            c_generator_minimum_confidence,
            @suffix_text[0], Length(suffix_text),
            @suffix_pinyin[0], Length(suffix_pinyin),
            @suffix_path[0], Length(suffix_path),
            @confidence, @error_buffer[0], Length(error_buffer)) <> 0;
        if Result then
        begin
            base_rank := 1;
            replace_units := 0;
        end;
    end;
    elapsed_ms := GetTickCount64 - started_at;
    if (not Result) and (error_buffer[0] <> #0) then
    begin
        disable(string(PWideChar(@error_buffer[0])));
        Exit;
    end;
    if Result and (m_result_timeout_ms > 0) and
        (elapsed_ms > m_result_timeout_ms) then
    begin
        Result := False;
        Exit;
    end;
    if Result and (completion_result.suffix_text = '') then
    begin
        completion_result.suffix_text :=
            string(PWideChar(@suffix_text[0]));
        completion_result.suffix_pinyin_path :=
            string(PWideChar(@suffix_pinyin[0]));
        completion_result.suffix_path :=
            string(PWideChar(@suffix_path[0]));
        completion_result.base_rank := base_rank;
        completion_result.replace_units := replace_units;
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

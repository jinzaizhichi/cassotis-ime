unit nc_short_context_host;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, System.SyncObjs,
    nc_short_context_ranker;

type
    TncShortContextHost = class(TInterfacedObject, IncShortContextReranker)
    private type
        TModelFormat = function: Integer; cdecl;
        TCreateModel = function(directory, error_text: PWideChar; capacity: Integer): Pointer; cdecl;
        TRunModel = function(handle: Pointer; context, query, first, second: PWideChar;
            values: PInteger; timeout_ms: Integer; audit: PDouble; audit_count: Integer;
            error_text: PWideChar; capacity: Integer): Integer; cdecl;
        TDestroyModel = procedure(handle: Pointer); cdecl;
    private
        m_directory, m_error: string;
        m_loader: TThread;
        m_signal: TEvent;
        m_lock: TCriticalSection;
        m_ready, m_stopping: Integer;
        m_module, m_ort, m_provider: HMODULE;
        m_handle: Pointer;
        m_run: TRunModel;
        m_destroy: TDestroyModel;
        m_cache_key: string;
        m_cache_switch: Boolean;
        procedure load;
    public
        constructor Create(const directory: string; background: Boolean);
        destructor Destroy; override;
        function short_context_ready: Boolean;
        function try_switch_short_context(const request: TncShortContextRequest): Boolean;
        property last_error: string read m_error;
    end;

implementation

uses System.IOUtils, System.JSON, System.Hash, nc_log;

procedure log_model_state(const message_text: string);
begin
    try
        append_log_line_shared(get_default_log_path,
            FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
            ' [INFO] short-context ' + message_text + sLineBreak);
    except
        // Diagnostic I/O must not affect model availability or host stability.
    end;
end;

constructor TncShortContextHost.Create(const directory: string; background: Boolean);
begin
    inherited Create;
    m_directory := ExpandFileName(directory);
    m_lock := TCriticalSection.Create;
    m_signal := TEvent.Create(nil, True, False, '');
    if background then
    begin
        // Do not compete with dictionary/long-model cold start. The first
        // eligible query schedules loading and immediately uses old ranking.
        m_loader := TThread.CreateAnonymousThread(procedure
            begin
                m_signal.WaitFor(INFINITE);
                if TInterlocked.CompareExchange(m_stopping, 0, 0) = 0 then load;
            end);
        m_loader.FreeOnTerminate := False;
        m_loader.Priority := tpLower;
        m_loader.Start;
    end
    else
        load;
end;

destructor TncShortContextHost.Destroy;
begin
    TInterlocked.Exchange(m_stopping, 1);
    if m_signal <> nil then m_signal.SetEvent;
    if m_loader <> nil then begin m_loader.WaitFor; m_loader.Free; end;
    if Assigned(m_destroy) and (m_handle <> nil) then m_destroy(m_handle);
    if m_module <> 0 then FreeLibrary(m_module);
    if m_ort <> 0 then FreeLibrary(m_ort);
    if m_provider <> 0 then FreeLibrary(m_provider);
    m_signal.Free;
    m_lock.Free;
    inherited;
end;

procedure TncShortContextHost.load;
const
    required_files: array[0..6] of string = ('exit0.int8.onnx',
        'exit1.int8.onnx', 'exit2.int8.onnx', 'exit3.int8.onnx',
        'tokenizer.bin', 'policy.bin', 'final.int8.onnx');
var
    root, hash_value: TJSONValue;
    manifest: TJSONObject;
    files: TJSONObject;
    path, folder, name: string;
    model_format, file_count: Integer;
    runtime_format: TModelFormat;
    create_model: TCreateModel;
    error_text: array[0..1023] of WideChar;
begin
    root := nil;
    try
        folder := TPath.Combine(m_directory, 'short_context');
        root := TJSONObject.ParseJSONValue(TFile.ReadAllText(
            TPath.Combine(folder, 'runtime_manifest.json'), TEncoding.UTF8));
        if not (root is TJSONObject) then
            raise EInvalidOp.Create('Invalid short-context manifest');
        manifest := TJSONObject(root);
        model_format := manifest.GetValue<Integer>('format', 0);
        if (not manifest.GetValue<Boolean>('enabled', False)) or
            (not (model_format in [1, 2])) or
            (manifest.GetValue<Integer>('context_characters', 0) <> 48) or
            (manifest.GetValue<Integer>('max_inference_ms', 0) <> 30) then
            raise EInvalidOp.Create('Unsupported short-context manifest');
        files := manifest.GetValue('files') as TJSONObject;
        file_count := 6;
        if model_format = 1 then Inc(file_count);
        if (files = nil) or (files.Count <> file_count) then
            raise EInvalidOp.Create('Incomplete short-context manifest');
        for name in required_files do
        begin
            if (model_format = 2) and (name = 'final.int8.onnx') then Continue;
            hash_value := files.GetValue(name);
            if not (hash_value is TJSONString) then
                raise EInvalidOp.Create('Missing short-context asset hash');
            path := TPath.Combine(folder, name);
            if not SameText(THashSHA2.GetHashStringFromFile(path), hash_value.Value) then
                raise EInvalidOp.Create('Short-context asset hash mismatch');
        end;
        m_provider := LoadLibraryEx(PChar(TPath.Combine(m_directory,
            'onnxruntime_providers_shared.dll')), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
        m_ort := LoadLibraryEx(PChar(TPath.Combine(m_directory,
            'onnxruntime.dll')), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
        m_module := LoadLibraryEx(PChar(TPath.Combine(m_directory,
            'cassotis_pinyin_transformer_ort.dll')), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
        if (m_provider = 0) or (m_ort = 0) or (m_module = 0) then
            raise EInvalidOp.Create('Short-context runtime DLL unavailable');
        runtime_format := TModelFormat(GetProcAddress(m_module, 'nc_sc_runtime_format'));
        if not Assigned(runtime_format) then
            raise EInvalidOp.Create('Short-context runtime must be rebuilt');
        if runtime_format() <> 2 then
            raise EInvalidOp.Create('Unsupported short-context runtime format');
        create_model := TCreateModel(GetProcAddress(m_module, 'nc_sc_create'));
        m_run := TRunModel(GetProcAddress(m_module, 'nc_sc_run'));
        m_destroy := TDestroyModel(GetProcAddress(m_module, 'nc_sc_destroy'));
        if not Assigned(create_model) or not Assigned(m_run) or not Assigned(m_destroy) then
            raise EInvalidOp.Create('Short-context runtime ABI unavailable');
        m_handle := create_model(PChar(folder), @error_text[0], Length(error_text));
        if m_handle = nil then raise EInvalidOp.Create(string(PChar(@error_text[0])));
        TInterlocked.Exchange(m_ready, 1);
        log_model_state('ready; final base-exact Top2; shared_segments=4; threads=1; deadline_ms=30');
    except
        on E: Exception do
        begin
            m_error := E.Message;
            log_model_state('unavailable; keeping baseline: ' + m_error);
        end;
    end;
    root.Free;
end;

function TncShortContextHost.short_context_ready: Boolean;
begin
    Result := TInterlocked.CompareExchange(m_ready, 0, 0) = 1;
    if not Result then m_signal.SetEvent;
end;

function TncShortContextHost.try_switch_short_context(const request: TncShortContextRequest): Boolean;
var
    key: string;
    value, decision: Integer;
    error_text: array[0..1023] of WideChar;
begin
    Result := False;
    // The native ABI uses terminated UTF-16 strings; never silently truncate.
    if (Pos(#0, request.context) > 0) or (Pos(#0, request.query) > 0) or
        (Pos(#0, request.first) > 0) or (Pos(#0, request.second) > 0) then Exit;
    if not short_context_ready or not m_lock.TryEnter then Exit;
    try
        key := request.context + #0 + request.query + #0 + request.first + #0 + request.second;
        for value in request.values do key := key + #0 + IntToStr(value);
        if key = m_cache_key then Exit(m_cache_switch);
        decision := m_run(m_handle, PChar(request.context), PChar(request.query),
            PChar(request.first), PChar(request.second), @request.values[0], 30,
            nil, 0, @error_text[0], Length(error_text));
        Result := decision = 1;
        // Cache only completed decisions. Timeout/unsupported inputs retain
        // the existing result and must not poison a later successful query.
        if decision >= 0 then
        begin
            m_cache_key := key;
            m_cache_switch := Result;
        end;
    finally
        m_lock.Leave;
    end;
end;

end.

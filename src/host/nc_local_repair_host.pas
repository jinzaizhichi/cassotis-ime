unit nc_local_repair_host;

interface

uses
    Winapi.Windows, System.SysUtils, System.Classes, System.SyncObjs,
    System.Generics.Collections;

type
    TncLocalRepairHost = class
    private type
        TCreateModel = function(context_path, query_path: PWideChar;
            threads: Integer; error: PWideChar; capacity: Integer): Pointer; cdecl;
        TRunModel = function(handle: Pointer; document: UInt64;
            context: PInt64; context_count: Integer; draft, pinyin: PInt64;
            count: Integer; best: PInt64; margin, edit: PSingle;
            error: PWideChar; capacity: Integer): Integer; cdecl;
        TPrepareContext = function(handle: Pointer; document: UInt64;
            context: PInt64; count: Integer; error: PWideChar;
            capacity: Integer): Integer; cdecl;
        TDestroyModel = procedure(handle: Pointer); cdecl;
        TGate = record
            probability, margin: Double;
            max_edits, max_spans: Integer;
        end;
    private
        m_base: string;
        m_state, m_run_lock: TCriticalSection;
        m_event: TEvent;
        m_worker: TThread;
        m_module: HMODULE;
        m_handle: Pointer;
        m_run: TRunModel;
        m_prepare: TPrepareContext;
        m_destroy: TDestroyModel;
        m_loaded, m_finished: Boolean;
        m_last_error: string;
        m_signature, m_context_text: string;
        m_generation, m_ready_generation: UInt64;
        m_context: TArray<Int64>;
        m_vocab: TDictionary<string, Integer>;
        m_chars, m_pinyin: TArray<string>;
        m_readings: TArray<TArray<Integer>>;
        m_empty_gate, m_document_gate: TGate;
        m_word_ratio: Double;
        m_timeout: Cardinal;
        m_cache_key, m_cache_result, m_cache_pinyin: string;
        m_profile_enabled: Boolean;
        m_profile_frequency, m_profile_ticks: Int64;
        m_profile_calls, m_profile_runs: Integer;
        procedure execute_worker;
        function load_model: Boolean;
        function align(const query_text, draft_text: string;
            out draft, pinyin: TArray<Int64>): Boolean;
    public
        constructor Create(const base_directory: string;
            const timeout_ms: Cardinal);
        destructor Destroy; override;
        procedure set_document_context(const document_key, preceding_text: string);
        function try_repair(const query_text, draft_text: string;
            const document_key, preceding_text: string;
            out repaired_text, aligned_pinyin: string;
            out minimum_word_ratio: Double): Boolean;
        function wait_until_ready(const timeout_ms: Cardinal): Boolean;
        function last_error: string;
    end;

implementation

uses System.IOUtils, System.JSON, System.Math, nc_log;

const
    c_load_library_search_dll_load_dir = $00000100;
    c_load_library_search_default_dirs = $00001000;

constructor TncLocalRepairHost.Create(const base_directory: string;
    const timeout_ms: Cardinal);
begin
    inherited Create;
    m_base := ExcludeTrailingPathDelimiter(ExpandFileName(base_directory));
    m_timeout := timeout_ms;
    m_profile_enabled := GetEnvironmentVariable('CASSOTIS_LOCAL_REPAIR_PROFILE') = '1';
    if m_profile_enabled then QueryPerformanceFrequency(m_profile_frequency);
    m_state := TCriticalSection.Create;
    m_run_lock := TCriticalSection.Create;
    m_event := TEvent.Create(nil, False, False, '');
    m_vocab := TDictionary<string, Integer>.Create;
    m_generation := 1;
    m_signature := #0;
    m_worker := TThread.CreateAnonymousThread(procedure begin execute_worker; end);
    m_worker.FreeOnTerminate := False;
    m_worker.Priority := tpLower;
    m_worker.Start;
end;

destructor TncLocalRepairHost.Destroy;
begin
    m_worker.Terminate;
    m_event.SetEvent;
    m_worker.WaitFor;
    m_worker.Free;
    if m_profile_enabled and (m_profile_frequency > 0) then
        append_log_line_shared(get_default_log_path, Format(
            '[INFO] local-repair profile calls=%d runs=%d native_total_ms=%.3f' + sLineBreak,
            [m_profile_calls, m_profile_runs, m_profile_ticks * 1000.0 / m_profile_frequency]));
    m_run_lock.Acquire;
    try
        if (m_handle <> nil) and Assigned(m_destroy) then m_destroy(m_handle);
        if m_module <> 0 then FreeLibrary(m_module);
    finally
        m_run_lock.Release;
    end;
    m_vocab.Free;
    m_event.Free;
    m_run_lock.Free;
    m_state.Free;
    inherited;
end;

function TncLocalRepairHost.load_model: Boolean;
var
    manifest, vocabulary, constraints: TJSONObject;
    path: string;
    pair: TJSONPair;
    array_value: TJSONArray;
    char_id, py_id, index: Integer;
    create_model: TCreateModel;
    error: array[0..2047] of WideChar;
    function read_gate(const value: TJSONObject): TGate;
    begin
        Result.probability := value.GetValue<Double>('edit');
        Result.margin := value.GetValue<Double>('margin');
        Result.max_edits := value.GetValue<Integer>('max_edits');
        Result.max_spans := value.GetValue<Integer>('max_spans');
        if IsNan(Result.probability) or IsInfinite(Result.probability) or
            IsNan(Result.margin) or IsInfinite(Result.margin) or
            (Result.probability < 0.5) or (Result.probability > 1) or
            (Result.margin < 0) or (Result.margin > 100) or
            (Result.max_edits < 1) or (Result.max_edits > 4) or
            (Result.max_spans < 1) or (Result.max_spans > 2) then
            raise Exception.Create('Invalid local repair confidence gate');
    end;
begin
    Result := False;
    path := TPath.Combine(m_base, 'local_repair');
    if SameText(GetEnvironmentVariable('CASSOTIS_DISABLE_LOCAL_REPAIR'), '1') or
        (not TFile.Exists(TPath.Combine(path, 'runtime_manifest.json'))) then Exit;
    manifest := TJSONObject.ParseJSONValue(TFile.ReadAllText(
        TPath.Combine(path, 'runtime_manifest.json'), TEncoding.UTF8)) as TJSONObject;
    try
        if (manifest = nil) or (not manifest.GetValue<Boolean>('enabled', False)) then Exit;
        if manifest.GetValue<Integer>('format', 0) <> 2 then
            raise Exception.Create('Unsupported local repair model format');
        m_word_ratio := manifest.GetValue<Double>('minimum_word_ratio');
        if IsNan(m_word_ratio) or IsInfinite(m_word_ratio) or
            (m_word_ratio < 0) or (m_word_ratio > 1) then
            raise Exception.Create('Invalid local repair word gate');
        m_empty_gate := read_gate(manifest.GetValue<TJSONObject>('no_context'));
        m_document_gate := read_gate(manifest.GetValue<TJSONObject>('document_context'));
    finally
        manifest.Free;
    end;
    vocabulary := TJSONObject.ParseJSONValue(TFile.ReadAllText(
        TPath.Combine(path, 'vocab.json'), TEncoding.UTF8)) as TJSONObject;
    try
        SetLength(m_chars, vocabulary.GetValue<TJSONObject>('char').Count);
        if (Length(m_chars) < 5) or (Length(m_chars) > 16384) then
            raise Exception.Create('Invalid local repair character vocabulary');
        for pair in vocabulary.GetValue<TJSONObject>('char') do
        begin
            char_id := StrToInt(pair.JsonValue.Value);
            if (char_id < 0) or (char_id >= Length(m_chars)) or
                (m_chars[char_id] <> '') then
                raise Exception.Create('Invalid local repair character ID');
            m_chars[char_id] := pair.JsonString.Value;
            m_vocab.Add(pair.JsonString.Value, char_id);
        end;
        SetLength(m_pinyin, vocabulary.GetValue<TJSONObject>('pinyin').Count);
        if (Length(m_pinyin) < 5) or (Length(m_pinyin) > 1024) then
            raise Exception.Create('Invalid local repair pinyin vocabulary');
        for pair in vocabulary.GetValue<TJSONObject>('pinyin') do
        begin
            py_id := StrToInt(pair.JsonValue.Value);
            if (py_id < 0) or (py_id >= Length(m_pinyin)) or
                (m_pinyin[py_id] <> '') then
                raise Exception.Create('Invalid local repair pinyin ID');
            m_pinyin[py_id] := pair.JsonString.Value;
        end;
    finally
        vocabulary.Free;
    end;
    SetLength(m_readings, Length(m_chars));
    constraints := TJSONObject.ParseJSONValue(TFile.ReadAllText(
        TPath.Combine(path, 'readings.json'), TEncoding.UTF8)) as TJSONObject;
    try
        for pair in constraints do
        begin
            py_id := StrToInt(pair.JsonString.Value);
            if (py_id < 4) or (py_id >= Length(m_pinyin)) then Exit;
            array_value := pair.JsonValue as TJSONArray;
            for index := 0 to array_value.Count - 1 do
            begin
                char_id := StrToInt(array_value.Items[index].Value);
                if (char_id < 4) or (char_id >= Length(m_chars)) then Exit;
                m_readings[char_id] := m_readings[char_id] + [py_id];
            end;
        end;
    finally
        constraints.Free;
    end;
    m_module := LoadLibraryEx(PChar(TPath.Combine(m_base,
        'cassotis_pinyin_transformer_ort.dll')), 0,
        c_load_library_search_dll_load_dir or c_load_library_search_default_dirs);
    if m_module = 0 then
        raise Exception.Create('Local repair bridge: ' + SysErrorMessage(GetLastError));
    create_model := GetProcAddress(m_module, 'cassotis_lr_create');
    m_run := GetProcAddress(m_module, 'cassotis_lr_run');
    m_prepare := GetProcAddress(m_module, 'cassotis_lr_prepare_context');
    m_destroy := GetProcAddress(m_module, 'cassotis_lr_destroy');
    if (not Assigned(create_model)) or (not Assigned(m_run)) or
        (not Assigned(m_prepare)) or (not Assigned(m_destroy)) then
        raise Exception.Create('Local repair bridge exports are missing');
    error[0] := #0;
    m_handle := create_model(PChar(TPath.Combine(path, 'context_int8.onnx')),
        PChar(TPath.Combine(path, 'query_int8.onnx')), 2, @error[0], Length(error));
    Result := m_handle <> nil;
    if not Result then raise Exception.Create('Local repair initialization: ' + string(error));
end;

procedure TncLocalRepairHost.execute_worker;
var
    loaded: Boolean;
    text, character: string;
    generation: UInt64;
    ids: TArray<Int64>;
    index, char_id, output_index: Integer;
    error: array[0..2047] of WideChar;
begin
    try
        loaded := load_model;
    except
        on problem: Exception do
        begin
            loaded := False;
            m_state.Acquire;
            try m_last_error := problem.Message; finally m_state.Release; end;
        end;
    end;
    m_state.Acquire;
    try
        m_loaded := loaded;
        m_finished := not loaded;
    finally
        m_state.Release;
    end;
    if not loaded then
    begin
        if last_error <> '' then
            append_log_line_shared(get_default_log_path,
                '[WARN] local-repair disabled: ' + last_error + sLineBreak);
        Exit;
    end;
    append_log_line_shared(get_default_log_path,
        '[INFO] local-repair INT8 graphs loaded in host; context is background-cached' + sLineBreak);
    while not TThread.CurrentThread.CheckTerminated do
    begin
        m_state.Acquire;
        try
            text := m_context_text;
            generation := m_generation;
        finally
            m_state.Release;
        end;
        SetLength(ids, Length(text) + 2);
        ids[0] := 3;
        index := 1;
        output_index := 1;
        while index <= Length(text) do
        begin
            character := text[index];
            if (Ord(text[index]) >= $D800) and (Ord(text[index]) <= $DBFF) and
                (index < Length(text)) and (Ord(text[index + 1]) >= $DC00) and
                (Ord(text[index + 1]) <= $DFFF) then
            begin
                character := Copy(text, index, 2);
                Inc(index);
            end;
            if not m_vocab.TryGetValue(character, char_id) then char_id := 1;
            ids[output_index] := char_id;
            Inc(output_index);
            Inc(index);
        end;
        SetLength(ids, output_index + 1);
        ids[High(ids)] := 2;
        m_run_lock.Acquire;
        try
            error[0] := #0;
            try
                loaded := m_prepare(m_handle, generation, @ids[0], Length(ids),
                    @error[0], Length(error)) = 1;
            except
                loaded := False;
            end;
        finally
            m_run_lock.Release;
        end;
        m_state.Acquire;
        try
            if loaded and (generation = m_generation) then
            begin
                m_context := ids;
                m_ready_generation := generation;
            end;
            m_finished := True;
            if not loaded then
            begin
                m_loaded := False;
                m_last_error := 'Context preparation failed: ' + string(error);
            end;
        finally
            m_state.Release;
        end;
        if not loaded then Exit;
        repeat
            m_event.WaitFor(500);
            m_state.Acquire;
            try loaded := generation <> m_generation; finally m_state.Release; end;
        until loaded or TThread.CurrentThread.CheckTerminated;
    end;
end;

procedure TncLocalRepairHost.set_document_context(const document_key,
    preceding_text: string);
var
    text, signature: string;
begin
    text := '';
    if document_key <> '' then text := Copy(preceding_text,
        Max(1, Length(preceding_text) - 255), 256);
    signature := document_key + #0 + text;
    m_state.Acquire;
    try
        if signature = m_signature then Exit;
        m_signature := signature;
        m_context_text := text;
        Inc(m_generation);
        m_ready_generation := 0;
        m_context := nil;
        m_cache_key := '';
        m_cache_result := '';
        m_cache_pinyin := '';
    finally
        m_state.Release;
    end;
    m_event.SetEvent;
end;

function TncLocalRepairHost.align(const query_text, draft_text: string;
    out draft, pinyin: TArray<Int64>): Boolean;
type TGrid = TArray<TArray<Integer>>;
var
    raw, compact, reading: string;
    boundary: TArray<Boolean>;
    counts, previous_offset, previous_py: TGrid;
    i, j, k, char_id, py_id, finish: Integer;
    valid: Boolean;
begin
    Result := False;
    if (Length(query_text) > 280) or (Length(draft_text) < 6) or
        (Length(draft_text) > 40) then Exit;
    raw := LowerCase(query_text);
    SetLength(boundary, Length(raw) + 1);
    compact := '';
    for i := 1 to Length(raw) do
    begin
        if raw[i] = '''' then boundary[Length(compact)] := True
        else if CharInSet(raw[i], ['a'..'z']) then compact := compact + raw[i]
        else Exit;
    end;
    if (Length(compact) > 240) or (Length(draft_text) < 6) or
        (Length(draft_text) > 40) then Exit;
    SetLength(draft, Length(draft_text));
    SetLength(pinyin, Length(draft_text));
    SetLength(counts, Length(draft_text) + 1);
    SetLength(previous_offset, Length(counts));
    SetLength(previous_py, Length(counts));
    for i := 0 to High(counts) do
    begin
        SetLength(counts[i], Length(compact) + 1);
        SetLength(previous_offset[i], Length(compact) + 1);
        SetLength(previous_py[i], Length(compact) + 1);
    end;
    counts[0][0] := 1;
    for i := 0 to Length(draft_text) - 1 do
    begin
        if (not m_vocab.TryGetValue(draft_text[i + 1], char_id)) or (char_id < 4) then Exit;
        draft[i] := char_id;
        for j := 0 to Length(compact) - 1 do
        begin
            if counts[i][j] = 0 then Continue;
            for py_id in m_readings[char_id] do
            begin
                reading := m_pinyin[py_id];
                finish := j + Length(reading);
                if (finish > Length(compact)) or
                    (Copy(compact, j + 1, Length(reading)) <> reading) then Continue;
                valid := True;
                for k := j + 1 to finish - 1 do
                    if boundary[k] then valid := False;
                if not valid then Continue;
                counts[i + 1][finish] := Min(2, counts[i + 1][finish] + counts[i][j]);
                previous_offset[i + 1][finish] := j;
                previous_py[i + 1][finish] := py_id;
            end;
        end;
    end;
    j := Length(compact);
    if counts[Length(draft_text)][j] <> 1 then Exit;
    for i := Length(draft_text) downto 1 do
    begin
        pinyin[i - 1] := previous_py[i][j];
        j := previous_offset[i][j];
    end;
    Result := True;
end;

function TncLocalRepairHost.try_repair(const query_text, draft_text: string;
    const document_key, preceding_text: string;
    out repaired_text, aligned_pinyin: string; out minimum_word_ratio: Double): Boolean;
var
    draft, pinyin, best, context: TArray<Int64>;
    margins, edits: TArray<Single>;
    generation, started: UInt64;
    profile_started, profile_finished: Int64;
    gate: TGate;
    key, text, signature: string;
    i, count, spans, reading: Integer;
    changed, previous_changed, reading_valid: Boolean;
    error: array[0..2047] of WideChar;
begin
    Result := False;
    repaired_text := '';
    aligned_pinyin := '';
    minimum_word_ratio := 1;
    text := '';
    if document_key <> '' then text := Copy(preceding_text,
        Max(1, Length(preceding_text) - 255), 256);
    signature := document_key + #0 + text;
    // One model is shared by engine sessions; bind every query to its own
    // document, even when another session was the most recent cache producer.
    set_document_context(document_key, preceding_text);
    m_state.Acquire;
    try
        if m_profile_enabled then
        begin
            Inc(m_profile_calls);
            if ((m_profile_calls mod 1024) = 0) and (m_profile_frequency > 0) then
                append_log_line_shared(get_default_log_path, Format(
                    '[INFO] local-repair progress calls=%d runs=%d native_total_ms=%.3f' + sLineBreak,
                    [m_profile_calls, m_profile_runs,
                    m_profile_ticks * 1000.0 / m_profile_frequency]));
        end;
        if (not m_loaded) or (m_signature <> signature) or
            (m_ready_generation <> m_generation) then Exit;
        generation := m_generation;
        context := m_context;
        gate := m_empty_gate;
        minimum_word_ratio := m_word_ratio;
        if m_context_text <> '' then gate := m_document_gate;
        key := UIntToStr(generation) + #0 + query_text + #0 + draft_text;
        if key = m_cache_key then
        begin
            repaired_text := m_cache_result;
            aligned_pinyin := m_cache_pinyin;
            Result := repaired_text <> '';
            Exit;
        end;
    finally
        m_state.Release;
    end;
    if not align(query_text, draft_text, draft, pinyin) then Exit;
    if not m_run_lock.TryEnter then Exit;
    try
        m_state.Acquire;
        try
            if (generation <> m_generation) or
                (generation <> m_ready_generation) then Exit;
        finally
            m_state.Release;
        end;
        SetLength(best, Length(draft));
        SetLength(margins, Length(draft));
        SetLength(edits, Length(draft));
        started := GetTickCount64;
        if m_profile_enabled then QueryPerformanceCounter(profile_started);
        try
            if m_run(m_handle, generation, @context[0], Length(context),
                @draft[0], @pinyin[0], Length(draft), @best[0], @margins[0],
                @edits[0], @error[0], Length(error)) <> 1 then Exit;
        finally
            if m_profile_enabled then
            begin
                QueryPerformanceCounter(profile_finished);
                Inc(m_profile_runs);
                Inc(m_profile_ticks, profile_finished - profile_started);
            end;
        end;
        if (m_timeout > 0) and (GetTickCount64 - started > m_timeout) then Exit;
    finally
        m_run_lock.Release;
    end;
    text := draft_text;
    count := 0;
    spans := 0;
    previous_changed := False;
    for i := 0 to High(draft) do
    begin
        if IsNan(margins[i]) or IsInfinite(margins[i]) or
            IsNan(edits[i]) or IsInfinite(edits[i]) then Exit;
        changed := (best[i] <> draft[i]) and (edits[i] >= gate.probability) and
            (margins[i] >= gate.margin);
        if changed then
        begin
            if (best[i] < 4) or (best[i] >= Length(m_chars)) or
                (Length(m_chars[best[i]]) <> 1) then Exit;
            reading_valid := False;
            for reading in m_readings[best[i]] do
                if reading = pinyin[i] then reading_valid := True;
            if not reading_valid then Exit;
            text[i + 1] := m_chars[best[i]][1];
            Inc(count);
            if not previous_changed then Inc(spans);
        end;
        previous_changed := changed;
    end;
    if (count = 0) or (count > gate.max_edits) or (spans > gate.max_spans) then text := '';
    for i := 0 to High(pinyin) do
    begin
        if aligned_pinyin <> '' then aligned_pinyin := aligned_pinyin + #3;
        aligned_pinyin := aligned_pinyin + m_pinyin[pinyin[i]];
    end;
    m_state.Acquire;
    try
        if generation <> m_generation then Exit;
        m_cache_key := key;
        m_cache_result := text;
        m_cache_pinyin := aligned_pinyin;
        repaired_text := text;
        Result := text <> '';
    finally
        m_state.Release;
    end;
end;

function TncLocalRepairHost.wait_until_ready(const timeout_ms: Cardinal): Boolean;
var started: UInt64;
begin
    started := GetTickCount64;
    repeat
        m_state.Acquire;
        try Result := m_finished and ((not m_loaded) or
            (m_ready_generation = m_generation)); finally m_state.Release; end;
        if Result then Exit;
        Sleep(2);
    until GetTickCount64 - started >= timeout_ms;
end;

function TncLocalRepairHost.last_error: string;
begin
    m_state.Acquire;
    try Result := m_last_error; finally m_state.Release; end;
end;

end.

unit nc_tsf_upgrade_scan;

interface

uses
    Winapi.Windows,
    System.Generics.Collections;

type
    TncTsfModuleComparison = (tmc_same, tmc_changed, tmc_unknown);

    TncTsfUpgradeInspector = class
    private
        m_incoming_hashes: TDictionary<string, string>;
        m_comparisons: TDictionary<string, TncTsfModuleComparison>;
    public
        constructor Create(const incoming_dir: string);
        destructor Destroy; override;
        function CompareModule(const loaded_path: string): TncTsfModuleComparison;
    end;

function nc_is_tsf_module_name(const name: string): Boolean;
function nc_resolve_tsf_module_path(const loaded_path: string;
    out canonical_path: string; out error_code: DWORD): Boolean;
function nc_process_tsf_module_paths(const process_id: DWORD;
    out paths: TArray<string>; out error_code: DWORD): Boolean;

implementation

uses
    Winapi.TlHelp32,
    System.SysUtils,
    System.Hash;

function nc_is_tsf_module_name(const name: string): Boolean;
begin
    Result := SameText(name, 'cassotis_ime_svr.dll') or
        SameText(name, 'cassotis_ime_svr32.dll');
end;

function nc_resolve_tsf_module_path(const loaded_path: string;
    out canonical_path: string; out error_code: DWORD): Boolean;
var
    name, path: string;
    buffer: TArray<Char>;
    count: DWORD;
    known_name: Boolean;
begin
    Result := False;
    canonical_path := '';
    error_code := ERROR_SUCCESS;
    name := ExtractFileName(loaded_path);
    known_name := nc_is_tsf_module_name(name);
    if not known_name and ((Pos('~', name) = 0) or
        not SameText(ExtractFileExt(name), '.dll')) then
        Exit;

    // Module snapshots retain the 8.3 spelling used by COM/LoadLibrary.
    // Resolve it before identifying or hashing the DLL, not by alias pattern.
    path := loaded_path;
    count := GetLongPathName(PChar(path), nil, 0);
    if (count > 0) and (count <= 32768) then
    begin
        SetLength(buffer, count);
        count := GetLongPathName(PChar(path), @buffer[0], Length(buffer));
        if (count > 0) and (count < DWORD(Length(buffer))) then
            SetString(path, PChar(@buffer[0]), count)
        else
            error_code := ERROR_INVALID_DATA;
    end
    else if count = 0 then
        error_code := GetLastError
    else
        error_code := ERROR_FILENAME_EXCED_RANGE;

    if error_code <> ERROR_SUCCESS then
    begin
        // Known long names can still be reported as unverified by the hash
        // comparison. An unresolved alias must not silently mean "no TSF".
        if not known_name then
            Exit;
        error_code := ERROR_SUCCESS;
    end;
    Result := nc_is_tsf_module_name(ExtractFileName(path));
    if Result then
        canonical_path := path;
end;

function try_file_hash(const path: string; out hash: string): Boolean;
begin
    hash := '';
    try
        hash := THashSHA2.GetHashStringFromFile(path, THashSHA2.TSHA2Version.SHA256);
    except
        Exit(False);
    end;
    Result := hash <> '';
end;

constructor TncTsfUpgradeInspector.Create(const incoming_dir: string);
var
    name, hash: string;
begin
    inherited Create;
    m_incoming_hashes := TDictionary<string, string>.Create;
    m_comparisons := TDictionary<string, TncTsfModuleComparison>.Create;
    for name in ['cassotis_ime_svr.dll', 'cassotis_ime_svr32.dll'] do
    begin
        if not try_file_hash(IncludeTrailingPathDelimiter(incoming_dir) + name, hash) then
            raise EInOutError.Create('Cannot hash incoming TSF module: ' + name);
        m_incoming_hashes.Add(name, hash);
    end;
end;

destructor TncTsfUpgradeInspector.Destroy;
begin
    m_comparisons.Free;
    m_incoming_hashes.Free;
    inherited;
end;

function TncTsfUpgradeInspector.CompareModule(const loaded_path: string): TncTsfModuleComparison;
var
    key, incoming_hash, loaded_hash, canonical_path: string;
    error_code: DWORD;
begin
    Result := tmc_unknown;
    if not nc_resolve_tsf_module_path(loaded_path, canonical_path, error_code) then
        Exit;
    key := LowerCase(canonical_path);
    if m_comparisons.TryGetValue(key, Result) then
        Exit;
    Result := tmc_unknown;
    if m_incoming_hashes.TryGetValue(LowerCase(ExtractFileName(canonical_path)), incoming_hash) and
        try_file_hash(canonical_path, loaded_hash) then
    begin
        if SameText(incoming_hash, loaded_hash) then
            Result := tmc_same
        else
            Result := tmc_changed;
    end;
    // One hash per path, even when dozens of browser processes load that DLL.
    m_comparisons.Add(key, Result);
end;

function nc_process_tsf_module_paths(const process_id: DWORD;
    out paths: TArray<string>; out error_code: DWORD): Boolean;
const
    c_snap_module32 = $00000010;
var
    snapshot: THandle;
    entry: TModuleEntry32;
    attempt: Integer;
    found: TList<string>;
    canonical_path: string;
    path_error, unresolved_error: DWORD;
begin
    paths := nil;
    Result := False;
    error_code := ERROR_SUCCESS;
    for attempt := 1 to 4 do
    begin
        snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE or c_snap_module32,
            process_id);
        if snapshot <> INVALID_HANDLE_VALUE then
            Break;
        error_code := GetLastError;
        if error_code <> ERROR_BAD_LENGTH then
            Exit;
        Sleep(1);
    end;
    if snapshot = INVALID_HANDLE_VALUE then
        Exit;
    found := TList<string>.Create;
    unresolved_error := ERROR_SUCCESS;
    try
        FillChar(entry, SizeOf(entry), 0);
        entry.dwSize := SizeOf(entry);
        if Module32First(snapshot, entry) then
        begin
            repeat
                if nc_resolve_tsf_module_path(string(entry.szExePath),
                    canonical_path, path_error) then
                    found.Add(canonical_path)
                else if (path_error <> ERROR_SUCCESS) and
                    (unresolved_error = ERROR_SUCCESS) then
                    unresolved_error := path_error;
            until not Module32Next(snapshot, entry);
        end;
        error_code := GetLastError;
        Result := error_code = ERROR_NO_MORE_FILES;
        if Result then
        begin
            error_code := unresolved_error;
            Result := error_code = ERROR_SUCCESS;
        end;
        paths := found.ToArray;
    finally
        found.Free;
        CloseHandle(snapshot);
    end;
end;

end.

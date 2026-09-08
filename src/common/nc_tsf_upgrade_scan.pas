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
    key, incoming_hash, loaded_hash: string;
begin
    key := LowerCase(loaded_path);
    if m_comparisons.TryGetValue(key, Result) then
        Exit;
    Result := tmc_unknown;
    if m_incoming_hashes.TryGetValue(LowerCase(ExtractFileName(loaded_path)), incoming_hash) and
        try_file_hash(loaded_path, loaded_hash) then
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
    try
        FillChar(entry, SizeOf(entry), 0);
        entry.dwSize := SizeOf(entry);
        if Module32First(snapshot, entry) then
        begin
            repeat
                if nc_is_tsf_module_name(entry.szModule) then
                    found.Add(string(entry.szExePath));
            until not Module32Next(snapshot, entry);
        end;
        error_code := GetLastError;
        Result := error_code = ERROR_NO_MORE_FILES;
        if Result then
            error_code := ERROR_SUCCESS;
        paths := found.ToArray;
    finally
        found.Free;
        CloseHandle(snapshot);
    end;
end;

end.

unit nc_runtime_location;

interface

uses
    Winapi.Windows;

const
    c_nc_tsf_registration_key =
        'CLSID\{38D40A05-DCDB-49FB-81A4-C8745882DC21}\InprocServer32';
    c_nc_runtime_host_name = 'cassotis_ime_host.exe';

function nc_select_runtime_host(const module_dir, registered_dll: string;
    const registration_exists: Boolean; out host_path: string;
    out error_code: DWORD): Boolean;
function nc_read_runtime_registration(const root: HKEY; const key_path: string;
    const registry_view: REGSAM; out dll_path: string;
    out error_code: DWORD): Boolean;
function nc_resolve_runtime_host(const module_dir: string; out host_path: string;
    out error_code: DWORD; out resolution_detail: string): Boolean;

implementation

uses
    System.SysUtils;

function absolute_file_path(const value: string): Boolean;
begin
    Result := ((Length(value) >= 3) and CharInSet(value[1], ['A'..'Z', 'a'..'z']) and
        (value[2] = ':') and CharInSet(value[3], ['\', '/'])) or
        ((Length(value) > 2) and (Copy(value, 1, 2) = '\\'));
end;

function nc_select_runtime_host(const module_dir, registered_dll: string;
    const registration_exists: Boolean; out host_path: string;
    out error_code: DWORD): Boolean;
var
    dll_path, directory, file_name: string;
    long_path: TArray<Char>;
    path_length: DWORD;
begin
    Result := False;
    host_path := '';
    error_code := ERROR_INVALID_DATA;
    if registration_exists then
    begin
        dll_path := Trim(registered_dll);
        if (Length(dll_path) >= 2) and (dll_path[1] = '"') and
            (dll_path[Length(dll_path)] = '"') then
            dll_path := Copy(dll_path, 2, Length(dll_path) - 2);
        if not absolute_file_path(dll_path) then
            Exit;
        // Delphi's COM registration uses 8.3 aliases for paths with spaces.
        // Resolve the real name before validating it; never accept CASSOT~*.DLL
        // by pattern alone, since it might refer to an unrelated library.
        path_length := GetLongPathName(PChar(dll_path), nil, 0);
        if (path_length > 0) and (path_length <= 32768) then
        begin
            SetLength(long_path, path_length);
            path_length := GetLongPathName(PChar(dll_path),
                @long_path[0], Length(long_path));
            if (path_length > 0) and (path_length < DWORD(Length(long_path))) then
                SetString(dll_path, PChar(@long_path[0]), path_length);
        end;
        file_name := ExtractFileName(dll_path);
        if ((not SameText(file_name, 'cassotis_ime_svr.dll')) and
            (not SameText(file_name, 'cassotis_ime_svr32.dll'))) then
            Exit;
        directory := ExtractFileDir(dll_path);
        if not FileExists(dll_path) then
        begin
            error_code := ERROR_FILE_NOT_FOUND;
            Exit;
        end;
    end
    else
        directory := module_dir;

    if not absolute_file_path(directory) then
        Exit;
    host_path := IncludeTrailingPathDelimiter(directory) + c_nc_runtime_host_name;
    if not FileExists(host_path) then
    begin
        // A broken active installation must not revive an adjacent old host.
        host_path := '';
        error_code := ERROR_FILE_NOT_FOUND;
        Exit;
    end;
    error_code := ERROR_SUCCESS;
    Result := True;
end;

function nc_read_runtime_registration(const root: HKEY; const key_path: string;
    const registry_view: REGSAM; out dll_path: string;
    out error_code: DWORD): Boolean;
var
    key: HKEY;
    value_type, byte_count, expanded_size: DWORD;
    buffer, expanded: TArray<Char>;
begin
    Result := False;
    dll_path := '';
    key := 0;
    error_code := RegOpenKeyEx(root, PChar(key_path), 0,
        KEY_QUERY_VALUE or registry_view, key);
    if error_code <> ERROR_SUCCESS then
        Exit;
    try
        value_type := 0;
        byte_count := 0;
        error_code := RegQueryValueEx(key, nil, nil, @value_type, nil, @byte_count);
        // The key exists. An empty/broken default is not an unregistered runtime.
        if error_code = ERROR_FILE_NOT_FOUND then
            error_code := ERROR_INVALID_DATA;
        if error_code <> ERROR_SUCCESS then
            Exit;
        if (byte_count < SizeOf(Char)) or (byte_count mod SizeOf(Char) <> 0) or
            (byte_count > 65536) or not (value_type in [REG_SZ, REG_EXPAND_SZ]) then
        begin
            error_code := ERROR_INVALID_DATA;
            Exit;
        end;
        SetLength(buffer, byte_count div SizeOf(Char) + 1);
        error_code := RegQueryValueEx(key, nil, nil, @value_type,
            PByte(@buffer[0]), @byte_count);
        // A value deleted/replaced during an upgrade is not absent registration.
        if error_code = ERROR_FILE_NOT_FOUND then
            error_code := ERROR_INVALID_DATA;
        if error_code <> ERROR_SUCCESS then
            Exit;
        if (byte_count < SizeOf(Char)) or (byte_count mod SizeOf(Char) <> 0) or
            not (value_type in [REG_SZ, REG_EXPAND_SZ]) then
        begin
            error_code := ERROR_INVALID_DATA;
            Exit;
        end;
        dll_path := string(PChar(@buffer[0]));
        if value_type = REG_EXPAND_SZ then
        begin
            expanded_size := ExpandEnvironmentStrings(PChar(dll_path), nil, 0);
            if (expanded_size = 0) or (expanded_size > 32768) then
            begin
                error_code := ERROR_INVALID_DATA;
                Exit;
            end;
            SetLength(expanded, expanded_size);
            expanded_size := ExpandEnvironmentStrings(PChar(dll_path),
                @expanded[0], Length(expanded));
            if (expanded_size = 0) or (expanded_size > DWORD(Length(expanded))) then
            begin
                error_code := ERROR_INVALID_DATA;
                Exit;
            end;
            dll_path := string(PChar(@expanded[0]));
        end;
        Result := True;
    finally
        RegCloseKey(key);
    end;
end;

function nc_resolve_runtime_host(const module_dir: string; out host_path: string;
    out error_code: DWORD; out resolution_detail: string): Boolean;
var
    dll_path: string;
    found: Boolean;
    registry_view: REGSAM;
begin
    host_path := '';
    // The host is Win64 even for a Win32 text service. HKCR observes the user's
    // effective COM registration rather than bypassing a per-user override.
    registry_view := KEY_WOW64_64KEY;
    found := nc_read_runtime_registration(HKEY_CLASSES_ROOT,
        c_nc_tsf_registration_key, registry_view, dll_path, error_code);
    if not found and (error_code in [ERROR_FILE_NOT_FOUND, ERROR_PATH_NOT_FOUND]) then
    begin
        registry_view := KEY_WOW64_32KEY;
        found := nc_read_runtime_registration(HKEY_CLASSES_ROOT,
            c_nc_tsf_registration_key, registry_view, dll_path, error_code);
    end;
    resolution_detail := Format('registry=HKCR view=0x%x registered_dll=[%s] read_error=%d',
        [registry_view, dll_path, error_code]);
    if not found and not (error_code in [ERROR_FILE_NOT_FOUND, ERROR_PATH_NOT_FOUND]) then
        Exit(False);
    // Unregistered development/portable builds retain their adjacent host.
    // Once registered, failure is explicit; no silent downgrade is allowed.
    Result := nc_select_runtime_host(module_dir, dll_path, found,
        host_path, error_code);
    if not found then
        resolution_detail := resolution_detail + ' unregistered_adjacent_runtime';
end;

end.

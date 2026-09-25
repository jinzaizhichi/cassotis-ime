unit nc_log;

interface

uses
    System.SysUtils,
    System.Classes,
    System.IOUtils,
    Winapi.Windows,
    nc_types;

type
    TncLogger = class
    private
        m_log_path: string;
        m_level: TncLogLevel;
        m_max_size_kb: Integer;
        procedure write_line(const level: TncLogLevel; const msg: string);
        function level_to_text(const level: TncLogLevel): string;
    public
        constructor create(const log_path: string); overload;
        constructor create(const log_path: string; const max_size_kb: Integer); overload;
        procedure set_level(const level: TncLogLevel);
        procedure debug(const msg: string);
        procedure info(const msg: string);
        procedure warn(const msg: string);
        procedure error(const msg: string);
        property log_path: string read m_log_path;
        property level: TncLogLevel read m_level write m_level;
    end;

function get_default_log_path: string;
function nc_log_path_is_under_program_files(const path: string): Boolean;
procedure append_log_line_shared(const log_path: string; const line: string; const max_size_kb: Integer = 0);

implementation

uses
    System.Hash,
    Winapi.ActiveX,
    Winapi.KnownFolders,
    Winapi.ShlObj;

const
    c_log_mutex_timeout_ms = 250;
    // After a timed-out wait, do not stall every later line for the full
    // timeout; the holder may be a suspended or hung process.
    c_log_mutex_stall_backoff_ms = 10000;

var
    g_log_mutex_stall_tick: UInt64 = 0;

function get_log_mutex_name(const log_path: string): string;
begin
    Result := Format('Local\cassotis_ime_log_%s',
        [IntToHex(THashBobJenkins.GetHashValue(LowerCase(Trim(log_path))), 8)]);
end;

function acquire_log_mutex(const log_path: string): THandle;
var
    wait_result: DWORD;
    timeout_ms: DWORD;
    stall_tick: UInt64;
begin
    Result := CreateMutex(nil, False, PChar(get_log_mutex_name(log_path)));
    if Result = 0 then
    begin
        Exit;
    end;
    timeout_ms := c_log_mutex_timeout_ms;
    stall_tick := g_log_mutex_stall_tick;
    if (stall_tick <> 0) and (GetTickCount64 - stall_tick < c_log_mutex_stall_backoff_ms) then
    begin
        timeout_ms := 0;
    end;
    wait_result := WaitForSingleObject(Result, timeout_ms);
    if (wait_result <> WAIT_OBJECT_0) and (wait_result <> WAIT_ABANDONED) then
    begin
        if wait_result = WAIT_TIMEOUT then
        begin
            g_log_mutex_stall_tick := GetTickCount64;
        end;
        CloseHandle(Result);
        Result := 0;
    end
    else
    begin
        g_log_mutex_stall_tick := 0;
    end;
end;

procedure release_log_mutex(var mutex_handle: THandle);
begin
    if mutex_handle <> 0 then
    begin
        ReleaseMutex(mutex_handle);
        CloseHandle(mutex_handle);
        mutex_handle := 0;
    end;
end;

function write_bytes_to_handle(const handle: THandle; const bytes: TBytes): Boolean;
var
    written: DWORD;
begin
    Result := True;
    if Length(bytes) = 0 then
    begin
        Exit;
    end;
    written := 0;
    Result := WriteFile(handle, bytes[0], Length(bytes), written, nil) and (written = DWORD(Length(bytes)));
end;

function try_open_log_handle(const log_path: string; out handle: THandle): Boolean;
begin
    handle := CreateFile(PChar(log_path), GENERIC_READ or FILE_APPEND_DATA,
        FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE, nil, OPEN_ALWAYS,
        FILE_ATTRIBUTE_NORMAL, 0);
    Result := handle <> INVALID_HANDLE_VALUE;
end;

procedure append_log_line_shared(const log_path: string; const line: string; const max_size_kb: Integer = 0);
var
    dir_path: string;
    rotated_path: string;
    handle: THandle;
    mutex_handle: THandle;
    current_size: Int64;
    preamble: TBytes;
    utf8_bytes: TBytes;
begin
    if log_path = '' then
    begin
        Exit;
    end;

    mutex_handle := 0;
    handle := INVALID_HANDLE_VALUE;
    try
        dir_path := ExtractFileDir(log_path);
        if dir_path <> '' then
        begin
            ForceDirectories(dir_path);
        end;

        // The mutex only serializes rotation. FILE_APPEND_DATA writes land at
        // the end of file atomically, so an unavailable mutex (a holder that
        // is suspended or hung) must not silently drop the line.
        mutex_handle := acquire_log_mutex(log_path);
        try
            if (mutex_handle <> 0) and (max_size_kb > 0) and FileExists(log_path) then
            begin
                if try_open_log_handle(log_path, handle) then
                begin
                    try
                        current_size := 0;
                        if GetFileSizeEx(handle, current_size) and (current_size > Int64(max_size_kb) * 1024) then
                        begin
                            CloseHandle(handle);
                            handle := INVALID_HANDLE_VALUE;
                            rotated_path := log_path + '.1';
                            try
                                if FileExists(rotated_path) then
                                begin
                                    TFile.Delete(rotated_path);
                                end;
                            except
                            end;
                            try
                                TFile.Move(log_path, rotated_path);
                            except
                            end;
                        end;
                    finally
                        if handle <> INVALID_HANDLE_VALUE then
                        begin
                            CloseHandle(handle);
                            handle := INVALID_HANDLE_VALUE;
                        end;
                    end;
                end;
            end;

            if not try_open_log_handle(log_path, handle) then
            begin
                Exit;
            end;
            try
                current_size := 0;
                if not GetFileSizeEx(handle, current_size) then
                begin
                    current_size := 0;
                end;
                SetFilePointer(handle, 0, nil, FILE_END);
                if current_size = 0 then
                begin
                    preamble := TEncoding.UTF8.GetPreamble;
                    if not write_bytes_to_handle(handle, preamble) then
                    begin
                        Exit;
                    end;
                end;
                utf8_bytes := TEncoding.UTF8.GetBytes(line);
                write_bytes_to_handle(handle, utf8_bytes);
            finally
                if handle <> INVALID_HANDLE_VALUE then
                begin
                    CloseHandle(handle);
                    handle := INVALID_HANDLE_VALUE;
                end;
            end;
        finally
            release_log_mutex(mutex_handle);
        end;
    except
        // Logging must never break input processing.
    end;
end;

function get_module_directory: string;
var
    path_buffer: array[0..MAX_PATH - 1] of Char;
    path_len: DWORD;
begin
    path_len := GetModuleFileName(HInstance, path_buffer, Length(path_buffer));
    if path_len = 0 then
    begin
        Result := '';
        Exit;
    end;

    Result := ExtractFileDir(path_buffer);
end;

function get_file_size(const path: string): Int64;
var
    stream: TFileStream;
begin
    Result := 0;
    if path = '' then
    begin
        Exit;
    end;

    try
        stream := TFileStream.Create(path, fmOpenRead or fmShareDenyNone);
        try
            Result := stream.Size;
        finally
            stream.Free;
        end;
    except
        Result := 0;
    end;
end;

constructor TncLogger.create(const log_path: string);
begin
    create(log_path, 1024);
end;

constructor TncLogger.create(const log_path: string; const max_size_kb: Integer);
begin
    inherited create;
    m_log_path := log_path;
    m_level := ll_info;
    m_max_size_kb := max_size_kb;
end;

procedure TncLogger.set_level(const level: TncLogLevel);
begin
    m_level := level;
end;

function TncLogger.level_to_text(const level: TncLogLevel): string;
begin
    case level of
        ll_debug:
            Result := 'DEBUG';
        ll_info:
            Result := 'INFO';
        ll_warn:
            Result := 'WARN';
        ll_error:
            Result := 'ERROR';
    else
        Result := 'INFO';
    end;
end;

procedure TncLogger.write_line(const level: TncLogLevel; const msg: string);
var
    line: string;
begin
    if level < m_level then
    begin
        Exit;
    end;

    line := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' [' + level_to_text(level) + '] ' + msg + sLineBreak;
    append_log_line_shared(m_log_path, line, m_max_size_kb);
end;

procedure TncLogger.debug(const msg: string);
begin
    write_line(ll_debug, msg);
end;

procedure TncLogger.info(const msg: string);
begin
    write_line(ll_info, msg);
end;

procedure TncLogger.warn(const msg: string);
begin
    write_line(ll_warn, msg);
end;

procedure TncLogger.error(const msg: string);
begin
    write_line(ll_error, msg);
end;

function known_folder_path(const folder_id: TGUID): string;
const
    c_kf_flag_no_package_redirection = $00010000;
var
    path_ptr: PWideChar;
begin
    Result := '';
    path_ptr := nil;
    if Succeeded(SHGetKnownFolderPath(folder_id, c_kf_flag_no_package_redirection, 0, path_ptr)) and
        (path_ptr <> nil) then
    begin
        try
            Result := Trim(string(path_ptr));
        finally
            CoTaskMemFree(path_ptr);
        end;
    end;
end;

function path_is_within(const path: string; const root: string): Boolean;
var
    normalized_root: string;
begin
    Result := False;
    if (Trim(path) = '') or (Trim(root) = '') then
    begin
        Exit;
    end;
    normalized_root := IncludeTrailingPathDelimiter(ExpandFileName(Trim(root)));
    Result := SameText(Copy(IncludeTrailingPathDelimiter(ExpandFileName(Trim(path))), 1,
        Length(normalized_root)), normalized_root);
end;

function nc_log_path_is_under_program_files(const path: string): Boolean;
begin
    // ProgramW6432 also names the 64-bit folder inside 32-bit processes, which
    // load the installed 32-bit TSF DLL from there.
    Result := path_is_within(path, known_folder_path(FOLDERID_ProgramFiles)) or
        path_is_within(path, known_folder_path(FOLDERID_ProgramFilesX86)) or
        path_is_within(path, GetEnvironmentVariable('ProgramW6432'));
end;

function get_default_log_path: string;
var
    module_dir: string;
    local_app_data: string;
begin
    module_dir := get_module_directory;
    // An installed runtime lives under Program Files, which applications, the
    // tray and the host cannot write with a standard token; lines were dropped
    // silently. Use the per-user root that also holds config and dictionaries.
    // Development and benchmark runtimes keep logs beside their binaries.
    if (module_dir <> '') and nc_log_path_is_under_program_files(module_dir) then
    begin
        local_app_data := known_folder_path(FOLDERID_LocalAppData);
        if local_app_data = '' then
        begin
            local_app_data := Trim(GetEnvironmentVariable('LOCALAPPDATA'));
        end;
        if local_app_data <> '' then
        begin
            Result := IncludeTrailingPathDelimiter(local_app_data) + 'CassotisIme\logs\cassotis_ime.log';
            Exit;
        end;
    end;

    if module_dir = '' then
    begin
        Result := 'logs\cassotis_ime.log';
        Exit;
    end;

    Result := IncludeTrailingPathDelimiter(module_dir) + 'logs\cassotis_ime.log';
end;

end.

unit nc_shell_recovery;

interface

uses
    Winapi.Windows,
    nc_shell_upgrade;

type
    TncDesktopState = (ds_missing, ds_ready, ds_unverified);

    IncShellRecoveryMonitor = interface
        ['{73C3CD26-BB88-4637-AEC8-19F96F5E4C57}']
        function NowMs: UInt64;
        function DesktopState: TncDesktopState;
        function OriginalExited: Boolean;
        function Finished: Boolean;
        function StartExplorer: DWORD;
        procedure Pause(const milliseconds: DWORD);
    end;

    TncExplorerRecovery = class
    private
        m_ready, m_done, m_watcher: THandle;
        m_caller: TncShellIdentity;
        m_log_path: string;
    public
        destructor Destroy; override;
        function Arm: DWORD;
        function Verify: DWORD;
        procedure Finish;
        property LogPath: string read m_log_path;
    end;

function nc_desktop_state(const caller: TncShellIdentity;
    out shell: TncShellIdentity): TncDesktopState;
function nc_monitor_shell_recovery(const monitor: IncShellRecoveryMonitor;
    out detail: string): DWORD;
function nc_run_shell_recovery(const parent_pid, shell_pid: DWORD;
    const shell_created: TFileTime; const ready_name, done_name, log_path: string): DWORD;

implementation

uses
    Winapi.Messages,
    System.SysUtils,
    System.IOUtils;

type
    TncNativeRecoveryMonitor = class(TInterfacedObject, IncShellRecoveryMonitor)
    public
        caller, original_shell: TncShellIdentity;
        parent, shell, done, primary_token: THandle;
        log_path: string;
        function NowMs: UInt64;
        function DesktopState: TncDesktopState;
        function OriginalExited: Boolean;
        function Finished: Boolean;
        function StartExplorer: DWORD;
        procedure Pause(const milliseconds: DWORD);
    end;

function nc_create_process_with_token(token: THandle; logon_flags: DWORD;
    application_name, command_line: PWideChar; creation_flags: DWORD;
    environment: Pointer; current_directory: PWideChar;
    var startup_info: TStartupInfo; var process_info: TProcessInformation): BOOL;
    stdcall; external 'advapi32.dll' name 'CreateProcessWithTokenW';
function GetShellWindow: HWND; stdcall; external 'user32.dll';

procedure trace(const path, text: string);
begin
    if path = '' then
        Exit;
    try
        TFile.AppendAllText(path, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
            ' ' + text + sLineBreak, TEncoding.UTF8);
    except
        // A diagnostic write must never prevent desktop recovery.
    end;
end;

function nc_desktop_state(const caller: TncShellIdentity;
    out shell: TncShellIdentity): TncDesktopState;
var
    desktop, tray: HWND;
    desktop_pid, tray_pid: DWORD;
    process: THandle;
    windows_dir: array[0..MAX_PATH] of Char;
    count: UINT;
    response: DWORD_PTR;
begin
    Result := ds_unverified;
    shell := Default(TncShellIdentity);
    desktop := GetShellWindow;
    tray := FindWindow('Shell_TrayWnd', nil);
    if (desktop = 0) and (tray = 0) then
        Exit(ds_missing);
    if (desktop = 0) or (tray = 0) then
        Exit;
    if not IsWindowVisible(tray) then
        Exit;
    GetWindowThreadProcessId(desktop, @desktop_pid);
    GetWindowThreadProcessId(tray, @tray_pid);
    if (desktop_pid = 0) or (desktop_pid <> tray_pid) then
        Exit;
    process := OpenProcess($1000 or SYNCHRONIZE, False, desktop_pid);
    if process = 0 then
        Exit;
    try
        if not nc_read_shell_identity(process, shell) or
            (WaitForSingleObject(process, 0) <> WAIT_TIMEOUT) then
            Exit;
        count := GetWindowsDirectory(@windows_dir[0], Length(windows_dir));
        if (count = 0) or (count >= UINT(Length(windows_dir))) or
            (nc_shell_kind(shell.image_path, string(windows_dir)) <> sk_explorer) or
            (shell.owner_sid <> caller.owner_sid) or
            (shell.session_id <> caller.session_id) or shell.elevated then
            Exit;
        // Process existence (including Explorer folder servers) is not a desktop.
        if SendMessageTimeout(tray, WM_NULL, 0, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK,
            100, @response) = 0 then
            Exit;
        Result := ds_ready;
    finally
        CloseHandle(process);
    end;
end;

function nc_monitor_shell_recovery(const monitor: IncShellRecoveryMonitor;
    out detail: string): DWORD;
const
    c_lifetime_ms = 45000;
    c_missing_grace_ms = 2000;
    c_retry_ms = 8000;
var
    started, missing_since, last_launch, now_ms: UInt64;
    missing_seen: Boolean;
    attempts: Integer;
    last_error: DWORD;
    state: TncDesktopState;
begin
    started := monitor.NowMs;
    missing_since := 0;
    last_launch := 0;
    missing_seen := False;
    attempts := 0;
    last_error := ERROR_SUCCESS;
    repeat
        now_ms := monitor.NowMs;
        state := monitor.DesktopState;
        if state = ds_ready then
        begin
            missing_seen := False;
            if monitor.Finished then
            begin
                detail := Format('Desktop and taskbar ready; fallback attempts=%d', [attempts]);
                Exit(ERROR_SUCCESS);
            end;
        end
        else if (state = ds_missing) and monitor.OriginalExited then
        begin
            if not missing_seen then
            begin
                missing_seen := True;
                missing_since := now_ms;
            end;
            if (now_ms - missing_since >= c_missing_grace_ms) and (attempts < 2) and
                ((attempts = 0) or (now_ms - last_launch >= c_retry_ms)) then
            begin
                last_error := monitor.StartExplorer;
                Inc(attempts);
                last_launch := now_ms;
            end;
        end
        else
            missing_seen := False;
        if now_ms - started >= c_lifetime_ms then
            Break;
        monitor.Pause(200);
    until False;
    detail := Format('Recovery deadline; desktop=%d attempts=%d launch_error=%d',
        [Ord(state), attempts, last_error]);
    if state = ds_ready then
        Result := ERROR_SUCCESS
    else
        Result := ERROR_TIMEOUT;
end;

function TncNativeRecoveryMonitor.NowMs: UInt64;
begin
    Result := GetTickCount64;
end;

function TncNativeRecoveryMonitor.DesktopState: TncDesktopState;
var
    current_shell: TncShellIdentity;
begin
    Result := nc_desktop_state(caller, current_shell);
end;

function TncNativeRecoveryMonitor.OriginalExited: Boolean;
begin
    Result := WaitForSingleObject(shell, 0) = WAIT_OBJECT_0;
end;

function TncNativeRecoveryMonitor.Finished: Boolean;
begin
    Result := (WaitForSingleObject(parent, 0) = WAIT_OBJECT_0) or
        (WaitForSingleObject(done, 0) = WAIT_OBJECT_0);
end;

function TncNativeRecoveryMonitor.StartExplorer: DWORD;
var
    startup: TStartupInfo;
    process: TProcessInformation;
    command, directory: string;
    launched: BOOL;
begin
    FillChar(startup, SizeOf(startup), 0);
    startup.cb := SizeOf(startup);
    startup.lpDesktop := 'winsta0\default';
    FillChar(process, SizeOf(process), 0);
    command := '"' + original_shell.image_path + '"';
    UniqueString(command);
    directory := ExtractFileDir(original_shell.image_path);
    if caller.elevated then
        launched := nc_create_process_with_token(primary_token, 0,
            PChar(original_shell.image_path), PChar(command), 0, nil,
            PChar(directory), startup, process)
    else
        launched := CreateProcess(PChar(original_shell.image_path), PChar(command), nil,
            nil, False, 0, nil, PChar(directory), startup, process);
    if not launched then
        Result := GetLastError
    else
    begin
        CloseHandle(process.hThread);
        CloseHandle(process.hProcess);
        Result := ERROR_SUCCESS;
    end;
    trace(log_path, Format('Fallback Explorer launch=%d (original user token)', [Result]));
end;

procedure TncNativeRecoveryMonitor.Pause(const milliseconds: DWORD);
begin
    Sleep(milliseconds);
end;

function capture_original_token(const shell_process: THandle; out primary: THandle): DWORD;
var
    token, caller_token: THandle;
    privileges: TPrivilegeSet;
    allowed: BOOL;
begin
    primary := 0;
    if not OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, caller_token) then
        Exit(GetLastError);
    try
        FillChar(privileges, SizeOf(privileges), 0);
        privileges.PrivilegeCount := 1;
        privileges.Control := PRIVILEGE_SET_ALL_NECESSARY;
        privileges.Privilege[0].Attributes := SE_PRIVILEGE_ENABLED;
        if not LookupPrivilegeValue(nil, 'SeImpersonatePrivilege', privileges.Privilege[0].Luid) or
            not PrivilegeCheck(caller_token, privileges, allowed) then
            Exit(GetLastError);
        if not allowed then
            Exit(ERROR_PRIVILEGE_NOT_HELD);
    finally
        CloseHandle(caller_token);
    end;
    if not OpenProcessToken(shell_process, TOKEN_QUERY or TOKEN_DUPLICATE, token) then
        Exit(GetLastError);
    try
        if not DuplicateTokenEx(token, TOKEN_QUERY or TOKEN_DUPLICATE or TOKEN_ASSIGN_PRIMARY,
            nil, SecurityImpersonation, TokenPrimary, primary) then
            Exit(GetLastError);
        Result := ERROR_SUCCESS;
    finally
        CloseHandle(token);
    end;
end;

function nc_run_shell_recovery(const parent_pid, shell_pid: DWORD;
    const shell_created: TFileTime; const ready_name, done_name, log_path: string): DWORD;
var
    parent, shell, ready, done, primary: THandle;
    caller, parent_identity, shell_identity: TncShellIdentity;
    native: TncNativeRecoveryMonitor;
    monitor: IncShellRecoveryMonitor;
    detail: string;
begin
    Result := ERROR_INVALID_PARAMETER;
    if (parent_pid = 0) or (shell_pid = 0) or (ready_name = '') or (done_name = '') then
        Exit;
    parent := 0;
    shell := 0;
    ready := 0;
    done := 0;
    primary := 0;
    try
        if not nc_read_shell_identity(GetCurrentProcess, caller) then
            Exit(ERROR_ACCESS_DENIED);
        parent := OpenProcess($1000 or SYNCHRONIZE, False, parent_pid);
        shell := OpenProcess($1000 or SYNCHRONIZE, False, shell_pid);
        if (parent = 0) or (shell = 0) then
            Exit(GetLastError);
        if not nc_read_shell_identity(parent, parent_identity) or
            (parent_identity.owner_sid <> caller.owner_sid) or
            (parent_identity.session_id <> caller.session_id) or
            not SameText(parent_identity.image_path, caller.image_path) or
            (WaitForSingleObject(parent, 0) <> WAIT_TIMEOUT) then
            Exit(ERROR_ACCESS_DENIED);
        if (nc_desktop_state(caller, shell_identity) <> ds_ready) or
            (shell_identity.pid <> shell_pid) or
            (CompareFileTime(shell_identity.created, shell_created) <> 0) then
            Exit(ERROR_NOT_READY);
        if caller.elevated then
        begin
            Result := capture_original_token(shell, primary);
            if Result <> ERROR_SUCCESS then
                Exit;
        end;
        ready := OpenEvent(EVENT_MODIFY_STATE, False, PChar(ready_name));
        done := OpenEvent(SYNCHRONIZE, False, PChar(done_name));
        if (ready = 0) or (done = 0) then
            Exit(GetLastError);
        native := TncNativeRecoveryMonitor.Create;
        monitor := native;
        native.caller := caller;
        native.original_shell := shell_identity;
        native.parent := parent;
        native.shell := shell;
        native.done := done;
        native.primary_token := primary;
        native.log_path := log_path;
        trace(log_path, Format('Recovery armed; parent=%d original_shell=%d', [parent_pid, shell_pid]));
        if not SetEvent(ready) then
            Exit(GetLastError);
        Result := nc_monitor_shell_recovery(monitor, detail);
        trace(log_path, detail);
    finally
        monitor := nil;
        if primary <> 0 then CloseHandle(primary);
        if done <> 0 then CloseHandle(done);
        if ready <> 0 then CloseHandle(ready);
        if shell <> 0 then CloseHandle(shell);
        if parent <> 0 then CloseHandle(parent);
    end;
end;

destructor TncExplorerRecovery.Destroy;
begin
    Finish;
    inherited;
end;

function TncExplorerRecovery.Arm: DWORD;
var
    shell: TncShellIdentity;
    id: TGUID;
    ready_name, done_name, command: string;
    startup: TStartupInfo;
    process: TProcessInformation;
    handles: array[0..1] of THandle;
    wait_result: DWORD;
begin
    if not nc_read_shell_identity(GetCurrentProcess, m_caller) or
        (nc_desktop_state(m_caller, shell) <> ds_ready) then
        Exit(ERROR_NOT_READY);
    CreateGUID(id);
    ready_name := 'Local\CassotisIme.ShellRecovery.' + GUIDToString(id) + '.ready';
    done_name := 'Local\CassotisIme.ShellRecovery.' + GUIDToString(id) + '.done';
    m_log_path := TPath.Combine(TPath.GetTempPath, 'CassotisIme-shell-recovery-' + GUIDToString(id) + '.log');
    m_ready := CreateEvent(nil, True, False, PChar(ready_name));
    m_done := CreateEvent(nil, True, False, PChar(done_name));
    if (m_ready = 0) or (m_done = 0) then
        Exit(GetLastError);
    command := Format('"%s" watch_shell_restart -parent_pid %d -shell_pid %d ' +
        '-shell_created_low %u -shell_created_high %u -ready_event "%s" -done_event "%s" -log_path "%s"',
        [m_caller.image_path, m_caller.pid, shell.pid, shell.created.dwLowDateTime,
         shell.created.dwHighDateTime, ready_name, done_name, m_log_path]);
    UniqueString(command);
    FillChar(startup, SizeOf(startup), 0);
    startup.cb := SizeOf(startup);
    startup.dwFlags := STARTF_USESHOWWINDOW;
    startup.wShowWindow := SW_HIDE;
    FillChar(process, SizeOf(process), 0);
    if not CreateProcess(PChar(m_caller.image_path), PChar(command), nil, nil, False,
        CREATE_NO_WINDOW, nil, nil, startup, process) then
        Exit(GetLastError);
    CloseHandle(process.hThread);
    m_watcher := process.hProcess;
    handles[0] := m_ready;
    handles[1] := m_watcher;
    wait_result := WaitForMultipleObjects(2, @handles[0], False, 5000);
    if wait_result <> WAIT_OBJECT_0 then
    begin
        trace(m_log_path, Format('Recovery not ready; wait=%d; Explorer will not be closed', [wait_result]));
        Exit(ERROR_NOT_READY);
    end;
    Result := ERROR_SUCCESS;
end;

function TncExplorerRecovery.Verify: DWORD;
var
    shell: TncShellIdentity;
    started: UInt64;
begin
    started := GetTickCount64;
    repeat
        if nc_desktop_state(m_caller, shell) = ds_ready then
        begin
            trace(m_log_path, Format('Desktop verified; shell PID=%d', [shell.pid]));
            Exit(ERROR_SUCCESS);
        end;
        Sleep(200);
    until GetTickCount64 - started >= 15000;
    trace(m_log_path, 'Desktop verification timed out; recovery watcher remains active');
    Result := ERROR_TIMEOUT;
end;

procedure TncExplorerRecovery.Finish;
begin
    if m_done <> 0 then
    begin
        SetEvent(m_done);
        CloseHandle(m_done);
        m_done := 0;
    end;
    if m_ready <> 0 then
    begin
        CloseHandle(m_ready);
        m_ready := 0;
    end;
    if m_watcher <> 0 then
    begin
        // The independent watcher must survive us if the desktop is still missing.
        CloseHandle(m_watcher);
        m_watcher := 0;
    end;
end;

end.

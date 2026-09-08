{ Keep the existing singleton objects alive while Setup replaces shared data.
  Older hosts already refuse to start while these objects exist. }
var
    RuntimeUpgradeHostMutex: Integer;
    RuntimeUpgradeTrayMutex: Integer;

function UpgradeCreateMutex(lpMutexAttributes: Integer; bInitialOwner: Boolean;
    lpName: string): Integer;
external 'CreateMutexW@kernel32.dll stdcall';
function UpgradeOpenMutex(dwDesiredAccess: Cardinal; bInheritHandle: Boolean;
    lpName: string): Integer;
external 'OpenMutexW@kernel32.dll stdcall';
function UpgradeCloseHandle(hObject: Integer): Boolean;
external 'CloseHandle@kernel32.dll stdcall';
function UpgradeCreateFile(lpFileName: string; dwDesiredAccess, dwShareMode: Cardinal;
    lpSecurityAttributes: Integer; dwCreationDisposition, dwFlagsAndAttributes: Cardinal;
    hTemplateFile: Integer): Integer;
external 'CreateFileW@kernel32.dll stdcall';

procedure ReleaseRuntimeUpgradeGuards;
begin
    if RuntimeUpgradeTrayMutex <> 0 then
    begin
        UpgradeCloseHandle(RuntimeUpgradeTrayMutex);
        RuntimeUpgradeTrayMutex := 0;
    end;
    if RuntimeUpgradeHostMutex <> 0 then
    begin
        UpgradeCloseHandle(RuntimeUpgradeHostMutex);
        RuntimeUpgradeHostMutex := 0;
    end;
end;

function HoldRuntimeUpgradeMutex(const Name: string; out Handle: Integer;
    out ErrorCode: Cardinal): Boolean;
begin
    Handle := UpgradeCreateMutex(0, False, Name);
    if Handle = 0 then
    begin
        { Only a reference is needed, not ownership or MUTEX_ALL_ACCESS. }
        Handle := UpgradeOpenMutex($00100000, False, Name);
    end;
    Result := Handle <> 0;
    ErrorCode := 0;
    if not Result then
    begin
        ErrorCode := DLLGetLastError;
    end;
end;

function AcquireRuntimeUpgradeGuards(const HostName, TrayName: string;
    out ErrorCode: Cardinal): Boolean;
begin
    Result := False;
    ErrorCode := 0;
    if (RuntimeUpgradeHostMutex <> 0) and (RuntimeUpgradeTrayMutex <> 0) then
    begin
        Result := True;
        Exit;
    end;
    ReleaseRuntimeUpgradeGuards;
    if not HoldRuntimeUpgradeMutex(HostName, RuntimeUpgradeHostMutex, ErrorCode) then
    begin
        Exit;
    end;
    if not HoldRuntimeUpgradeMutex(TrayName, RuntimeUpgradeTrayMutex, ErrorCode) then
    begin
        ReleaseRuntimeUpgradeGuards;
        Exit;
    end;
    Log('Runtime restart guards held: ' + HostName + ', ' + TrayName);
    Result := True;
end;

function RuntimeUpgradeGuardsHeld: Boolean;
begin
    Result := (RuntimeUpgradeHostMutex <> 0) and (RuntimeUpgradeTrayMutex <> 0);
end;

function TryOpenDictionaryExclusive(const FilePath: string;
    out ErrorCode: Cardinal): Boolean;
var
    Handle: Integer;
begin
    { Request DELETE as well as read/write access, just like replacement needs.
      Checking data files must not depend on a registered runtime directory. }
    Handle := UpgradeCreateFile(FilePath, $C0010000, 0, 0, 3, $80, 0);
    ErrorCode := 0;
    if Handle <> -1 then
    begin
        UpgradeCloseHandle(Handle);
        Result := True;
        Exit;
    end;
    ErrorCode := DLLGetLastError;
    Result := (ErrorCode = 2) or (ErrorCode = 3);
    if Result then
    begin
        ErrorCode := 0;
    end;
end;

function RuntimeDictionariesReleased(const DataDir: string;
    out LockedFile: string; out ErrorCode: Cardinal): Boolean;
var
    Index: Integer;
    FilePath: string;
begin
    LockedFile := '';
    ErrorCode := 0;
    for Index := 0 to 1 do
    begin
        if Index = 0 then
            FilePath := AddBackslash(DataDir) + 'dict_sc.db'
        else
            FilePath := AddBackslash(DataDir) + 'dict_tc.db';
        if not TryOpenDictionaryExclusive(FilePath, ErrorCode) then
        begin
            LockedFile := FilePath;
            Result := False;
            Exit;
        end;
    end;
    Result := True;
end;

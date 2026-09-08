#define MyAppId "{{E6C79C57-16F6-4DD3-8C29-7FD2D3F57B2B}"
#define MyAppName "Cassotis IME－言泉输入法"
#define MyAppPublisher "Cassotis"
#ifndef AppVersion
  #define AppVersion "0.1.0"
#endif
#ifndef SourceRoot
  #define SourceRoot ".."
#endif
#define RuntimeDir SourceRoot + "\out"
#ifndef RuntimeDataSourceDir
  #define RuntimeDataSourceDir GetEnv("LOCALAPPDATA") + "\CassotisIme\data"
#endif
#ifndef RuntimeBuildId
  #define RuntimeBuildId "manual"
#endif
#define RuntimeRoot "{localappdata}\CassotisIme"
#define InstallRuntimeDir "{app}\runtime\" + AppVersion + "_" + RuntimeBuildId

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#AppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\Cassotis IME
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
UsedUserAreasWarning=no
WizardStyle=modern
Compression=lzma2
SolidCompression=no
OutputDir={#SourceRoot}\out
OutputBaseFilename=cassotis_ime_setup_{#AppVersion}
SetupIconFile={#SourceRoot}\cassotis_ime_yanquan.ico
UninstallDisplayIcon={#InstallRuntimeDir}\cassotis_ime_tray_host.exe
CloseApplications=no
RestartApplications=no
SetupLogging=yes
SetupMutex=Local\CassotisIme.Setup.Upgrade

[Languages]
Name: "chs"; MessagesFile: "compiler:ChineseSimplified.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Dirs]
Name: "{localappdata}\CassotisIme"
Name: "{localappdata}\CassotisIme\data"
Name: "{localappdata}\CassotisIme\logs"

[Files]
Source: "{#RuntimeDir}\cassotis_ime_host.exe"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\cassotis_ime_tray_host.exe"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\cassotis_ime_svr.dll"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\cassotis_ime_svr32.dll"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\cassotis_ime_profile_reg.exe"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\cassotis_ime_profile_reg.exe"; Flags: dontcopy
Source: "{#RuntimeDir}\sqlite3_64.dll"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\cassotis_pinyin_transformer_ort.dll"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\onnxruntime.dll"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\onnxruntime_providers_shared.dll"; DestDir: "{#InstallRuntimeDir}"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\pinyin_transformer\pinyin_conditional_scorer_int8.onnx"; DestDir: "{#InstallRuntimeDir}\pinyin_transformer"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\pinyin_transformer\pinyin_parallel_generator_int8.onnx"; DestDir: "{#InstallRuntimeDir}\pinyin_transformer"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\pinyin_transformer\pinyin_parallel_allowed.bin"; DestDir: "{#InstallRuntimeDir}\pinyin_transformer"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\pinyin_transformer\vocab.json"; DestDir: "{#InstallRuntimeDir}\pinyin_transformer"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_completion\local_completion_path_ranker_int8.onnx"; DestDir: "{#InstallRuntimeDir}\local_completion"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_completion\local_completion_generator_int8.onnx"; DestDir: "{#InstallRuntimeDir}\local_completion"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_completion\local_completion_index.bin"; DestDir: "{#InstallRuntimeDir}\local_completion"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_completion\model_manifest.json"; DestDir: "{#InstallRuntimeDir}\local_completion"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_repair\context_int8.onnx"; DestDir: "{#InstallRuntimeDir}\local_repair"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_repair\query_int8.onnx"; DestDir: "{#InstallRuntimeDir}\local_repair"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_repair\vocab.json"; DestDir: "{#InstallRuntimeDir}\local_repair"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_repair\readings.json"; DestDir: "{#InstallRuntimeDir}\local_repair"; Flags: ignoreversion onlyifdoesntexist
Source: "{#RuntimeDir}\local_repair\runtime_manifest.json"; DestDir: "{#InstallRuntimeDir}\local_repair"; Flags: ignoreversion onlyifdoesntexist
Source: "{#SourceRoot}\third_party\macbert\LICENSE"; DestDir: "{app}\licenses\macbert"; Flags: ignoreversion
Source: "{#SourceRoot}\third_party\macbert\NOTICE"; DestDir: "{app}\licenses\macbert"; Flags: ignoreversion
Source: "{#SourceRoot}\third_party\onnxruntime\LICENSE"; DestDir: "{app}\licenses\onnxruntime"; Flags: ignoreversion
Source: "{#SourceRoot}\third_party\onnxruntime\ThirdPartyNotices.txt"; DestDir: "{app}\licenses\onnxruntime"; Flags: ignoreversion

Source: "{#RuntimeDataSourceDir}\dict_sc.db"; DestDir: "{localappdata}\CassotisIme\data"; DestName: "dict_sc.db"; Flags: ignoreversion; BeforeInstall: BeforeDictionaryInstall
Source: "{#RuntimeDataSourceDir}\dict_tc.db"; DestDir: "{localappdata}\CassotisIme\data"; DestName: "dict_tc.db"; Flags: ignoreversion; BeforeInstall: BeforeDictionaryInstall
[Run]
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "register_tsf -dll_path ""{#InstallRuntimeDir}\cassotis_ime_svr.dll"" -skip_profile"; \
    Flags: runhidden waituntilterminated; \
    StatusMsg: "Registering Cassotis IME components..."
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "register"; \
    Flags: runhidden waituntilterminated; \
    StatusMsg: "Registering Cassotis IME profile..."
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "start -restart -ctfmon_only"; \
    Flags: runhidden waituntilterminated runasoriginaluser; \
    StatusMsg: "Preparing text service session..."
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "register"; \
    Flags: runhidden waituntilterminated runasoriginaluser; \
    StatusMsg: "Registering Cassotis IME profile for current user..."
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "start -restart"; \
    Flags: runhidden waituntilterminated runasoriginaluser; \
    BeforeInstall: ReleaseRuntimeUpgradeGuards; \
    StatusMsg: "Starting Cassotis IME..."
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "start"; \
    Flags: runhidden waituntilterminated runasoriginaluser; \
    StatusMsg: "Verifying Cassotis IME runtime..."
Filename: "{sys}\cmd.exe"; \
    Parameters: "/c start """" explorer.exe"; \
    Flags: runhidden nowait runasoriginaluser; \
    Check: ShouldRestartExplorer; \
    StatusMsg: "Restarting Windows shell..."

[UninstallRun]
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "force_stop_runtime -runtime_dir ""{#InstallRuntimeDir}"" -data_dir ""{localappdata}\CassotisIme\data"" -exclude_pid ""{code:GetCurrentProcessIdText}"""; \
    Flags: runhidden waituntilterminated skipifdoesntexist; \
    RunOnceId: "StopTSF"
Filename: "{#InstallRuntimeDir}\cassotis_ime_profile_reg.exe"; \
    Parameters: "unregister_tsf -dll_path ""{#InstallRuntimeDir}\cassotis_ime_svr.dll"""; \
    Flags: runhidden waituntilterminated skipifdoesntexist; \
    RunOnceId: "UnregisterTSF"

[CustomMessages]
chs.PreparingStopRuntime=正在停止旧版本输入法...
chs.PreparingUnregisterRuntime=正在停用旧版本输入法组件...
chs.PreparingForceCloseRuntime=正在关闭占用旧版本文件的程序...
chs.PreparingWaitRuntime=正在等待旧版本文件释放...
chs.RuntimeReleaseFailed=词库文件仍被占用，无法继续安装。请关闭占用文件的程序后重试。
chs.RuntimeReleaseLockedFile=仍被占用的文件：
chs.RuntimeReleaseProcesses=检测到的相关进程：
chs.RuntimeGuardFailed=无法建立安装期间的后台启动保护，安装已停止。请关闭其他安装程序后重试。
chs.RuntimeReleaseRetry=请关闭占用文件的程序后选择“重试”，或选择“取消”中止安装；不会跳过词库更新。
chs.ForceCloseRuntimePrompt=为完成升级安装，安装程序将自动关闭以下正在占用旧版本文件的进程：
chs.ForceCloseRuntimeContinue=点击“确定”继续，点击“取消”中止安装。
chs.ForceCloseRuntimeCanceled=用户取消了升级安装。
english.PreparingStopRuntime=Stopping existing Cassotis IME runtime...
english.PreparingUnregisterRuntime=Disabling existing Cassotis IME components...
english.PreparingForceCloseRuntime=Closing applications still using existing runtime files...
english.PreparingWaitRuntime=Waiting for existing runtime files to be released...
english.RuntimeReleaseFailed=Dictionary files are still in use. Close the application using them and try again.
english.RuntimeReleaseLockedFile=File still in use:
english.RuntimeReleaseProcesses=Related processes detected:
english.RuntimeGuardFailed=Setup could not prevent the old runtime from restarting. Close other installers and try again.
english.RuntimeReleaseRetry=Close the application using this file and choose Retry, or choose Cancel to abort Setup. Dictionary updates will not be skipped.
english.ForceCloseRuntimePrompt=To continue the upgrade, Setup will automatically close the following processes that are still using existing runtime files:
english.ForceCloseRuntimeContinue=Click OK to continue, or Cancel to abort Setup.
english.ForceCloseRuntimeCanceled=Upgrade canceled by user.

[Code]
#include "runtime_upgrade_guard.iss"

const
    c_runtime_unlock_wait_attempts = 40;
    c_runtime_unlock_wait_ms = 250;
    c_disable_ime_for_all_process_threads = $FFFFFFFF;
    c_tsf_inproc_registry_path = 'Software\Classes\CLSID\{38D40A05-DCDB-49FB-81A4-C8745882DC21}\InprocServer32';

var
    RuntimePrepPage: TOutputProgressWizardPage;
    InstallerProfileRegPath: string;
    ForceStopTargetsPath: string;
    ForceStopApprovalGranted: Boolean;
    ExplorerRestartNeeded: Boolean;
    PreparedRuntimeDir: string;
    LastRuntimeFileError: Cardinal;

function GetCurrentProcessId: DWORD;
external 'GetCurrentProcessId@kernel32.dll stdcall';
function ProcessIdToSessionId(ProcessId: DWORD; out SessionId: DWORD): Boolean;
external 'ProcessIdToSessionId@kernel32.dll stdcall';
function ImmDisableIME(ThreadId: DWORD): Boolean;
external 'ImmDisableIME@imm32.dll stdcall';

function GetCurrentProcessIdText(const Param: string): string;
begin
    Result := IntToStr(Integer(GetCurrentProcessId));
end;

function InitializeSetup: Boolean;
begin
    { Inno Setup is a 32-bit process. Disable text services before the wizard
      creates edit controls, otherwise the installed 32-bit TSF DLL can be
      loaded into Setup itself and can never be replaced by that process. }
    if ImmDisableIME(c_disable_ime_for_all_process_threads) then
    begin
        Log('Disabled IME loading in the Setup process before creating the wizard.');
    end
    else
    begin
        Log('ImmDisableIME did not disable IME loading in the Setup process.');
    end;
    Result := True;
end;

function GetRuntimeRoot: string;
begin
    Result := ExpandConstant('{localappdata}\CassotisIme');
end;

function GetRuntimeDataDir: string;
begin
    Result := AddBackslash(GetRuntimeRoot) + 'data';
end;

procedure HidePreparingStatus; forward;

procedure InitializeWizard;
begin
    RuntimePrepPage := CreateOutputProgressPage(
        ExpandConstant('{#MyAppName}'),
        ExpandConstant('{cm:PreparingStopRuntime}')
    );
    InstallerProfileRegPath := '';
    ForceStopTargetsPath := ExpandConstant('{tmp}\cassotis_force_stop_targets.txt');
    ForceStopApprovalGranted := False;
    ExplorerRestartNeeded := False;
    PreparedRuntimeDir := '';
    LastRuntimeFileError := 0;
end;

procedure UpdateExplorerRestartNeeded(const TargetsText: string);
begin
    if Pos(LowerCase('explorer.exe'), LowerCase(TargetsText)) > 0 then
    begin
        ExplorerRestartNeeded := True;
    end;
end;

function GetInstallerProfileRegPath: string;
begin
    if InstallerProfileRegPath <> '' then
    begin
        Result := InstallerProfileRegPath;
        Exit;
    end;

    ExtractTemporaryFile('cassotis_ime_profile_reg.exe');
    InstallerProfileRegPath := ExpandConstant('{tmp}\cassotis_ime_profile_reg.exe');
    Result := InstallerProfileRegPath;
end;

function GetForceStopTargetsText(const RuntimeDir: string; const ExcludeInstaller: Boolean): string;
var
    ProfileRegPath: string;
    ResultCode: Integer;
    LoadedLines: TArrayOfString;
    Index: Integer;
    InstallerPid: DWORD;
    Arguments: string;
begin
    Result := '';
    ProfileRegPath := GetInstallerProfileRegPath;
    InstallerPid := GetCurrentProcessId;
    Arguments :=
        'list_force_stop_targets -runtime_dir "' + RuntimeDir + '" -data_dir "' + GetRuntimeDataDir +
        '" -output_path "' + ForceStopTargetsPath + '" -skip_dll_holders';
    if ExcludeInstaller then
    begin
        Arguments := Arguments + ' -exclude_pid "' + IntToStr(Integer(InstallerPid)) + '"';
    end;
    DeleteFile(ForceStopTargetsPath);
    if not Exec(
        ProfileRegPath,
        Arguments,
        '',
        SW_HIDE,
        ewWaitUntilTerminated,
        ResultCode
    ) then
    begin
        Exit;
    end;

    if not LoadStringsFromFile(ForceStopTargetsPath, LoadedLines) then
    begin
        Result := '';
        Log('Force-stop target list was not created by helper script.');
    end
    else
    begin
        for Index := 0 to GetArrayLength(LoadedLines) - 1 do
        begin
            if Trim(LoadedLines[Index]) = '' then
            begin
                continue;
            end;
            if Result <> '' then
            begin
                Result := Result + #13#10;
            end;
            Result := Result + LoadedLines[Index];
        end;
        Result := Trim(Result);
        if Result <> '' then
        begin
            Log('Force-stop target list:' + #13#10 + Result);
            UpdateExplorerRestartNeeded(Result);
        end
        else
        begin
            Log('Force-stop target list is empty.');
        end;
    end;
end;

function ShouldRestartExplorer: Boolean;
begin
    Result := ExplorerRestartNeeded;
end;

function ConfirmForceStopProcesses(const RuntimeDir: string): Boolean;
var
    TargetsText: string;
    PromptText: string;
begin
    if ForceStopApprovalGranted then
    begin
        Result := True;
        Exit;
    end;

    TargetsText := GetForceStopTargetsText(RuntimeDir, True);
    if TargetsText = '' then
    begin
        Result := True;
        Exit;
    end;

    HidePreparingStatus;
    PromptText :=
        ExpandConstant('{cm:ForceCloseRuntimePrompt}') + #13#10#13#10 +
        TargetsText + #13#10#13#10 +
        ExpandConstant('{cm:ForceCloseRuntimeContinue}');
    Result := MsgBox(PromptText, mbConfirmation, MB_OKCANCEL or MB_DEFBUTTON1) = IDOK;
    if Result then
    begin
        ForceStopApprovalGranted := True;
    end;
end;

procedure UpdatePreparingStatus(const StatusText: string; const DetailText: string;
    const ProgressPosition: Integer; const ProgressMax: Integer);
begin
    if RuntimePrepPage = nil then
    begin
        Exit;
    end;

    RuntimePrepPage.SetText(StatusText, DetailText);
    RuntimePrepPage.SetProgress(ProgressPosition, ProgressMax);
    RuntimePrepPage.Show;
    WizardForm.Refresh;
end;

procedure HidePreparingStatus;
begin
    if RuntimePrepPage = nil then
    begin
        Exit;
    end;

    RuntimePrepPage.Hide;
end;

function RuntimeFilesReleased(const RuntimeDir: string; out LockedFile: string): Boolean;
begin
    { Runtime binaries are installed side by side and are never overwritten.
      Only the shared dictionary snapshots still require exclusive replacement. }
    Result := RuntimeDictionariesReleased(GetRuntimeDataDir, LockedFile, LastRuntimeFileError);
end;

function NormalizeRegisteredDllPath(const Value: string): string;
begin
    Result := Trim(Value);
    if (Length(Result) >= 2) and (Result[1] = '"') and (Result[Length(Result)] = '"') then
    begin
        Result := Copy(Result, 2, Length(Result) - 2);
    end;
end;

function GetRegisteredRuntimeDir: string;
var
    RegisteredDllPath: string;
begin
    Result := '';
    RegisteredDllPath := '';
    if not RegQueryStringValue(HKLM64, c_tsf_inproc_registry_path, '', RegisteredDllPath) then
    begin
        if not RegQueryStringValue(HKCU64, c_tsf_inproc_registry_path, '', RegisteredDllPath) then
        begin
            if not RegQueryStringValue(HKLM32, c_tsf_inproc_registry_path, '', RegisteredDllPath) then
            begin
                RegQueryStringValue(HKCU32, c_tsf_inproc_registry_path, '', RegisteredDllPath);
            end;
        end;
    end;

    RegisteredDllPath := NormalizeRegisteredDllPath(RegisteredDllPath);
    if RegisteredDllPath = '' then
    begin
        Log('No existing Cassotis IME COM server path was found in the registry.');
        Exit;
    end;

    Result := ExtractFileDir(RegisteredDllPath);
    Log(Format('Registered Cassotis IME runtime detected: %s', [Result]));
end;

function RuntimeDirHasManagedFiles(const RuntimeDir: string): Boolean;
begin
    if RuntimeDir = '' then
    begin
        Result := False;
        Exit;
    end;
    Result :=
        FileExists(AddBackslash(RuntimeDir) + 'cassotis_ime_host.exe') or
        FileExists(AddBackslash(RuntimeDir) + 'cassotis_ime_tray_host.exe') or
        FileExists(AddBackslash(RuntimeDir) + 'cassotis_ime_svr.dll') or
        FileExists(AddBackslash(RuntimeDir) + 'cassotis_ime_svr32.dll') or
        FileExists(AddBackslash(RuntimeDir) + 'cassotis_ime_profile_reg.exe') or
        FileExists(AddBackslash(RuntimeDir) + 'sqlite3_64.dll');
end;

procedure TryStopExistingRuntime(const RuntimeDir: string);
var
    ProfileRegPath: string;
    DllPath: string;
    ResultCode: Integer;
begin
    if RuntimeDir = '' then
    begin
        Exit;
    end;
    if not RuntimeDirHasManagedFiles(RuntimeDir) then
    begin
        Exit;
    end;

    UpdatePreparingStatus(
        ExpandConstant('{cm:PreparingStopRuntime}'),
        RuntimeDir,
        0,
        0
    );

    ProfileRegPath := GetInstallerProfileRegPath;
    if not FileExists(ProfileRegPath) then
    begin
        Exit;
    end;

    DllPath := AddBackslash(RuntimeDir) + 'cassotis_ime_svr.dll';
    Log(Format('Stopping existing Cassotis IME runtime from "%s".', [RuntimeDir]));
    if Exec(
        ProfileRegPath,
        Format('stop -force_kill -dll_path "%s"', [DllPath]),
        '',
        SW_HIDE,
        ewWaitUntilTerminated,
        ResultCode
    ) then
    begin
        Log(Format('Existing runtime stop exit code: %d', [ResultCode]));
    end
    else
    begin
        Log(Format('Failed to launch existing runtime stop helper: %s', [ProfileRegPath]));
    end;
end;

function TryUnregisterExistingRuntime(const RuntimeDir: string): Boolean;
var
    ProfileRegPath: string;
    DllPath: string;
    ResultCode: Integer;
begin
    Result := True;
    if RuntimeDir = '' then
    begin
        Exit;
    end;
    if not RuntimeDirHasManagedFiles(RuntimeDir) then
    begin
        Exit;
    end;

    UpdatePreparingStatus(
        ExpandConstant('{cm:PreparingUnregisterRuntime}'),
        RuntimeDir,
        0,
        0
    );

    ProfileRegPath := GetInstallerProfileRegPath;
    if not FileExists(ProfileRegPath) then
    begin
        Result := False;
        Exit;
    end;

    DllPath := AddBackslash(RuntimeDir) + 'cassotis_ime_svr.dll';
    if not FileExists(DllPath) then
    begin
        Exit;
    end;

    Log(Format('Unregistering existing Cassotis IME TSF from "%s".', [RuntimeDir]));
    if Exec(
        ProfileRegPath,
        Format('unregister_tsf -dll_path "%s"', [DllPath]),
        '',
        SW_HIDE,
        ewWaitUntilTerminated,
        ResultCode
    ) then
    begin
        Log(Format('Existing runtime unregister_tsf exit code: %d', [ResultCode]));
        Result := ResultCode = 0;
    end
    else
    begin
        Log(Format('Failed to launch existing runtime unregister helper: %s', [ProfileRegPath]));
        Result := False;
    end;
end;

procedure TryForceStopProcessesUsingImeModules(const RuntimeDir: string);
var
    ProfileRegPath: string;
    ResultCode: Integer;
    InstallerPid: DWORD;
begin
    UpdatePreparingStatus(
        ExpandConstant('{cm:PreparingForceCloseRuntime}'),
        RuntimeDir,
        0,
        0
    );

    ProfileRegPath := GetInstallerProfileRegPath;
    InstallerPid := GetCurrentProcessId;
    Log('Running installer-side force-stop pass for processes using IME runtime files.');
    if Exec(
        ProfileRegPath,
        'force_stop_runtime -runtime_dir "' + RuntimeDir + '" -data_dir "' + GetRuntimeDataDir +
            '" -exclude_pid "' + IntToStr(Integer(InstallerPid)) + '" -skip_dll_holders',
        '',
        SW_HIDE,
        ewWaitUntilTerminated,
        ResultCode
    ) then
    begin
        Log(Format('Installer-side force-stop pass exit code: %d', [ResultCode]));
    end
    else
    begin
        Log('Failed to launch installer-side force-stop pass.');
    end;
end;

function WaitForRuntimeRelease(const RuntimeDir: string; out LastLockedFile: string): Boolean;
var
    Attempt: Integer;
    LockedFile: string;
begin
    Result := True;
    LastLockedFile := '';

    for Attempt := 1 to c_runtime_unlock_wait_attempts do
    begin
        if (Attempt = 1) or ((Attempt mod 4) = 0) then
        begin
            UpdatePreparingStatus(
                ExpandConstant('{cm:PreparingWaitRuntime}'),
                GetRuntimeDataDir + ' (' + IntToStr(Attempt) + '/' + IntToStr(c_runtime_unlock_wait_attempts) + ')',
                Attempt,
                c_runtime_unlock_wait_attempts
            );
        end;

        if RuntimeFilesReleased(RuntimeDir, LockedFile) then
        begin
            if Attempt > 1 then
            begin
                Log(Format('Runtime files released after %d wait attempts: %s', [Attempt, RuntimeDir]));
            end;
            Result := True;
            Exit;
        end;
        LastLockedFile := LockedFile;
        if (Attempt = 1) or ((Attempt mod 4) = 0) then
        begin
            Log(Format('Waiting for locked file to be released: %s (error %d)', [LockedFile, LastRuntimeFileError]));
        end;
        Sleep(c_runtime_unlock_wait_ms);
    end;

    Log(Format('Runtime files still locked after waiting: %s (%s)', [RuntimeDir, LockedFile]));
    Result := False;
end;

function RuntimeReleaseFailureText(const RuntimeDir, LockedFile: string): string;
var
    TargetsText: string;
begin
    Result := ExpandConstant('{cm:RuntimeReleaseFailed}');
    if LockedFile <> '' then
    begin
        Result := Result + #13#10#13#10 +
            ExpandConstant('{cm:RuntimeReleaseLockedFile}') + #13#10 + LockedFile + #13#10 +
            Format('Windows error %d: %s', [LastRuntimeFileError, SysErrorMessage(LastRuntimeFileError)]);
    end;
    TargetsText := GetForceStopTargetsText(RuntimeDir, False);
    if TargetsText <> '' then
    begin
        Result := Result + #13#10#13#10 +
            ExpandConstant('{cm:RuntimeReleaseProcesses}') + #13#10 + TargetsText;
    end;
    Log('Runtime release failure details:' + #13#10 + Result);
end;

procedure BeforeDictionaryInstall;
var
    LockedFile: string;
    FailureText: string;
begin
    if not RuntimeUpgradeGuardsHeld then
    begin
        RaiseException(ExpandConstant('{cm:RuntimeGuardFailed}'));
    end;
    Log('Rechecking dictionary replacement immediately before copying: ' + CurrentFileName);
    try
        while not WaitForRuntimeRelease(PreparedRuntimeDir, LockedFile) do
        begin
            HidePreparingStatus;
            FailureText := RuntimeReleaseFailureText(PreparedRuntimeDir, LockedFile);
            if WizardSilent then
            begin
                RaiseException(FailureText);
            end;
            { A newly arrived holder was not in the original approval dialog.
              Do not silently terminate it or offer to skip either dictionary. }
            if MsgBox(FailureText + #13#10#13#10 +
                ExpandConstant('{cm:RuntimeReleaseRetry}'), mbError,
                MB_RETRYCANCEL or MB_DEFBUTTON2) <> IDRETRY then
            begin
                RaiseException(FailureText);
            end;
        end;
    finally
        HidePreparingStatus;
    end;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
    RootRuntimeDir: string;
    LegacyRuntimeDir: string;
    ActiveRuntimeDir: string;
    RegisteredRuntimeDir: string;
    LockedFile: string;
    SessionId: DWORD;
    ErrorCode: Cardinal;
    Prepared: Boolean;
begin
    NeedsRestart := False;
    Result := '';
    Prepared := False;
    ForceStopApprovalGranted := False;
    Log('Versioned runtime destination: ' + ExpandConstant('{#InstallRuntimeDir}'));
    RootRuntimeDir := ExpandConstant('{app}');
    LegacyRuntimeDir := ExpandConstant('{app}\out');
    ActiveRuntimeDir := '';
    RegisteredRuntimeDir := GetRegisteredRuntimeDir;
    if RuntimeDirHasManagedFiles(RegisteredRuntimeDir) then
    begin
        ActiveRuntimeDir := RegisteredRuntimeDir;
    end
    else if RuntimeDirHasManagedFiles(RootRuntimeDir) then
    begin
        ActiveRuntimeDir := RootRuntimeDir;
    end
    else if (CompareText(LegacyRuntimeDir, RootRuntimeDir) <> 0) and RuntimeDirHasManagedFiles(LegacyRuntimeDir) then
    begin
        ActiveRuntimeDir := LegacyRuntimeDir;
    end;

    PreparedRuntimeDir := ActiveRuntimeDir;
    SessionId := 0;
    if not ProcessIdToSessionId(GetCurrentProcessId, SessionId) then
    begin
        ErrorCode := DLLGetLastError;
        Result := ExpandConstant('{cm:RuntimeGuardFailed}') + #13#10 + SysErrorMessage(ErrorCode);
        Exit;
    end;
    { These names match the existing host, tray and TSF client. Holding a
      reference before stopping them also protects upgrades from older builds. }
    if not AcquireRuntimeUpgradeGuards(
        Format('Local\cassotis_ime_engine_host_v2_s%d', [SessionId]),
        Format('Local\cassotis_ime_tray_host_v1_s%d', [SessionId]), ErrorCode) then
    begin
        Result := ExpandConstant('{cm:RuntimeGuardFailed}') + #13#10 + SysErrorMessage(ErrorCode);
        Exit;
    end;
    try
        UpdatePreparingStatus(
            ExpandConstant('{cm:PreparingStopRuntime}'),
            GetRuntimeDataDir,
            0,
            0
        );
        if (ActiveRuntimeDir <> '') or
            FileExists(AddBackslash(GetRuntimeDataDir) + 'dict_sc.db') or
            FileExists(AddBackslash(GetRuntimeDataDir) + 'dict_tc.db') then
        begin
            if not ConfirmForceStopProcesses(ActiveRuntimeDir) then
            begin
                Result := ExpandConstant('{cm:ForceCloseRuntimeCanceled}');
                Exit;
            end;
            { Keep the old registration intact until the new files are installed.
              Singleton guards prevent old hosts restarting, even with old DLLs. }
            TryForceStopProcessesUsingImeModules(ActiveRuntimeDir);
        end;
        if not WaitForRuntimeRelease(ActiveRuntimeDir, LockedFile) then
        begin
            Result := RuntimeReleaseFailureText(ActiveRuntimeDir, LockedFile);
            Exit;
        end;
        Prepared := True;
    finally
        HidePreparingStatus;
        if not Prepared then
        begin
            ReleaseRuntimeUpgradeGuards;
        end;
    end;
end;

procedure DeinitializeSetup;
begin
    { Also runs on cancellation/failure. Abrupt process exit closes handles too. }
    ReleaseRuntimeUpgradeGuards;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    if CurUninstallStep <> usPostUninstall then
    begin
        Exit;
    end;

    if not DirExists(GetRuntimeRoot) then
    begin
        Exit;
    end;

    if MsgBox(
        'Remove user data under "%LOCALAPPDATA%\CassotisIme"?' + #13#10 +
        'This includes config, dictionaries, user dictionary, and logs.',
        mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES then
    begin
        DelTree(GetRuntimeRoot, True, True, True);
    end;
end;

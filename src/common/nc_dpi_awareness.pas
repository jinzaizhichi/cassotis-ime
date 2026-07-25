unit nc_dpi_awareness;

interface

uses
    Winapi.Windows;

type
    TncSetProcessDpiAwarenessContext = function(const value: THandle): BOOL; stdcall;
    TncSetProcessDpiAwareness = function(const value: Integer): HRESULT; stdcall;
    TncSetProcessDpiAware = function: BOOL; stdcall;

function nc_try_enable_per_monitor_dpi(
    const set_context: TncSetProcessDpiAwarenessContext;
    const set_awareness: TncSetProcessDpiAwareness;
    const set_legacy_aware: TncSetProcessDpiAware): Boolean;
procedure nc_enable_per_monitor_dpi;

implementation

const
    c_dpi_awareness_per_monitor = 2;
    c_dpi_awareness_context_per_monitor = THandle(-3);
    c_dpi_awareness_context_per_monitor_v2 = THandle(-4);

function nc_try_enable_per_monitor_dpi(
    const set_context: TncSetProcessDpiAwarenessContext;
    const set_awareness: TncSetProcessDpiAwareness;
    const set_legacy_aware: TncSetProcessDpiAware): Boolean;
begin
    Result := False;

    if Assigned(set_context) then
    begin
        if set_context(c_dpi_awareness_context_per_monitor_v2) then
        begin
            Exit(True);
        end;
        if set_context(c_dpi_awareness_context_per_monitor) then
        begin
            Exit(True);
        end;
    end;

    if Assigned(set_awareness) and Succeeded(set_awareness(c_dpi_awareness_per_monitor)) then
    begin
        Exit(True);
    end;

    if Assigned(set_legacy_aware) then
    begin
        Result := set_legacy_aware();
    end;
end;

procedure nc_enable_per_monitor_dpi;
var
    user32: HMODULE;
    shcore: HMODULE;
    set_context: TncSetProcessDpiAwarenessContext;
    set_awareness: TncSetProcessDpiAwareness;
    set_legacy_aware: TncSetProcessDpiAware;
begin
    set_context := nil;
    set_awareness := nil;
    set_legacy_aware := nil;

    user32 := GetModuleHandle('user32.dll');
    if user32 <> 0 then
    begin
        set_context := TncSetProcessDpiAwarenessContext(
            GetProcAddress(user32, 'SetProcessDpiAwarenessContext'));
        set_legacy_aware := TncSetProcessDpiAware(
            GetProcAddress(user32, 'SetProcessDPIAware'));
    end;

    shcore := LoadLibrary('shcore.dll');
    try
        if shcore <> 0 then
        begin
            set_awareness := TncSetProcessDpiAwareness(
                GetProcAddress(shcore, 'SetProcessDpiAwareness'));
        end;
        nc_try_enable_per_monitor_dpi(set_context, set_awareness, set_legacy_aware);
    finally
        if shcore <> 0 then
        begin
            FreeLibrary(shcore);
        end;
    end;
end;

end.

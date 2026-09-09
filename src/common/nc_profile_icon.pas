unit nc_profile_icon;

interface

function nc_resolve_profile_icon_path(const module_file: string): string;

implementation

uses
    System.SysUtils;

function nc_resolve_profile_icon_path(const module_file: string): string;
const
    c_icon_files: array[0..3] of string = (
        'cassotis_ime_profile_reg.exe',
        'cassotis_ime_tray_host.exe',
        'cassotis_ime_host.exe',
        'cassotis_ime_svr.dll');
var
    base_dir, file_name, candidate: string;
begin
    Result := '';
    if module_file = '' then Exit;
    base_dir := ExtractFilePath(module_file);
    if base_dir = '' then Exit;
    // The registrar carries a dedicated, theme-independent language-bar icon.
    // Keep this choice identical in registration and TSF SetIcon.
    for file_name in c_icon_files do
    begin
        candidate := base_dir + file_name;
        if FileExists(candidate) then Exit(candidate);
    end;
end;

end.

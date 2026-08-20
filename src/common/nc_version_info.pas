unit nc_version_info;

interface

function nc_get_display_version_from_exe_file(const exe_path: string): string;
function nc_get_current_exe_display_version: string;

implementation

uses
    System.SysUtils,
    Winapi.Windows;

function nc_get_display_version_from_exe_file(const exe_path: string): string;
var
    dummy_handle: DWORD;
    info_size: DWORD;
    info_buffer: TBytes;
    fixed_info: PVSFixedFileInfo;
    fixed_info_len: UINT;
    major_ver: Word;
    minor_ver: Word;
    release_ver: Word;
begin
    Result := '';
    if (exe_path = '') or (not FileExists(exe_path)) then
    begin
        Exit;
    end;

    dummy_handle := 0;
    info_size := GetFileVersionInfoSize(PChar(exe_path), dummy_handle);
    if info_size = 0 then
    begin
        Exit;
    end;

    SetLength(info_buffer, info_size);
    if (Length(info_buffer) = 0) or
       (not GetFileVersionInfo(PChar(exe_path), 0, info_size, @info_buffer[0])) then
    begin
        Exit;
    end;

    fixed_info := nil;
    fixed_info_len := 0;
    if (not VerQueryValue(@info_buffer[0], '\', Pointer(fixed_info), fixed_info_len)) or
       (fixed_info = nil) or
       (fixed_info_len < SizeOf(TVSFixedFileInfo)) then
    begin
        Exit;
    end;

    major_ver := HiWord(fixed_info^.dwFileVersionMS);
    minor_ver := LoWord(fixed_info^.dwFileVersionMS);
    release_ver := HiWord(fixed_info^.dwFileVersionLS);
    Result := Format('%d.%d.%d', [major_ver, minor_ver, release_ver]);
end;

function nc_get_current_exe_display_version: string;
begin
    Result := nc_get_display_version_from_exe_file(ParamStr(0));
end;

end.

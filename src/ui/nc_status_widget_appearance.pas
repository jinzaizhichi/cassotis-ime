unit nc_status_widget_appearance;

interface

uses
    System.SysUtils, System.IniFiles, Vcl.Forms;

const
    c_default_status_widget_transparency = 0;
    c_max_status_widget_transparency = 90;
    c_status_widget_transparency_section = 'ui';
    c_status_widget_transparency_key = 'status_widget_transparency';

function nc_clamp_status_widget_transparency(const value: Integer): Integer;
function nc_status_widget_alpha(const transparency: Integer): Byte;
function nc_read_status_widget_transparency(const ini: TCustomIniFile): Integer;
procedure nc_write_status_widget_transparency(const ini: TCustomIniFile;
    const transparency: Integer);
procedure nc_apply_status_widget_transparency(const form: TForm;
    const transparency: Integer);

implementation

function nc_clamp_status_widget_transparency(const value: Integer): Integer;
begin
    Result := value;
    if Result < 0 then Result := 0;
    if Result > c_max_status_widget_transparency then
        Result := c_max_status_widget_transparency;
end;

function nc_status_widget_alpha(const transparency: Integer): Byte;
begin
    Result := (255 * (100 - nc_clamp_status_widget_transparency(transparency)) + 50) div 100;
end;

function nc_read_status_widget_transparency(const ini: TCustomIniFile): Integer;
var
    value: Integer;
begin
    Result := c_default_status_widget_transparency;
    if (ini <> nil) and TryStrToInt(Trim(ini.ReadString(
        c_status_widget_transparency_section, c_status_widget_transparency_key, '')), value) then
        Result := nc_clamp_status_widget_transparency(value);
end;

procedure nc_write_status_widget_transparency(const ini: TCustomIniFile;
    const transparency: Integer);
begin
    ini.WriteInteger(c_status_widget_transparency_section,
        c_status_widget_transparency_key, nc_clamp_status_widget_transparency(transparency));
end;

procedure nc_apply_status_widget_transparency(const form: TForm;
    const transparency: Integer);
begin
    if form = nil then Exit;
    form.AlphaBlendValue := nc_status_widget_alpha(transparency);
    form.AlphaBlend := form.AlphaBlendValue < 255;
end;

end.

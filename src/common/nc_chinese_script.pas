unit nc_chinese_script;

interface

uses nc_types;

function nc_convert_chinese_script(const text: string;
    const variant: TncDictionaryVariant): string;

implementation

uses Winapi.Windows;

function nc_convert_chinese_script(const text: string;
    const variant: TncDictionaryVariant): string;
var
    flags: DWORD;
    count: Integer;
    mapped: string;
begin
    Result := text;
    if text = '' then Exit;
    if variant = dv_traditional then
        flags := LCMAP_TRADITIONAL_CHINESE
    else
        flags := LCMAP_SIMPLIFIED_CHINESE;
    count := LCMapStringEx('zh-CN', flags, PChar(text), Length(text),
        nil, 0, nil, nil, 0);
    if count <= 0 then Exit;
    SetLength(mapped, count);
    if LCMapStringEx('zh-CN', flags, PChar(text), Length(text),
        PChar(mapped), count, nil, nil, 0) = count then
        Result := mapped;
end;

end.

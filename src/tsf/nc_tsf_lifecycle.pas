unit nc_tsf_lifecycle;

interface

uses
    Winapi.Windows,
    Winapi.Msctf,
    nc_types;

const
    c_nc_tsf_invalid_sink_cookie = DWORD($FFFFFFFF);

function nc_tsf_sink_cookie_is_valid(const cookie: DWORD): Boolean;
function nc_tsf_try_unadvise_sink(const source: ITfSource; var cookie: DWORD): Boolean;
function nc_tsf_shortcut_to_preserved_key(const shortcut: TncShortcut;
    out preserved_key: TF_PRESERVEDKEY): Boolean;

implementation

uses
    nc_shortcut;

function nc_tsf_sink_cookie_is_valid(const cookie: DWORD): Boolean;
begin
    Result := cookie <> c_nc_tsf_invalid_sink_cookie;
end;

function nc_tsf_try_unadvise_sink(const source: ITfSource; var cookie: DWORD): Boolean;
begin
    Result := True;
    try
        if (source <> nil) and nc_tsf_sink_cookie_is_valid(cookie) then
        begin
            Result := not Failed(source.UnadviseSink(cookie));
        end;
    except
        Result := False;
    end;
    cookie := c_nc_tsf_invalid_sink_cookie;
end;

function nc_tsf_shortcut_to_preserved_key(const shortcut: TncShortcut;
    out preserved_key: TF_PRESERVEDKEY): Boolean;
begin
    FillChar(preserved_key, SizeOf(preserved_key), 0);
    Result := nc_shortcut_is_valid(shortcut) and
        (not nc_shortcut_is_modifier_only(shortcut));
    if not Result then
    begin
        Exit;
    end;

    preserved_key.uVKey := nc_normalize_shortcut_key_code(shortcut.key_code);
    if shortcut.alt_down then
    begin
        preserved_key.uModifiers := preserved_key.uModifiers or TF_MOD_ALT;
    end;
    if shortcut.ctrl_down then
    begin
        preserved_key.uModifiers := preserved_key.uModifiers or TF_MOD_CONTROL;
    end;
    if shortcut.shift_down then
    begin
        preserved_key.uModifiers := preserved_key.uModifiers or TF_MOD_SHIFT;
    end;
end;

end.

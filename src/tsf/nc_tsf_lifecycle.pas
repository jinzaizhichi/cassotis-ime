unit nc_tsf_lifecycle;

interface

uses
    Winapi.Windows,
    Winapi.Msctf;

const
    c_nc_tsf_invalid_sink_cookie = DWORD($FFFFFFFF);

function nc_tsf_sink_cookie_is_valid(const cookie: DWORD): Boolean;
function nc_tsf_try_unadvise_sink(const source: ITfSource; var cookie: DWORD): Boolean;

implementation

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

end.

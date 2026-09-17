unit nc_imm_caret_query;

interface

uses
    Winapi.Windows,
    System.Types;

type
    TncImeCharPosition = record
        size: DWORD;
        char_index: DWORD;
        point: TPoint;
        line_height: UINT;
        document_rect: TRect;
    end;
    PncImeCharPosition = ^TncImeCharPosition;

    TncImeCharPositionPolicy = (icpp_standard, icpp_photoshop_canvas);

    TncImeCharPositionResult = (icpr_unavailable, icpr_wrong_owner,
        icpr_reentrant, icpr_unsupported, icpr_invalid, icpr_success,
        icpr_exception, icpr_success_compat);

const
    c_nc_imr_query_char_position = 6;

function ime_char_position_rect(const position: TncImeCharPosition;
    out caret_rect: TRect;
    const policy: TncImeCharPositionPolicy = icpp_standard): Boolean;
function query_ime_char_position(const target: HWND;
    out position: TncImeCharPosition;
    const policy: TncImeCharPositionPolicy = icpp_standard): TncImeCharPositionResult;
function ime_char_position_result_name(const value: TncImeCharPositionResult): string;

implementation

uses
    Winapi.Messages;

threadvar
    g_ime_char_position_active: Boolean;

function ime_char_position_rect(const position: TncImeCharPosition;
    out caret_rect: TRect;
    const policy: TncImeCharPositionPolicy): Boolean;
var
    bottom: Int64;
begin
    caret_rect := System.Types.Rect(0, 0, 0, 0);
    Result := False;
    if (position.size <> SizeOf(TncImeCharPosition)) or
        (position.char_index <> 0) or (position.line_height = 0) or
        (position.line_height > 4096) or
        (position.document_rect.Right <= position.document_rect.Left) or
        (position.document_rect.Bottom <= position.document_rect.Top) then
    begin
        Exit;
    end;

    // A returned screen-space character origin must belong to the document.
    // Allow the end position on its right/bottom boundary, including negative
    // screen coordinates on a monitor to the left of the primary display.
    if (position.point.X < position.document_rect.Left) or
        (position.point.X > position.document_rect.Right) or
        (position.point.Y < position.document_rect.Top) or
        (position.point.Y > position.document_rect.Bottom) then
    begin
        Exit;
    end;
    // CS6 reports the bottom of the glyph run and its one-line bounding box,
    // not a top-left origin plus a full editor rectangle. Do not add its line
    // height again. Keep standard IMECHARPOSITION semantics for other replies.
    if (policy = icpp_photoshop_canvas) and
        (position.point.Y = position.document_rect.Bottom) and
        (Int64(position.document_rect.Bottom) - position.document_rect.Top =
        position.line_height) then
    begin
        caret_rect := System.Types.Rect(position.point.X,
            position.document_rect.Top, position.point.X, position.point.Y);
        Exit(True);
    end;
    bottom := Int64(position.point.Y) + position.line_height;
    if bottom > High(Integer) then
    begin
        Exit;
    end;
    caret_rect := System.Types.Rect(position.point.X, position.point.Y,
        position.point.X, Integer(bottom));
    Result := True;
end;

function query_ime_char_position(const target: HWND;
    out position: TncImeCharPosition;
    const policy: TncImeCharPositionPolicy): TncImeCharPositionResult;
var
    process_id: DWORD;
    thread_id: DWORD;
    response: LRESULT;
    caret_rect: TRect;
begin
    FillChar(position, SizeOf(position), 0);
    Result := icpr_unavailable;
    if target = 0 then
    begin
        Exit;
    end;
    process_id := 0;
    thread_id := GetWindowThreadProcessId(target, @process_id);
    if (process_id <> GetCurrentProcessId) or
        (thread_id <> GetCurrentThreadId) then
    begin
        Exit(icpr_wrong_owner);
    end;
    if g_ime_char_position_active then
    begin
        Exit(icpr_reentrant);
    end;

    g_ime_char_position_active := True;
    try
        position.size := SizeOf(position);
        // WM_IME_REQUEST carries a process-local pointer. Never post it or send
        // it from the host/diagnostic process. Same-thread delivery also keeps
        // this stack buffer alive until the application has finished with it.
        try
            response := SendMessage(target, WM_IME_REQUEST,
                c_nc_imr_query_char_position, LPARAM(@position));
            if response = 0 then
            begin
                // Photoshop CS6 fills the output but its window procedure
                // returns zero. This opt-in accepts only a fully valid reply;
                // untouched/partial buffers and other applications still fail.
                if (policy = icpp_photoshop_canvas) and
                    ime_char_position_rect(position, caret_rect, policy) then
                    Exit(icpr_success_compat);
                Exit(icpr_unsupported);
            end;
            if not ime_char_position_rect(position, caret_rect, policy) then
            begin
                Exit(icpr_invalid);
            end;
            Result := icpr_success;
        except
            Result := icpr_exception;
        end;
    finally
        g_ime_char_position_active := False;
    end;
end;

function ime_char_position_result_name(const value: TncImeCharPositionResult): string;
begin
    case value of
        icpr_unavailable: Result := 'unavailable';
        icpr_wrong_owner: Result := 'wrong-owner';
        icpr_reentrant: Result := 'reentrant';
        icpr_unsupported: Result := 'unsupported';
        icpr_invalid: Result := 'invalid';
        icpr_success: Result := 'ok';
        icpr_exception: Result := 'exception';
        icpr_success_compat: Result := 'ok-validated-zero';
    else
        Result := 'unknown';
    end;
end;

end.

unit nc_preedit_renderer;

interface

uses
    System.Types,
    Vcl.Graphics,
    nc_pinyin_input_diagnostics;

function nc_preedit_warning_color(const background: TColor): TColor;
procedure nc_draw_preedit_text(const canvas: TCanvas; const text: string;
    const bounds: TRect; const spans: TncPinyinDiagnosticSpans;
    const warning_color: TColor);

implementation

uses
    System.Math,
    Winapi.Windows;

function nc_preedit_warning_color(const background: TColor): TColor;
var
    background_rgb: COLORREF;
begin
    background_rgb := ColorToRGB(background);
    if GetRValue(background_rgb) * 299 + GetGValue(background_rgb) * 587 +
        GetBValue(background_rgb) * 114 < 128000 then
        Result := TColor(RGB(255, 143, 143))
    else
        Result := TColor(RGB(184, 30, 42));
end;

procedure nc_draw_preedit_text(const canvas: TCanvas; const text: string;
    const bounds: TRect; const spans: TncPinyinDiagnosticSpans;
    const warning_color: TColor);
const
    flags = DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS or DT_NOPREFIX;
var
    saved_dc, clip_dc, available, fit, first, last, text_right, rect_count: Integer;
    advances: TArray<Integer>;
    warning_rects: TArray<TRect>;
    size, ellipsis_size: TSize;
    draw_rect, clip_rect: TRect;
    span: TncPinyinDiagnosticSpan;

    procedure draw_text;
    begin
        draw_rect := bounds;
        DrawTextW(canvas.Handle, PWideChar(text), Length(text), draw_rect, flags);
    end;
begin
    if (canvas = nil) or (text = '') or IsRectEmpty(bounds) then Exit;
    saved_dc := SaveDC(canvas.Handle);
    if saved_dc = 0 then Exit;
    try
        SelectObject(canvas.Handle, canvas.Font.Handle);
        SetBkMode(canvas.Handle, TRANSPARENT);
        SetTextColor(canvas.Handle, ColorToRGB(canvas.Font.Color));
        if Length(spans) = 0 then
        begin
            draw_text;
            Exit;
        end;
        SetLength(advances, Length(text));
        available := bounds.Right - bounds.Left;
        if not GetTextExtentExPointW(canvas.Handle, PWideChar(text), Length(text),
            available, @fit, @advances[0], size) then
        begin
            draw_text;
            Exit;
        end;
        text_right := bounds.Right;
        if size.cx > available then
        begin
            if not GetTextExtentPoint32W(canvas.Handle, '...', 3, ellipsis_size) then
            begin
                draw_text;
                Exit;
            end;
            text_right := Max(bounds.Left, bounds.Right - ellipsis_size.cx);
            if not GetTextExtentExPointW(canvas.Handle, PWideChar(text), Length(text),
                text_right - bounds.Left, @fit, @advances[0], size) then
            begin
                draw_text;
                Exit;
            end;
            if fit > 0 then text_right := Min(text_right, bounds.Left + advances[fit - 1])
            else text_right := bounds.Left;
        end;
        for span in spans do
        begin
            first := Max(0, span.start_index);
            last := Min(fit, span.start_index + span.length);
            if (first >= last) or (first >= fit) then Continue;
            clip_rect := bounds;
            if first > 0 then Inc(clip_rect.Left, advances[first - 1]);
            clip_rect.Right := Min(text_right, bounds.Left + advances[last - 1]);
            if IsRectEmpty(clip_rect) then Continue;
            rect_count := Length(warning_rects);
            SetLength(warning_rects, rect_count + 1);
            warning_rects[rect_count] := clip_rect;
        end;
        clip_dc := SaveDC(canvas.Handle);
        if clip_dc = 0 then
        begin
            draw_text;
            Exit;
        end;
        try
            for clip_rect in warning_rects do
                ExcludeClipRect(canvas.Handle, clip_rect.Left, clip_rect.Top,
                    clip_rect.Right, clip_rect.Bottom);
            draw_text;
        finally
            RestoreDC(canvas.Handle, clip_dc);
        end;
        for clip_rect in warning_rects do
        begin
            clip_dc := SaveDC(canvas.Handle);
            if clip_dc = 0 then Continue;
            try
                IntersectClipRect(canvas.Handle, clip_rect.Left, clip_rect.Top,
                    clip_rect.Right, clip_rect.Bottom);
                SetTextColor(canvas.Handle, ColorToRGB(warning_color));
                // Disjoint clips preserve shaping without painting antialiased glyphs twice.
                draw_text;
            finally
                RestoreDC(canvas.Handle, clip_dc);
            end;
        end;
    finally
        RestoreDC(canvas.Handle, saved_dc);
    end;
end;

end.

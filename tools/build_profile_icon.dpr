program build_profile_icon;

{$APPTYPE CONSOLE}
{$R 'cassotis_ime_tray_host_mark.res'}

// Regenerates only the language-bar derivative; the original logo stays untouched.
// build_profile_icon <original.ico> <profile.ico>
uses
    System.SysUtils, System.Classes, System.Math, Winapi.Windows, Vcl.Graphics,
    nc_tray_icon_appearance;

type
    TIconHeader = packed record
        reserved, kind, count: Word;
    end;
    TIconEntry = packed record
        width, height, colors, reserved: Byte;
        planes, bit_count: Word;
        image_size, image_offset: Cardinal;
    end;

procedure encode_straight_alpha(const stream: TMemoryStream; const image_offset: Cardinal;
    const size: Integer);
var
    info: PBitmapInfoHeader;
    pixel: PByte;
    idx, channel, alpha: Integer;
begin
    if stream.Size < Int64(image_offset) + SizeOf(TBitmapInfoHeader) + size * size * 4 then
        raise Exception.Create('Incomplete rendered icon bitmap.');
    info := Pointer(NativeUInt(stream.Memory) + image_offset);
    if (info.biSize <> SizeOf(TBitmapInfoHeader)) or (info.biBitCount <> 32) or
        (info.biCompression <> BI_RGB) or (info.biWidth <> size) or (info.biHeight <> size * 2) then
        raise Exception.Create('Expected a 32-bit BGRA icon bitmap.');
    pixel := Pointer(NativeUInt(info) + info.biSize);
    // GetHICON uses premultiplied BGRA; ICO resource loading expects straight alpha.
    for idx := 0 to size * size - 1 do
    begin
        alpha := PByte(NativeUInt(pixel) + 3)^;
        for channel := 0 to 2 do
        begin
            if alpha = 0 then
                PByte(NativeUInt(pixel) + NativeUInt(channel))^ := 0
            else if alpha < 255 then
                PByte(NativeUInt(pixel) + NativeUInt(channel))^ := Min(255,
                    (PByte(NativeUInt(pixel) + NativeUInt(channel))^ * 255 + alpha div 2) div alpha);
        end;
        Inc(pixel, 4);
    end;
end;

const
    c_sizes: array[0..9] of Integer = (16, 20, 24, 28, 32, 40, 48, 64, 96, 128);
var
    original, rendered: TIcon;
    frames: array[0..9] of TMemoryStream;
    entries: array[0..9] of TIconEntry;
    header: TIconHeader;
    output: TFileStream;
    idx: Integer;
    offset, frame_offset: Cardinal;
begin
    try
        if ParamCount <> 2 then
            raise Exception.Create('Usage: build_profile_icon <original.ico> <profile.ico>');
        if SameText(ExpandFileName(ParamStr(1)), ExpandFileName(ParamStr(2))) then
            raise Exception.Create('The original icon must not be overwritten.');
        original := TIcon.Create;
        rendered := nil;
        try
            original.LoadFromFile(ParamStr(1));
            offset := SizeOf(header) + Length(entries) * SizeOf(TIconEntry);
            for idx := Low(c_sizes) to High(c_sizes) do
            begin
                FreeAndNil(rendered);
                rendered := nc_create_profile_icon(HInstance, 'YANQUAN_MARK_PNG', c_sizes[idx]);
                if (rendered = nil) or (rendered.Width <> c_sizes[idx]) or
                    (rendered.Height <> c_sizes[idx]) then
                    raise Exception.Create('Profile icon rendering failed.');
                frames[idx] := TMemoryStream.Create;
                rendered.SaveToStream(frames[idx]);
                frames[idx].Position := 0;
                frames[idx].ReadBuffer(header, SizeOf(header));
                if (header.kind <> 1) or (header.count <> 1) then
                    raise Exception.Create('Expected one rendered icon frame.');
                frames[idx].ReadBuffer(entries[idx], SizeOf(TIconEntry));
                frame_offset := entries[idx].image_offset;
                encode_straight_alpha(frames[idx], frame_offset, c_sizes[idx]);
                entries[idx].image_offset := offset;
                Inc(offset, entries[idx].image_size);
                frames[idx].Position := frame_offset;
            end;
            header.reserved := 0;
            header.kind := 1;
            header.count := Length(c_sizes);
            output := TFileStream.Create(ParamStr(2), fmCreate);
            try
                output.WriteBuffer(header, SizeOf(header));
                output.WriteBuffer(entries, SizeOf(entries));
                for idx := Low(c_sizes) to High(c_sizes) do
                    output.CopyFrom(frames[idx], entries[idx].image_size);
            finally output.Free; end;
            Writeln('Generated ', ParamStr(2), ' (10 sizes, 16-128 px)');
        finally
            for idx := Low(frames) to High(frames) do frames[idx].Free;
            rendered.Free;
            original.Free;
        end;
    except
        on E: Exception do
        begin
            Writeln(E.ClassName, ': ', E.Message);
            ExitCode := 1;
        end;
    end;
end.

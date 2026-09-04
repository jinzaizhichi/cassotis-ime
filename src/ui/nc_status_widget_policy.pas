unit nc_status_widget_policy;

interface

uses
    nc_types;

type
    TncStatusWidgetControl = (
        swc_input_mode,
        swc_dictionary_variant,
        swc_pinyin_scheme,
        swc_full_width,
        swc_punctuation,
        swc_settings
    );

function nc_status_widget_control_enabled(const input_mode: TncInputMode;
    const control: TncStatusWidgetControl): Boolean;

implementation

function nc_status_widget_control_enabled(const input_mode: TncInputMode;
    const control: TncStatusWidgetControl): Boolean;
begin
    case control of
        swc_dictionary_variant,
        swc_pinyin_scheme,
        swc_punctuation:
            Result := input_mode <> im_english;
    else
        Result := True;
    end;
end;

end.

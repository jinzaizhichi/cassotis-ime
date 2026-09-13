unit nc_tsf_config_actions;

interface

uses
    System.SysUtils,
    nc_types;

// Returns whether the host acknowledged the change (including fallback reload).
function nc_tsf_toggle_dictionary_variant(const config_path: string;
    const apply_variant: TFunc<TncDictionaryVariant, Boolean>;
    const reload_config: TFunc<Boolean>;
    out variant: TncDictionaryVariant): Boolean;

implementation

uses
    nc_config;

function nc_tsf_toggle_dictionary_variant(const config_path: string;
    const apply_variant: TFunc<TncDictionaryVariant, Boolean>;
    const reload_config: TFunc<Boolean>;
    out variant: TncDictionaryVariant): Boolean;
var
    manager: TncConfigManager;
    config: TncEngineConfig;
begin
    Result := False;
    variant := dv_simplified;
    if config_path = '' then
        Exit;

    manager := TncConfigManager.create(config_path, clmReadOnly);
    try
        config := manager.load_engine_config;
    finally
        manager.Free;
    end;
    if config.dictionary_variant = dv_traditional then
        variant := dv_simplified
    else
        variant := dv_traditional;

    // The host persists configuration before replying. Holding its named
    // config mutex across either IPC callback deadlocks the caller and host.
    if Assigned(apply_variant) and apply_variant(variant) then
        Exit(True);

    manager := TncConfigManager.create(config_path, clmBestEffort);
    try
        manager.save_dictionary_variant_config(variant);
    finally
        manager.Free;
    end;
    if Assigned(reload_config) then
        Result := reload_config();
end;

end.

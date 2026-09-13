unit nc_tsf_config_actions;

interface

uses
    System.SysUtils,
    nc_types;

type
    TncTsfReadDictionaryVariant = reference to function(
        out variant: TncDictionaryVariant): Boolean;

// Returns whether the host acknowledged the change (including fallback reload).
function nc_tsf_toggle_dictionary_variant(const config_path: string;
    const apply_variant: TFunc<TncDictionaryVariant, Boolean>;
    const reload_config: TFunc<Boolean>;
    out variant: TncDictionaryVariant;
    const read_host_variant: TncTsfReadDictionaryVariant = nil): Boolean;

implementation

uses
    nc_config;

function nc_tsf_toggle_dictionary_variant(const config_path: string;
    const apply_variant: TFunc<TncDictionaryVariant, Boolean>;
    const reload_config: TFunc<Boolean>;
    out variant: TncDictionaryVariant;
    const read_host_variant: TncTsfReadDictionaryVariant): Boolean;
var
    manager: TncConfigManager;
    config: TncEngineConfig;
    current_variant: TncDictionaryVariant;
begin
    Result := False;
    variant := dv_simplified;
    if config_path = '' then
        Exit;

    // Packaged clients can read stale/default INI values. Invert the host's
    // actual state, just as input-mode shortcuts use host-owned state.
    current_variant := dv_simplified;
    if not (Assigned(read_host_variant) and read_host_variant(current_variant)) then
    begin
        manager := TncConfigManager.create(config_path, clmReadOnly);
        try
            config := manager.load_engine_config;
            current_variant := config.dictionary_variant;
        finally
            manager.Free;
        end;
    end;
    if current_variant = dv_traditional then
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

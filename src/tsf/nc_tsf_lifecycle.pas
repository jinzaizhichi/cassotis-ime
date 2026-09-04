unit nc_tsf_lifecycle;

interface

uses
    Winapi.Windows,
    Winapi.Msctf,
    nc_types;

type
    TncTsfShortcutEventSource = (
        tses_key_sink,
        tses_preserved_key,
        tses_key_trace
    );
    TncTsfPreservedKeyOwner = (
        tpko_none,
        tpko_text_service,
        tpko_external
    );
    TncTsfCompartmentChangeSource = (
        tccs_unknown,
        tccs_openclose,
        tccs_conversion
    );

const
    c_nc_tsf_invalid_sink_cookie = DWORD($FFFFFFFF);
    c_nc_tsf_chord_repeat_timeout_ms = UInt64(500);
    c_nc_tsf_preserved_key_duplicate_window_ms = UInt64(100);
    c_nc_tsf_external_transition_timeout_ms = UInt64(1500);
    c_nc_tsf_system_shortcut_prefix_timeout_ms = UInt64(1000);
    c_nc_tsf_rejected_modifier_transition_timeout_ms = UInt64(750);

function nc_tsf_sink_cookie_is_valid(const cookie: DWORD): Boolean;
function nc_tsf_try_unadvise_sink(const source: ITfSource; var cookie: DWORD): Boolean;
function nc_tsf_shortcut_to_preserved_key(const shortcut: TncShortcut;
    out preserved_key: TF_PRESERVEDKEY): Boolean;
function nc_tsf_shortcut_matches_system_hotkey(const shortcut: TncShortcut;
    const virtual_key: UINT; const modifiers: UINT): Boolean;
function nc_tsf_preserved_key_owner_from_result(
    const preserve_result: HRESULT): TncTsfPreservedKeyOwner;
function nc_tsf_resolve_preserved_key_owner(
    const preserve_result: HRESULT;
    const windows_hotkey_match: Boolean): TncTsfPreservedKeyOwner;
function nc_tsf_should_defer_input_mode_shortcut(
    const owner: TncTsfPreservedKeyOwner): Boolean;
function nc_tsf_should_execute_chord_shortcut(
    const source: TncTsfShortcutEventSource;
    const pending: Boolean;
    const pending_source: TncTsfShortcutEventSource;
    const same_chord: Boolean;
    const elapsed_ms: UInt64;
    const key_down_is_repeat: Boolean = False): Boolean;
function nc_tsf_key_down_is_repeat(const l_param: LPARAM): Boolean;
function nc_tsf_external_transition_is_active(const pending: Boolean;
    const elapsed_ms: UInt64): Boolean;
function nc_tsf_external_transition_should_settle(const pending: Boolean;
    const target_mode: TncInputMode;
    const observed_mode: TncInputMode): Boolean;
function nc_tsf_system_shortcut_prefix_is_active(const pending: Boolean;
    const elapsed_ms: UInt64): Boolean;
function nc_tsf_is_unconfigured_shift_toggle(
    const configured_shortcut: TncShortcut;
    const key_code: Word;
    const key_state: TncKeyState): Boolean;
function nc_tsf_shortcut_is_bare_shift(
    const configured_shortcut: TncShortcut): Boolean;
function nc_tsf_shortcut_is_ctrl_space(
    const configured_shortcut: TncShortcut): Boolean;
function nc_tsf_should_reject_unconfigured_ctrl_space_toggle(
    const configured_shortcut: TncShortcut;
    const windows_ctrl_space_hotkey: Boolean;
    const shortcut_prefix_consumed: Boolean): Boolean;
function nc_tsf_terminal_ctrl_space_hook_matches(
    const configured_shortcut: TncShortcut;
    const terminal_has_focus: Boolean;
    const key_code: Word;
    const key_state: TncKeyState): Boolean;
function nc_tsf_terminal_ctrl_space_hook_should_capture(
    const configured_shortcut: TncShortcut;
    const windows_ctrl_space_hotkey: Boolean;
    const terminal_has_focus: Boolean;
    const key_code: Word;
    const key_state: TncKeyState): Boolean;
function nc_tsf_is_terminal_compatibility_identity(
    const process_name: string; const window_class_name: string): Boolean;
function nc_tsf_should_reject_unconfigured_terminal_mode_change(
    const configured_shortcut: TncShortcut;
    const terminal_like_target: Boolean;
    const external_transition: Boolean;
    const input_mode_changed: Boolean;
    const host_state_matches_proposed: Boolean): Boolean;
function nc_tsf_rejected_modifier_transition_is_active(
    const pending: Boolean; const elapsed_ms: UInt64): Boolean;
function nc_tsf_resolve_punctuation_full_width(
    const previous_input_mode: TncInputMode;
    const next_input_mode: TncInputMode;
    const previous_punctuation_full_width: Boolean;
    const has_conversion: Boolean;
    const conversion_value: DWORD): Boolean;
function nc_tsf_resolve_input_mode(
    const previous_input_mode: TncInputMode;
    const change_source: TncTsfCompartmentChangeSource;
    const has_openclose: Boolean;
    const openclose_value: DWORD;
    const has_conversion: Boolean;
    const conversion_value: DWORD): TncInputMode;

implementation

uses
    System.SysUtils,
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

function nc_tsf_shortcut_matches_system_hotkey(const shortcut: TncShortcut;
    const virtual_key: UINT; const modifiers: UINT): Boolean;
const
    c_supported_modifier_mask = MOD_ALT or MOD_CONTROL or MOD_SHIFT or MOD_WIN;
var
    expected_modifiers: UINT;
begin
    Result := False;
    if not nc_shortcut_is_valid(shortcut) or
        nc_shortcut_is_modifier_only(shortcut) or
        (nc_normalize_shortcut_key_code(shortcut.key_code) <> virtual_key) then
    begin
        Exit;
    end;

    expected_modifiers := 0;
    if shortcut.alt_down then
    begin
        expected_modifiers := expected_modifiers or MOD_ALT;
    end;
    if shortcut.ctrl_down then
    begin
        expected_modifiers := expected_modifiers or MOD_CONTROL;
    end;
    if shortcut.shift_down then
    begin
        expected_modifiers := expected_modifiers or MOD_SHIFT;
    end;
    Result := (modifiers and c_supported_modifier_mask) =
        expected_modifiers;
end;

function nc_tsf_preserved_key_owner_from_result(
    const preserve_result: HRESULT): TncTsfPreservedKeyOwner;
begin
    if not Failed(preserve_result) then
    begin
        Result := tpko_text_service;
    end
    else if preserve_result = TF_E_ALREADY_EXISTS then
    begin
        // Windows reserves chords such as Ctrl+Space for its own IME
        // open/close handling. Falling back to the key sink in this case would
        // execute the same physical key twice.
        Result := tpko_external;
    end
    else
    begin
        Result := tpko_none;
    end;
end;

function nc_tsf_resolve_preserved_key_owner(
    const preserve_result: HRESULT;
    const windows_hotkey_match: Boolean): TncTsfPreservedKeyOwner;
begin
    // ImmGetHotKey reports the legacy Windows shortcut, not ownership in this
    // TSF thread manager. A successful PreserveKey therefore always wins.
    Result := nc_tsf_preserved_key_owner_from_result(preserve_result);
    if (Result = tpko_none) and windows_hotkey_match then
    begin
        Result := tpko_external;
    end;
end;

function nc_tsf_should_defer_input_mode_shortcut(
    const owner: TncTsfPreservedKeyOwner): Boolean;
begin
    Result := owner = tpko_external;
end;

function nc_tsf_should_execute_chord_shortcut(
    const source: TncTsfShortcutEventSource;
    const pending: Boolean;
    const pending_source: TncTsfShortcutEventSource;
    const same_chord: Boolean;
    const elapsed_ms: UInt64;
    const key_down_is_repeat: Boolean): Boolean;
begin
    if (source = tses_key_trace) and key_down_is_repeat then
    begin
        Result := False;
        Exit;
    end;

    if (not pending) or (not same_chord) then
    begin
        Result := True;
        Exit;
    end;

    if source <> pending_source then
    begin
        // The trace, preserved-key and ordinary key sinks can all report the
        // same physical chord. Only the first path executes it.
        Result := elapsed_ms > c_nc_tsf_preserved_key_duplicate_window_ms;
        Exit;
    end;

    if source = tses_key_trace then
    begin
        // Some console hosts omit OnKeyTraceUp. WM_KEYDOWN bit 30 still
        // distinguishes keyboard auto-repeat from a new press after release,
        // so do not keep the next real Ctrl+Space blocked for 500 ms.
        Result := True;
    end
    else if source = tses_preserved_key then
    begin
        // Preserved-key dispatch has no matching key-up callback. Consecutive
        // callbacks therefore represent separate physical presses.
        Result := True;
    end
    else
    begin
        // Suppress key auto-repeat until key-up, with a stale-state escape hatch
        // for clients that never deliver the corresponding key-up callback.
        Result := elapsed_ms > c_nc_tsf_chord_repeat_timeout_ms;
    end;
end;

function nc_tsf_key_down_is_repeat(const l_param: LPARAM): Boolean;
const
    c_previous_key_state_mask = NativeUInt(1) shl 30;
begin
    Result := (NativeUInt(l_param) and c_previous_key_state_mask) <> 0;
end;

function nc_tsf_external_transition_is_active(const pending: Boolean;
    const elapsed_ms: UInt64): Boolean;
begin
    Result := pending and
        (elapsed_ms <= c_nc_tsf_external_transition_timeout_ms);
end;

function nc_tsf_external_transition_should_settle(const pending: Boolean;
    const target_mode: TncInputMode;
    const observed_mode: TncInputMode): Boolean;
begin
    // The timeout is only an emergency bound for split/stale compartment
    // notifications. Once Windows reports the requested mode, later changes
    // are separate Ctrl+Space presses and must not remain pinned to this one.
    Result := pending and (target_mode = observed_mode);
end;

function nc_tsf_system_shortcut_prefix_is_active(const pending: Boolean;
    const elapsed_ms: UInt64): Boolean;
begin
    Result := pending and
        (elapsed_ms <= c_nc_tsf_system_shortcut_prefix_timeout_ms);
end;

function nc_tsf_is_unconfigured_shift_toggle(
    const configured_shortcut: TncShortcut;
    const key_code: Word;
    const key_state: TncKeyState): Boolean;
begin
    // Console compatibility hosts can apply the Windows Shift-only IME toggle
    // before ITfKeyEventSink receives an ordinary key-down callback. Remember
    // that event only when Shift is not the configured Cassotis shortcut.
    // The key-down callback itself is authoritative for Shift. Some console
    // compatibility paths report it before GetKeyState reflects the new bit.
    Result := (nc_normalize_shortcut_key_code(key_code) = VK_SHIFT) and
        (not key_state.ctrl_down) and
        (not key_state.alt_down) and
        (not nc_shortcut_matches(configured_shortcut, key_code, key_state));
end;

function nc_tsf_shortcut_is_bare_shift(
    const configured_shortcut: TncShortcut): Boolean;
begin
    Result := nc_shortcut_is_valid(configured_shortcut) and
        (nc_normalize_shortcut_key_code(configured_shortcut.key_code) = VK_SHIFT) and
        (not configured_shortcut.shift_down) and
        (not configured_shortcut.ctrl_down) and
        (not configured_shortcut.alt_down);
end;

function nc_tsf_shortcut_is_ctrl_space(
    const configured_shortcut: TncShortcut): Boolean;
begin
    Result := nc_shortcut_is_valid(configured_shortcut) and
        (nc_normalize_shortcut_key_code(configured_shortcut.key_code) = VK_SPACE) and
        (not configured_shortcut.shift_down) and
        configured_shortcut.ctrl_down and
        (not configured_shortcut.alt_down);
end;

function nc_tsf_should_reject_unconfigured_ctrl_space_toggle(
    const configured_shortcut: TncShortcut;
    const windows_ctrl_space_hotkey: Boolean;
    const shortcut_prefix_consumed: Boolean): Boolean;
begin
    Result := windows_ctrl_space_hotkey and shortcut_prefix_consumed and
        (not nc_tsf_shortcut_is_ctrl_space(configured_shortcut));
end;

function nc_tsf_terminal_ctrl_space_hook_matches(
    const configured_shortcut: TncShortcut;
    const terminal_has_focus: Boolean;
    const key_code: Word;
    const key_state: TncKeyState): Boolean;
begin
    Result := terminal_has_focus and
        nc_tsf_shortcut_is_ctrl_space(configured_shortcut) and
        (nc_normalize_shortcut_key_code(key_code) = VK_SPACE) and
        (not key_state.shift_down) and key_state.ctrl_down and
        (not key_state.alt_down);
end;

function nc_tsf_terminal_ctrl_space_hook_should_capture(
    const configured_shortcut: TncShortcut;
    const windows_ctrl_space_hotkey: Boolean;
    const terminal_has_focus: Boolean;
    const key_code: Word;
    const key_state: TncKeyState): Boolean;
begin
    Result := terminal_has_focus and
        (nc_tsf_shortcut_is_ctrl_space(configured_shortcut) or
        windows_ctrl_space_hotkey) and
        (nc_normalize_shortcut_key_code(key_code) = VK_SPACE) and
        (not key_state.shift_down) and key_state.ctrl_down and
        (not key_state.alt_down);
end;

function nc_tsf_is_terminal_compatibility_identity(
    const process_name: string; const window_class_name: string): Boolean;
var
    normalized_process_name: string;
    normalized_class_name: string;
begin
    normalized_process_name := LowerCase(ExtractFileName(Trim(process_name)));
    normalized_class_name := LowerCase(Trim(window_class_name));
    Result := (normalized_process_name = 'windowsterminal.exe') or
        (normalized_process_name = 'openconsole.exe') or
        (normalized_process_name = 'conhost.exe') or
        (Pos('consolewindowclass', normalized_class_name) > 0) or
        (Pos('cascadia_hosting_window_class', normalized_class_name) > 0) or
        (Pos('pseudoconsole', normalized_class_name) > 0);
end;

function nc_tsf_should_reject_unconfigured_terminal_mode_change(
    const configured_shortcut: TncShortcut;
    const terminal_like_target: Boolean;
    const external_transition: Boolean;
    const input_mode_changed: Boolean;
    const host_state_matches_proposed: Boolean): Boolean;
begin
    // Some console compatibility paths change TSF compartments directly for
    // bare Shift and never dispatch a key event to the text service. A state
    // already selected by the host (for example from Cassotis' status UI) is
    // still accepted; only an uncorrelated compatibility-layer toggle is
    // restored.
    Result := terminal_like_target and (not external_transition) and
        input_mode_changed and (not host_state_matches_proposed) and
        (not nc_tsf_shortcut_is_bare_shift(configured_shortcut));
end;

function nc_tsf_rejected_modifier_transition_is_active(
    const pending: Boolean; const elapsed_ms: UInt64): Boolean;
begin
    Result := pending and
        (elapsed_ms <= c_nc_tsf_rejected_modifier_transition_timeout_ms);
end;

function nc_tsf_resolve_input_mode(
    const previous_input_mode: TncInputMode;
    const change_source: TncTsfCompartmentChangeSource;
    const has_openclose: Boolean;
    const openclose_value: DWORD;
    const has_conversion: Boolean;
    const conversion_value: DWORD): TncInputMode;
begin
    Result := previous_input_mode;
    // Open/close is the authoritative Chinese/English state. Windows can
    // deliver open/close and conversion notifications separately; allowing a
    // stale conversion value to win makes one Ctrl+Space press appear to undo
    // itself.
    if has_openclose then
    begin
        if openclose_value <> 0 then
        begin
            Result := im_chinese;
        end
        else
        begin
            Result := im_english;
        end;
        Exit;
    end;

    if has_conversion and ((change_source = tccs_conversion) or
        (change_source = tccs_unknown) or (not has_openclose)) then
    begin
        if (conversion_value and TF_CONVERSIONMODE_NATIVE) <> 0 then
        begin
            Result := im_chinese;
        end
        else
        begin
            Result := im_english;
        end;
        Exit;
    end;

end;

function nc_tsf_resolve_punctuation_full_width(
    const previous_input_mode: TncInputMode;
    const next_input_mode: TncInputMode;
    const previous_punctuation_full_width: Boolean;
    const has_conversion: Boolean;
    const conversion_value: DWORD): Boolean;
begin
    Result := previous_punctuation_full_width;
    if not has_conversion then
    begin
        Exit;
    end;

    // English mode intentionally clears TF_CONVERSIONMODE_SYMBOL. During an
    // external English-to-Chinese transition, open/close and conversion can be
    // reported separately, so the old English value must not erase the saved
    // Chinese punctuation preference.
    if (previous_input_mode <> im_english) and
        (next_input_mode <> im_english) then
    begin
        Result := (conversion_value and TF_CONVERSIONMODE_SYMBOL) <> 0;
    end;
end;

end.

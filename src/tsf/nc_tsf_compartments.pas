unit nc_tsf_compartments;

interface

uses
    Winapi.Windows,
    Winapi.Messages,
    Winapi.Msctf,
    System.Classes;

type
    TncTsfDeferredCompartmentSync = class
    private
        m_window: HWND;
        m_depth: Integer;
        m_pending, m_posted: Boolean;
        m_last_error: DWORD;
        m_action: TThreadMethod;
        function post_pending: Boolean;
        procedure window_proc(var message: TMessage);
        function get_notifying: Boolean;
    public
        constructor Create(const action: TThreadMethod);
        destructor Destroy; override;
        procedure BeginNotification;
        function EndNotification: Boolean;
        function Request: Boolean;
        procedure Cancel;
        procedure Close;
        property notifying: Boolean read get_notifying;
        property pending: Boolean read m_pending;
        property last_error: DWORD read m_last_error;
    end;

const
    GUID_COMPARTMENT_KEYBOARD_OPENCLOSE: TGUID = '{58273AAD-01BB-4164-95C6-755BA0B5162D}';
    GUID_COMPARTMENT_KEYBOARD_INPUTMODE_CONVERSION: TGUID = '{CCF05DD8-4A87-11D7-A6E2-00065B84435C}';

    TF_CONVERSIONMODE_ALPHANUMERIC = $0000;
    TF_CONVERSIONMODE_NATIVE = $0001;
    TF_CONVERSIONMODE_FULLSHAPE = $0008;
    TF_CONVERSIONMODE_SYMBOL = $0400;

function nc_read_compartment_dword(const compartment: ITfCompartment;
    out value: DWORD; out status: HRESULT): Boolean;
function nc_write_compartment_dword(const compartment: ITfCompartment;
    const client_id: TfClientId; const value: DWORD; out status: HRESULT): Boolean;
function nc_compartments_need_rebind(const open_status, conversion_status: HRESULT): Boolean;

implementation

uses
    System.SysUtils,
    System.Variants;

const
    c_sync_message = WM_APP + $3C1;

constructor TncTsfDeferredCompartmentSync.Create(const action: TThreadMethod);
begin
    inherited Create;
    m_action := action;
end;

destructor TncTsfDeferredCompartmentSync.Destroy;
begin
    Close;
    inherited;
end;

procedure TncTsfDeferredCompartmentSync.Close;
begin
    Cancel;
    if m_window <> 0 then
    begin
        DeallocateHWnd(m_window);
        m_window := 0;
    end;
    m_posted := False;
end;

procedure TncTsfDeferredCompartmentSync.Cancel;
begin
    m_pending := False;
end;

function TncTsfDeferredCompartmentSync.get_notifying: Boolean;
begin
    Result := m_depth > 0;
end;

procedure TncTsfDeferredCompartmentSync.BeginNotification;
begin
    Inc(m_depth);
end;

function TncTsfDeferredCompartmentSync.EndNotification: Boolean;
begin
    if m_depth > 0 then
        Dec(m_depth);
    Result := post_pending;
end;

function TncTsfDeferredCompartmentSync.Request: Boolean;
begin
    m_pending := True;
    Result := post_pending;
end;

function TncTsfDeferredCompartmentSync.post_pending: Boolean;
begin
    Result := True;
    if (not m_pending) or m_posted or notifying then
        Exit;
    try
        if m_window = 0 then
            m_window := AllocateHWnd(window_proc);
        Result := (m_window <> 0) and PostMessage(m_window, c_sync_message, 0, 0);
        if Result then
        begin
            m_posted := True;
            m_last_error := ERROR_SUCCESS;
        end
        else
            m_last_error := GetLastError;
    except
        m_last_error := ERROR_GEN_FAILURE;
        Result := False;
    end;
end;

procedure TncTsfDeferredCompartmentSync.window_proc(var message: TMessage);
begin
    if message.Msg <> c_sync_message then
    begin
        message.Result := DefWindowProc(m_window, message.Msg, message.WParam, message.LParam);
        Exit;
    end;
    message.Result := 0;
    m_posted := False;
    // A nested COM message pump must not run SetValue inside OnChange either.
    // EndNotification posts once after the outermost callback has unwound.
    if (not m_pending) or notifying then
        Exit;
    m_pending := False;
    try
        if Assigned(m_action) then
            m_action();
    except
        // Never let a deferred TSF callback escape into the application's loop.
        m_last_error := ERROR_GEN_FAILURE;
    end;
end;

function nc_read_compartment_dword(const compartment: ITfCompartment;
    out value: DWORD; out status: HRESULT): Boolean;
var
    variant_value: OleVariant;
    int_value: Integer;
begin
    Result := False;
    value := 0;
    status := E_POINTER;
    if compartment = nil then
        Exit;
    variant_value := Unassigned;
    status := compartment.GetValue(variant_value);
    if status <> S_OK then
        Exit;
    if VarIsEmpty(variant_value) or VarIsNull(variant_value) then
    begin
        status := S_FALSE;
        Exit;
    end;
    try
        int_value := variant_value;
    except
        status := DISP_E_TYPEMISMATCH;
        Exit;
    end;
    if int_value < 0 then
        int_value := 0;
    value := DWORD(int_value);
    Result := True;
end;

function nc_write_compartment_dword(const compartment: ITfCompartment;
    const client_id: TfClientId; const value: DWORD; out status: HRESULT): Boolean;
var
    current_value: DWORD;
    variant_value: OleVariant;
begin
    Result := False;
    status := E_POINTER;
    if compartment = nil then
        Exit;
    status := E_INVALIDARG;
    if client_id = 0 then
        Exit;
    if nc_read_compartment_dword(compartment, current_value, status) and
        (current_value = value) then
        Exit(True);
    variant_value := Integer(value);
    status := compartment.SetValue(client_id, variant_value);
    Result := status = S_OK;
end;

function nc_compartments_need_rebind(const open_status, conversion_status: HRESULT): Boolean;
begin
    // Outside OnChange this can indicate a cleared, now stale compartment object.
    Result := (open_status = E_UNEXPECTED) or (conversion_status = E_UNEXPECTED);
end;

end.

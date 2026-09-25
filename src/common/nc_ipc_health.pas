unit nc_ipc_health;

interface

uses
    Winapi.Windows;

type
    TncIpcHealthEvent = (ihe_none, ihe_failure, ihe_still_failing, ihe_recovered);

    TncIpcHealthReport = record
        event: TncIpcHealthEvent;
        error: DWORD;
        // Failed calls and elapsed time since the first failure of this outage.
        failures: Cardinal;
        duration_ms: UInt64;
    end;

    // Decides which IPC outcomes deserve a log line: the first failure, a
    // changed error, a periodic reminder while failures continue, and the
    // recovery. Identical repeated failures are counted instead of logged, but
    // an outage can no longer go silent after its first line.
    TncIpcHealth = record
    private
        m_failing: Boolean;
        m_error: DWORD;
        m_failures: Cardinal;
        m_first_failure_tick: UInt64;
        m_last_report_tick: UInt64;
    public
        procedure reset;
        function note(const ok: Boolean; const error: DWORD; const now_tick: UInt64): TncIpcHealthReport;
        property failing: Boolean read m_failing;
    end;

const
    c_nc_ipc_failure_report_interval_ms = 30000;

implementation

procedure TncIpcHealth.reset;
begin
    m_failing := False;
    m_error := ERROR_SUCCESS;
    m_failures := 0;
    m_first_failure_tick := 0;
    m_last_report_tick := 0;
end;

function TncIpcHealth.note(const ok: Boolean; const error: DWORD; const now_tick: UInt64): TncIpcHealthReport;
begin
    Result := Default(TncIpcHealthReport);
    if ok then
    begin
        if m_failing then
        begin
            Result.event := ihe_recovered;
            Result.error := m_error;
            Result.failures := m_failures;
            Result.duration_ms := now_tick - m_first_failure_tick;
        end;
        reset;
        Exit;
    end;

    if not m_failing then
    begin
        m_failing := True;
        m_first_failure_tick := now_tick;
        m_failures := 0;
    end;
    if m_failures < High(Cardinal) then
    begin
        Inc(m_failures);
    end;
    Result.error := error;
    Result.failures := m_failures;
    Result.duration_ms := now_tick - m_first_failure_tick;
    if (m_failures = 1) or (error <> m_error) then
    begin
        Result.event := ihe_failure;
    end
    else if now_tick - m_last_report_tick >= c_nc_ipc_failure_report_interval_ms then
    begin
        Result.event := ihe_still_failing;
    end;
    m_error := error;
    if Result.event <> ihe_none then
    begin
        m_last_report_tick := now_tick;
    end;
end;

end.

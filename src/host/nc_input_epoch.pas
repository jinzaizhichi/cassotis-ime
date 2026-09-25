unit nc_input_epoch;

interface

uses
    System.SysUtils,
    System.SyncObjs,
    System.Generics.Collections;

type
    TncInputEpochDecision = (ied_current, ied_advanced, ied_stale);

    // Orders the input requests of each TSF session across pipe workers.
    // A client starts a new epoch whenever it resets its session, and every
    // RESET and PROCESS_KEY carries the epoch it was issued in. Cancelling a
    // client-side wait does not stop the host: a request that timed out can
    // still be running, e.g. waiting for the config mutex or session creation,
    // and resume after the client has moved on. Such a request carries an
    // older epoch and is rejected here instead of re-adding a key the
    // application already received unprocessed.
    //
    // Floors are kept per session ID, independent of session objects, so a
    // RESET recorded before the session exists or after it was reclaimed still
    // fences older requests. Admission decisions must be taken under the lock
    // that also guards the engine state they apply to; the internal lock only
    // protects these tables, including the in-flight counts that pipe workers
    // update before they reach that engine lock.
    TncInputEpochs = class
    private
        m_lock: TCriticalSection;
        m_floors: TDictionary<string, UInt64>;
        m_in_flight: TDictionary<string, Integer>;
        function admit_unlocked(const session_id: string; const epoch: UInt64): TncInputEpochDecision;
    public
        constructor create;
        destructor Destroy; override;
        // Epoch 0 marks a client without epochs; it keeps the previous behaviour.
        // ied_advanced tells the caller to reset the session input state before
        // applying the request: the client reset it, even if its RESET was lost.
        function admit(const session_id: string; const epoch: UInt64): TncInputEpochDecision;
        // A RESET takes effect once per epoch: only when it opens the epoch. The
        // epoch may already have been opened by its first PROCESS_KEY (the RESET
        // was delayed) or by an earlier copy of the same RESET; clearing again
        // would drop input typed since.
        function admit_reset(const session_id: string; const epoch: UInt64;
            out stale: Boolean): Boolean;
        function floor(const session_id: string): UInt64;
        // Brackets a request from its arrival until it finishes, so its floor
        // survives trimming while it may still be waiting to be admitted.
        procedure enter(const session_id: string);
        procedure leave(const session_id: string);
        // Above capacity, drops floors of sessions that are gone and have no
        // request in flight. A request can only be late while it is in flight.
        procedure trim(const capacity: Integer; const is_live: TFunc<string, Boolean>);
        function count: Integer;
    end;

implementation

constructor TncInputEpochs.create;
begin
    inherited create;
    m_lock := TCriticalSection.Create;
    m_floors := TDictionary<string, UInt64>.Create;
    m_in_flight := TDictionary<string, Integer>.Create;
end;

destructor TncInputEpochs.Destroy;
begin
    m_in_flight.Free;
    m_floors.Free;
    m_lock.Free;
    inherited Destroy;
end;

function TncInputEpochs.admit_unlocked(const session_id: string; const epoch: UInt64): TncInputEpochDecision;
var
    current: UInt64;
begin
    if (epoch = 0) or (session_id = '') then
    begin
        Exit(ied_current);
    end;
    if not m_floors.TryGetValue(session_id, current) then
    begin
        current := 0;
    end;
    if epoch < current then
    begin
        Exit(ied_stale);
    end;
    if epoch = current then
    begin
        Exit(ied_current);
    end;
    m_floors.AddOrSetValue(session_id, epoch);
    Result := ied_advanced;
end;

function TncInputEpochs.admit(const session_id: string; const epoch: UInt64): TncInputEpochDecision;
begin
    m_lock.Acquire;
    try
        Result := admit_unlocked(session_id, epoch);
    finally
        m_lock.Release;
    end;
end;

function TncInputEpochs.admit_reset(const session_id: string; const epoch: UInt64;
    out stale: Boolean): Boolean;
var
    decision: TncInputEpochDecision;
begin
    m_lock.Acquire;
    try
        decision := admit_unlocked(session_id, epoch);
    finally
        m_lock.Release;
    end;
    stale := decision = ied_stale;
    Result := (epoch = 0) or (decision = ied_advanced);
end;

function TncInputEpochs.floor(const session_id: string): UInt64;
begin
    m_lock.Acquire;
    try
        if not m_floors.TryGetValue(session_id, Result) then
        begin
            Result := 0;
        end;
    finally
        m_lock.Release;
    end;
end;

procedure TncInputEpochs.enter(const session_id: string);
var
    current: Integer;
begin
    if session_id = '' then
    begin
        Exit;
    end;
    m_lock.Acquire;
    try
        if not m_in_flight.TryGetValue(session_id, current) then
        begin
            current := 0;
        end;
        m_in_flight.AddOrSetValue(session_id, current + 1);
    finally
        m_lock.Release;
    end;
end;

procedure TncInputEpochs.leave(const session_id: string);
var
    current: Integer;
begin
    if session_id = '' then
    begin
        Exit;
    end;
    m_lock.Acquire;
    try
        if m_in_flight.TryGetValue(session_id, current) then
        begin
            if current <= 1 then
            begin
                m_in_flight.Remove(session_id);
            end
            else
            begin
                m_in_flight.AddOrSetValue(session_id, current - 1);
            end;
        end;
    finally
        m_lock.Release;
    end;
end;

procedure TncInputEpochs.trim(const capacity: Integer; const is_live: TFunc<string, Boolean>);
var
    session_id: string;
begin
    m_lock.Acquire;
    try
        if m_floors.Count <= capacity then
        begin
            Exit;
        end;
        for session_id in m_floors.Keys.ToArray do
        begin
            if (not m_in_flight.ContainsKey(session_id)) and (not is_live(session_id)) then
            begin
                m_floors.Remove(session_id);
            end;
        end;
    finally
        m_lock.Release;
    end;
end;

function TncInputEpochs.count: Integer;
begin
    m_lock.Acquire;
    try
        Result := m_floors.Count;
    finally
        m_lock.Release;
    end;
end;

end.

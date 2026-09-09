unit nc_candidate_presentation;

interface

uses
    System.SysUtils, nc_types;

// Presentation only: no dictionary queries, learning, LM scoring or truncation.
function nc_visible_candidate_key(const candidate: TncCandidate;
    const normalized_tail: string): string;
function nc_candidate_page_count(const total, page_size: Integer): Integer;
function nc_candidate_page_items(const total, page_index, page_size: Integer): Integer;
procedure nc_copy_candidate_page(const candidates: TncCandidateList;
    const sources: TArray<Integer>; const page_index, page_size: Integer;
    out page: TncCandidateList; out page_sources: TArray<Integer>);
procedure nc_order_candidate_prefix_tiers(var candidates: TncCandidateList;
    var sources: TArray<Integer>; const prefix_units: TArray<Integer>;
    const max_prefix_units: Integer);

implementation

function nc_visible_candidate_key(const candidate: TncCandidate;
    const normalized_tail: string): string;
begin
    Result := LowerCase(Trim(candidate.text)) + #0 + LowerCase(normalized_tail);
end;

function nc_candidate_page_count(const total, page_size: Integer): Integer;
begin
    if (total <= 0) or (page_size <= 0) then Exit(0);
    Result := 1 + (total - 1) div page_size;
end;

function nc_candidate_page_items(const total, page_index, page_size: Integer): Integer;
var offset: Int64;
begin
    Result := 0;
    if (total <= 0) or (page_index < 0) or (page_size <= 0) then Exit;
    offset := Int64(page_index) * page_size;
    if offset >= total then Exit;
    Result := total - Integer(offset);
    if Result > page_size then Result := page_size;
end;

procedure nc_copy_candidate_page(const candidates: TncCandidateList;
    const sources: TArray<Integer>; const page_index, page_size: Integer;
    out page: TncCandidateList; out page_sources: TArray<Integer>);
var count, offset: Integer;
begin
    if Length(candidates) <> Length(sources) then
        raise EArgumentException.Create('Candidate/source count mismatch');
    count := nc_candidate_page_items(Length(candidates), page_index, page_size);
    offset := 0;
    if count > 0 then offset := Integer(Int64(page_index) * page_size);
    page := Copy(candidates, offset, count);
    page_sources := Copy(sources, offset, count);
end;

procedure nc_order_candidate_prefix_tiers(var candidates: TncCandidateList;
    var sources: TArray<Integer>; const prefix_units: TArray<Integer>;
    const max_prefix_units: Integer);
var
    original: TncCandidateList;
    original_sources: TArray<Integer>;
    idx, units, previous_units, target: Integer;
    needs_order: Boolean;
begin
    if (Length(candidates) <> Length(sources)) or
        (Length(candidates) <> Length(prefix_units)) then
        raise EArgumentException.Create('Candidate/prefix/source count mismatch');
    needs_order := False;
    previous_units := max_prefix_units;
    for idx := 0 to High(prefix_units) do
    begin
        units := prefix_units[idx];
        if (units < 0) or (units > max_prefix_units) then
            raise EArgumentException.Create('Invalid candidate prefix length');
        if units = 0 then Continue;
        needs_order := needs_order or (units > previous_units);
        previous_units := units;
    end;
    if not needs_order then Exit;

    // Zero marks a protected slot (complete, predictive, or non-prefix).
    // Move candidate and selection source together; equal-length order is stable.
    original := Copy(candidates);
    original_sources := Copy(sources);
    candidates := Copy(candidates);
    sources := Copy(sources);
    target := 0;
    for units := max_prefix_units downto 1 do
        for idx := 0 to High(prefix_units) do
        begin
            if prefix_units[idx] <> units then Continue;
            while prefix_units[target] = 0 do Inc(target);
            candidates[target] := original[idx];
            sources[target] := original_sources[idx];
            Inc(target);
        end;
end;

end.

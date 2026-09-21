unit nc_candidate_paging;

interface

uses nc_types;

const
    c_candidate_viewport_rows = 4;

type
    TncCandidatePage = record
        page_index: Integer;
        candidates: TncCandidateList;
    end;
    TncCandidatePages = TArray<TncCandidatePage>;

    TncCandidateViewport = record
        expanded: Boolean;
        first_page: Integer;
        row_count: Integer;
        procedure update(const enabled: Boolean; const input_changed: Boolean;
            const current_page, total_pages: Integer;
            const expand_requested: Boolean = False);
    end;

implementation

uses System.Math;

procedure TncCandidateViewport.update(const enabled: Boolean;
    const input_changed: Boolean; const current_page, total_pages: Integer;
    const expand_requested: Boolean);
begin
    if input_changed or not enabled or (total_pages <= 1) then
        expanded := False;
    if enabled and (total_pages > 1) and ((current_page > 0) or
        (expand_requested and not input_changed)) then
        expanded := True;
    row_count := 0;
    if total_pages <= 0 then
    begin
        first_page := 0;
        Exit;
    end;
    row_count := 1;
    if not expanded then
    begin
        first_page := EnsureRange(current_page, 0, total_pages - 1);
        Exit;
    end;
    row_count := Min(c_candidate_viewport_rows, total_pages);
    first_page := EnsureRange(first_page, 0, total_pages - row_count);
    if current_page < first_page then first_page := current_page;
    if current_page >= first_page + row_count then
        first_page := current_page - row_count + 1;
    first_page := EnsureRange(first_page, 0, total_pages - row_count);
end;

end.

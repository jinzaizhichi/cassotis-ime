unit nc_runtime_process_policy;

interface

function nc_normalize_runtime_executable_path(const value: string): string;
function nc_runtime_executable_matches(const actual_path: string;
    const expected_path: string): Boolean;
function nc_runtime_process_requires_replacement(const actual_path: string;
    const expected_path: string): Boolean;

implementation

uses
    System.SysUtils,
    System.IOUtils;

function nc_normalize_runtime_executable_path(const value: string): string;
begin
    Result := Trim(value).Trim(['"']);
    if Result = '' then
    begin
        Exit;
    end;

    try
        Result := TPath.GetFullPath(Result);
    except
        // Preserve a usable comparison value even for a path that disappeared
        // between process enumeration and inspection.
    end;
    Result := LowerCase(Result);
end;

function nc_runtime_executable_matches(const actual_path: string;
    const expected_path: string): Boolean;
var
    normalized_actual: string;
    normalized_expected: string;
begin
    normalized_actual := nc_normalize_runtime_executable_path(actual_path);
    normalized_expected := nc_normalize_runtime_executable_path(expected_path);
    Result := (normalized_actual <> '') and (normalized_expected <> '') and
        SameText(normalized_actual, normalized_expected);
end;

function nc_runtime_process_requires_replacement(const actual_path: string;
    const expected_path: string): Boolean;
begin
    Result := not nc_runtime_executable_matches(actual_path, expected_path);
end;

end.

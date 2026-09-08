var
    TsfUpgradeApplications: string;
    TsfUpgradeScanComplete: Boolean;

procedure ReadTsfUpgradeReport(const Lines: TArrayOfString);
var
    Index: Integer;
begin
    TsfUpgradeApplications := '';
    TsfUpgradeScanComplete := False;
    if GetArrayLength(Lines) < 2 then
        Exit;
    if (Lines[0] <> 'cassotis_tsf_upgrade_report_v1') or
        ((Lines[1] <> 'complete=0') and (Lines[1] <> 'complete=1')) then
        Exit;
    TsfUpgradeScanComplete := Lines[1] = 'complete=1';
    for Index := 2 to GetArrayLength(Lines) - 1 do
    begin
        if Trim(Lines[Index]) <> '' then
        begin
            if TsfUpgradeApplications <> '' then
                TsfUpgradeApplications := TsfUpgradeApplications + #13#10;
            TsfUpgradeApplications := TsfUpgradeApplications + Lines[Index];
        end;
    end;
end;

function TsfUpgradeNoticeRequired: Boolean;
begin
    Result := (not TsfUpgradeScanComplete) or (TsfUpgradeApplications <> '');
end;

function TsfUpgradeNoticeText(const RestartText, IncompleteText: string): string;
begin
    Result := '';
    if not TsfUpgradeNoticeRequired then
        Exit;
    Result := RestartText;
    if not TsfUpgradeScanComplete then
        Result := Result + #13#10#13#10 + IncompleteText;
    if TsfUpgradeApplications <> '' then
        Result := Result + #13#10#13#10 + TsfUpgradeApplications;
end;

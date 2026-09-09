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

function TsfManualRestartApplications(const Plan: TArrayOfString): string;
var
    Applications: TStringList;
    Index, PlanIndex: Integer;
    Automatic: Boolean;
    Row: string;
begin
    Result := TsfUpgradeApplications;
    if GetArrayLength(Plan) < 2 then
        Exit;
    if (Plan[0] <> 'cassotis_tsf_shell_plan_v2') or
        ((Plan[1] <> 'complete=0') and (Plan[1] <> 'complete=1')) then
        Exit;
    { Each auto= entry has passed its own identity and DLL checks. A partial
      scan of a different process must not turn it into a manual-close target. }
    Result := '';
    Applications := TStringList.Create;
    try
        Applications.Text := TsfUpgradeApplications;
        for Index := 0 to Applications.Count - 1 do
        begin
            Row := Applications[Index];
            Automatic := False;
            if (Pos('explorer.exe (pid ', LowerCase(Row)) = 1) or
                (Pos('searchhost.exe (pid ', LowerCase(Row)) = 1) then
                for PlanIndex := 2 to GetArrayLength(Plan) - 1 do
                    if CompareText('auto=' + Row, Plan[PlanIndex]) = 0 then
                        Automatic := True;
            if not Automatic then
            begin
                if Result <> '' then
                    Result := Result + #13#10;
                Result := Result + Row;
            end;
        end;
    finally
        Applications.Free;
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

function ShowTsfUpgradeRestartDialog(const Title, Text, RecheckLabel,
    LaterLabel: string): Integer;
begin
    { Older Inno runtimes accept labels for Yes/No only. Leave Cancel native. }
    Result := TaskDialogMsgBox(Title, Text, mbInformation,
        MB_YESNOCANCEL, [RecheckLabel, LaterLabel], 0);
end;

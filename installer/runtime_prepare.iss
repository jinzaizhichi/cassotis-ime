{ Keep the event boundary fail-closed, including exceptions raised by cleanup. }
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
    FailureDetail: string;
begin
    NeedsRestart := False;
    Result := CustomMessage('RuntimePreparationFailed');
    try
        try
            Result := PrepareRuntimeForInstall;
        finally
            HidePreparingStatus;
        end;
    except
        FailureDetail := GetExceptionMessage;
        Result := CustomMessage('RuntimePreparationFailed') + #13#10 + FailureDetail;
        Log('Runtime preparation failed: ' + FailureDetail);
    end;
    { Empty means success to Inno. Never release guards and accidentally return
      success after an exception, allowing [Files] to run without protection. }
    if Result <> '' then
        ReleaseRuntimeUpgradeGuards;
end;

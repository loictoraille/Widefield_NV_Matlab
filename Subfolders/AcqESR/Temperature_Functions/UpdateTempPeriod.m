function UpdateTempPeriod(~, ~)

UpdateAcqParam();

btnStart=findobj('tag','startCTR');

% Si un timer existe, le relancer (l'arrêt est déjà géré dans la fonction)
if isfield(btnStart.UserData, 'timer') && isvalid(btnStart.UserData.timer)
    StartContinuousTempReadingFunc();
end

end
function TurnUnusedSettingsInvisible()
% Remove all piezo buttons and stuff only used on CEA or ENS1 setup (for now)

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');


if strcmp(AcqParameters.SetupType,"CEA") 
    ListUselessSettings = {};
elseif strcmp(AcqParameters.SetupType,"ENS1")
    ListUselessSettings = {shutterBetsa};    
else
    ListUselessSettings = {'calibPiezoPanelTitle','calibPiezoPanel','calibPiezoXText','calibPiezoX','calibPiezoYText',...
        'calibPiezoY','calibPiezoZText','calibPiezoZ','ResetPiezo','shutterlaser','autofocuspiezo','shutterBetsa',...
        'PiezoControlText','PiezoControlPanel','switchpiezo','piezoXString','piezoX','piezoYString','piezoY',...
        'piezoZString','piezoZ','piezoRangeXString','piezoRangeYString','piezoRangeZString',...
        'piezoRangeX','piezoRangeY','piezoRangeZ','piezoStepXString','piezoStepYString','piezoStepZString',...
        'piezoStepX','piezoStepY','piezoStepZ','light','piezoLightValue'};
end

TurnOffUselessSettings(ListUselessSettings);

end
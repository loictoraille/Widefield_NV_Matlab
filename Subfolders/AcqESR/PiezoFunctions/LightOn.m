function Tension4 = LightOn(panel)
% optionally return Tension4, the fourth tension value of the NI card, for ease of use in PerformAlignPiezo sequence

h = panel.light;
h_betsa = panel.shutterBetsa;

h.Value = 1;
h.ForegroundColor = [0,0,1];

if strcmp(panel.SetupType.String,"CEA") && isfield(panel,'UserData') && isfield(panel.UserData,'Betsa')
    h_betsa.ForegroundColor = [0,0,1];
    h_betsa.Value = 1;
%     Betsa = panel.UserData.Betsa;
%     writeline(Betsa, "RLY50"); % switches shutter toward light mode %% is turned on in Smart_PZ_Light_Laser_Write
end

Tension4 = Smart_PZ_Light_Laser_Write(panel);

end
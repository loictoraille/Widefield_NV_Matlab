function Tension4 = LightOn(panel)
% optionally return Tension4, the fourth tension value of the NI card, for ease of use in PerformAlignPiezo sequence

h=findobj('tag','light');
h_betsa=findobj('tag','shutterBetsa');

h.Value = 1;
h.ForegroundColor = [0,1,0];

if strcmp(panel.SetupType.String,"CEA") && isfield(panel,'UserData') && isfield(panel.UserData,'Betsa')
    Betsa = panel.UserData.Betsa;
    h_betsa.ForegroundColor = [0,1,0];
    h_betsa.Value = 1;
    writeline(Betsa, "RLY50"); % switches shutter toward light mode
end

Tension4 = Smart_PZ_Light_Laser_Write(panel);

end
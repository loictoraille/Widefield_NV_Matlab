function Tension4 = LightOff(panel)
% optionally return Tension4, the fourth tension value of the NI card, for ease of use in PerformAlignPiezo sequence
global SetupType

h=panel.light;
h_betsa = panel.shutterBetsa;

h.Value = 0;
h.ForegroundColor = [0,0,0];

if strcmpi(SetupType,"CEA") && isfield(panel,'UserData') && isfield(panel.UserData,'Betsa')
    h_betsa.ForegroundColor = [0,0,0];
    h_betsa.Value = 0;
%     Betsa = panel.UserData.Betsa;
%     writeline(Betsa, "RLY50"); % switches shutter toward light mode %% is turned on in Smart_PZ_Light_Laser_Write
end

Tension4 = Smart_PZ_Light_Laser_Write(panel);

end
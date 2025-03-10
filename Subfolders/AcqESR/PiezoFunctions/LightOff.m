function Tension4 = LightOff(panel)
% optionally return Tension4, the fourth tension value of the NI card, for ease of use in PerformAlignPiezo sequence

% h=findobj('tag','light');
h=panel.light;

h.Value = 0;
h.ForegroundColor = [0,0,0];

Tension4 = Smart_PZ_Light_Laser_Write(panel);

end
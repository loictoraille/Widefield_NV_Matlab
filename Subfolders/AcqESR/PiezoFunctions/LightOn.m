function Tension4 = LightOn(panel)
% optionally return Tension4, the fourth tension value of the NI card, for ease of use in PerformAlignPiezo sequence

h=findobj('tag','light');

h.Value = 1;
h.ForegroundColor = [0,1,0];

Tension4 = Smart_PZ_Light_Laser_Write(panel);

end
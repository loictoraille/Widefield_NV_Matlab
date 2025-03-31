function Tension4 = LaserOn(panel)
% optionally return Tension4, the fourth tension value of the NI card, for ease of use in PerformAlignPiezo sequence

h=findobj('tag','shutterlaser');

h.Value = 1;
h.ForegroundColor = [0,0,1];

Tension4 = Smart_PZ_Light_Laser_Write(panel);

end
function SwitchShutterLaser(~,~)

h=findobj('tag','shutterlaser');

if h.Value == 1
    h.ForegroundColor = [0,0,1];
else
    h.ForegroundColor = [0,0,0];
end

panel = guidata(gcbo);

Smart_PZ_Light_Laser_Write(panel);

end
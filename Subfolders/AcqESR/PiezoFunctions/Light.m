function Light(~,~)

h=findobj('tag','light');

if h.Value == 1
    h.ForegroundColor = [0,1,0];
else
    h.ForegroundColor = [0,0,0];
end

panel = guidata(gcbo);

Smart_PZ_Light_Laser_Write(panel);

end
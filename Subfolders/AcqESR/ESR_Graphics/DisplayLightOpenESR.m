function DisplayLightOpenESR(hobject,~)

DisplayLight = hobject.Value;
panel = guidata(gcbo);

AOIParameters = panel.UserData.AOIParameters;

if DisplayLight    
    PrintImage(panel.Axes1,panel.UserData.Lum_WithLightAndLaser,AOIParameters);
else
    PrintImage(panel.Axes1,panel.UserData.Lum_Current,AOIParameters);
end

PrintESR(panel,panel.UserData.M);

end
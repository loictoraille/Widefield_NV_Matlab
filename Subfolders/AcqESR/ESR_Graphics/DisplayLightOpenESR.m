function DisplayLightOpenESR(hobject,~)

DisplayLight = hobject.Value;
panel = guidata(gcbo);

AOIParameters = panel.UserData.AOIParameters;

if DisplayLight && isfield(panel,'UserData') && isfield(panel.UserData,'Lum_WithLightAndLaser') && ~isempty(panel.UserData.Lum_WithLightAndLaser) 
    PrintImage(panel.Axes1,panel.UserData.Lum_WithLightAndLaser,AOIParameters);
else
    hobject.Value = 0;
    PrintImage(panel.Axes1,panel.UserData.Lum_Current,AOIParameters);
end

PrintESR(panel,panel.UserData.M);

end
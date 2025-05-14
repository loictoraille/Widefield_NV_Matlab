function DisplayLightOpenESR(hobject,~)

DisplayLight = hobject.Value;
panel = guidata(gcbo);

AOIParameters = panel.UserData.AOIParameters;
MaxLum = str2double(panel.MaxLum.String);

if DisplayLight && isfield(panel,'UserData') && isfield(panel.UserData,'Lum_WithLightAndLaser') && ~isempty(panel.UserData.Lum_WithLightAndLaser) 
    PrintImage(panel.Axes1,panel.UserData.Lum_WithLightAndLaser,AOIParameters,MaxLum);
else
    hobject.Value = 0;
    PrintImage(panel.Axes1,panel.UserData.Lum_Current,AOIParameters,MaxLum);
end

PrintESR(panel,panel.UserData.M);

end
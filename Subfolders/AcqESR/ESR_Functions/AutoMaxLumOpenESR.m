function AutoMaxLumOpenESR(~,~)

panel = guidata(gcbo);

DisplayLight = panel.DisplayLight.Value;

if (isnan(DisplayLight) || DisplayLight == 0) && isfield(panel,'UserData') && isfield(panel.UserData,'Lum_Current') && ~isempty(panel.UserData.Lum_Current)
    LumToPlot = panel.UserData.Lum_Current;
end
if ~isnan(DisplayLight) && DisplayLight && isfield(panel,'UserData') && isfield(panel.UserData,'Lum_WithLightAndLaser') && ~isempty(panel.UserData.Lum_WithLightAndLaser)
    LumToPlot = panel.UserData.Lum_WithLightAndLaser;
end

if exist('LumToPlot','var')
    MaxLumVal = round(max(max(LumToPlot)));
    MaxLum = round(1.05*MaxLumVal);
    panel.MaxLum.String = num2str(MaxLum);

    AOIParameters = panel.UserData.AOIParameters;

    UpdateMaxLumFunc(panel,AOIParameters);

end



end
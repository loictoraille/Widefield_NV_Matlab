function UpdateMaxLumFunc(panel,AOIParameters)

DisplayLight = panel.DisplayLight.Value;
MaxLum = str2double(panel.MaxLum.String);

if (isnan(DisplayLight) || DisplayLight == 0) && isfield(panel,'UserData') && isfield(panel.UserData,'Lum_Current') && ~isempty(panel.UserData.Lum_Current)
    LumToPlot = panel.UserData.Lum_Current;
    PrintImage(panel.Axes1,LumToPlot,AOIParameters,MaxLum);    
end
if ~isnan(DisplayLight) && DisplayLight && isfield(panel,'UserData') && isfield(panel.UserData,'Lum_WithLightAndLaser') && ~isempty(panel.UserData.Lum_WithLightAndLaser)
    LumToPlot = panel.UserData.Lum_WithLightAndLaser;
    PrintImage(panel.Axes1,LumToPlot,AOIParameters,MaxLum);
end

% PixX = str2num(panel.PixX.String);    
% PixY = str2num(panel.PixY.String);  
% lum_value = round(LumToPlot(PixY,PixX));

% title(panel.Axes1,['(X,Y,I)=(',num2str(PixX),',',num2str(PixY),',',num2str(lum_value),')']);

% title(panel.Axes1,['Max pixel value = ' num2str(round(max(max(LumToPlot))))]);

end
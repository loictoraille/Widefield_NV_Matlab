function AutoMaxLum(~,~)

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
    panel.MaxLumLive.String = num2str(MaxLum);
    UpdateAcqParam();

    load([getPath('Param') 'AcqParameters.mat']);

    [~,sizelevel] = size(AcqParameters.AOI.Width);
    AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
    AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
    AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
    AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

    UpdateMaxLumFunc(panel,AOIParameters);

end



end
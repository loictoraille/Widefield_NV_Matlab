function UpdateMaxLum(~,~)

panel = guidata(gcbo);

MaxLum = str2double(panel.MaxLum.String);
if MaxLum <= 0
    MaxLum = 1;
    panel.MaxLum.String = num2str(MaxLum);
end

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
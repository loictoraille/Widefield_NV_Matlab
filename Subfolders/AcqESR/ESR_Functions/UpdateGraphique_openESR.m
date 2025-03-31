%% Update Graphique

f = gcf;
Total_handles=guihandles(f);
guidata(f,Total_handles);

panel = Total_handles;

panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;
panel.UserData.Lum_Current = Lum_Current;
panel.UserData.M = M;

ax = findobj('tag','Axes1');

ImageMatrix = Lum_Current;

if AcqParameters.DisplayLight
    ImageMatrix = Lum_WithLightAndLaser;
end

axes(ax);

[~,sizelevel] = size(AcqParameters.AOI.Width);

AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

panel.UserData.AOIParameters = AOIParameters;
              
if strcmp(AcqParameters.CalibUnit_str,'pixel')
   panel.calibunit.SelectedObject = panel.calib_pixel_r1;
else
   panel.calibunit.SelectedObject = panel.calib_nm_r2;
end

eval(['panel.NumPeaksChoice.SelectedObject = panel.NumPeaks' num2str(NumPeaks) ';' ]);

PrintImage(ax,ImageMatrix,AOIParameters);

if exist('T','var') && ~isempty(T)
    panel.Temp_txt.String = sprintf(['Ta=' num2str(roundn(mean(T(:,1)),-2)) '\nTb=' num2str(roundn(mean(T(:,2)),-2))]);
end

PixXStart = round(AOIParameters.AOI.Width/2);
PixYStart = round(AOIParameters.AOI.Height/2);

panel.PixX.String=num2str(PixXStart); 
panel.PixY.String=num2str(PixYStart);

sizeM = size(M);

if AcqParameters.RefMWOff == 1
    RefMWOffString  = 'Ref MW Off every sweep';
elseif AcqParameters.RefMWOff == 2
    RefMWOffString  = 'Ref MW Off every image';
else
    RefMWOffString  = 'No Ref MW Off';
end

panel.StrAcqTime.String = ['Acquisition time = ' num2str(AcquisitionTime_minutes) ' minutes'];
panel.StrRefMWOff.String = RefMWOffString;
panel.StrNumSweeps.String = ['Number of sweeps = ' num2str(Acc)];
panel.SizeOfM.String = ['Size of M : (w,h,v) = (' num2str(sizeM(2)) ',' num2str(sizeM(1)) ',' num2str(sizeM(3)) ')'];
panel.StrCamType.String = ['Camera ' CameraType];
panel.StrMWPower.String = ['MW Power = ' num2str(AcqParameters.MWPower) ' dBm'];
panel.StrExposureTime.String = ['Exposure Time = ' num2str(round(AcqParameters.ExposureTime,3)) ' ' AcqParameters.ExposureUnit];
panel.RefMWOff.String = num2str(AcqParameters.RefMWOff);

PrintESR(panel,M)

panel.DataPath.String = FitParameters.DataPath;
panel.TreatedDataPath.String = FitParameters.TreatedDataPath;

guidata(gcf,panel);


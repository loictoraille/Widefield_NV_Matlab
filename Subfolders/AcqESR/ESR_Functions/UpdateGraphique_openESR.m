%% Update Graphique

f = gcf;
Total_handles=guihandles(f);
guidata(f,Total_handles);

panel = Total_handles;

if exist('Lum_WithLightAndLaser','var')
    panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;
end
panel.UserData.Lum_Current = Lum_Current;
panel.UserData.M = M;

ax = findobj('tag','Axes1');

ImageMatrix = Lum_Current;

if panel.DisplayLightOpenESR.Value == 1 
    if exist('Lum_WithLightAndLaser','var')
        ImageMatrix = Lum_WithLightAndLaser;
    else
        panel.DisplayLightOpenESR.Value = 0;
    end
end

if AcqParameters.MaxLum
    panel.MaxLum.Value = 1;
else
    panel.MaxLum.Value = 0;
end

axes(ax);

% To open file with no AOI definition
% AcqParameters.AOILEVEL = 1;
% AcqParameters.AOI = {};
% AcqParameters.AOI.Width = 712;
% AcqParameters.AOI.Height = 712;

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

MaxLum = str2double(panel.MaxLum.String);
MaxLumAlwaysAuto = panel.MaxLumAlwaysAuto.Value;

MaxLum = PrintImage(ax,ImageMatrix,AOIParameters,MaxLum,MaxLumAlwaysAuto);

panel.MaxLum.String = num2str(MaxLum);

if exist('T','var') && ~isempty(T)
    panel.Temp_txt.String = CreateT_string(T);
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

if isfield(AcqParameters,'B_state') && strcmpi(AcqParameters.B_state,'ON')
    panel.BPanel.Visible = 'on';
    panel.BxCoilDisplay.String = sprintf('BxCoil = %.2f mT',AcqParameters.BxCoil);
    panel.ByCoilDisplay.String = sprintf('ByCoil = %.2f mT',AcqParameters.ByCoil);
    panel.BzCoilDisplay.String = sprintf('BzCoil = %.2f mT',AcqParameters.BzCoil);
    BTotCalc = sqrt(AcqParameters.BxCoil^2+AcqParameters.ByCoil^2+AcqParameters.BzCoil^2);
    panel.BtotCoilDisplay.String = sprintf('BtotCoil = %.2f mT',BTotCalc);
else
    panel.BPanel.Visible = 'off';
end

guidata(gcf,panel);


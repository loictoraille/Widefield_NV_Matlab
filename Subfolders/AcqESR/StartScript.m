
% separated from scan script for ease of reading

SwitchGEN('ON');

panel=guidata(gcbo);

panel = ToggleOffButtons(); % custom built function to turn off pix button and the like

load([getPath('Param') 'AcqParameters.mat']);
load([getPath('Param') 'FitParameters.mat']);
Data_Path = AcqParameters.Data_Path;

LoadParamFromAcqParamScript;

if AcqParameters.RepeatScan > 1 && i_scan ~= 1
    nomSave = GenNextFileName(nomSave); % so that the date change does not change the name
end

DelEx = AcqParameters.DelEx; % DelEx standalone uses the script, so we get it out

[~,sizelevel] = size(AcqParameters.AOI.Width);

panel.PixX.String = num2str(round(AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL))/2));
panel.PixY.String = num2str(round(AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL))/2));

AOIParameters.AOI.Height = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

if TestWithoutHardware == 1
    panel.PixX.String = 35;
    panel.PixY.String = 35;
end

if ALIGN 
    NPoints = 50;
end

if strcmp(CameraType,'Andor')
    maxLum = 65535;
else
    maxLum = 4095;
end


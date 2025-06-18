
% separated from scan script for ease of reading

LoadParamFromAcqParamScript;

SwitchGEN('ON',MWPower);

panel=guidata(gcbo);

panel = ToggleOffButtons(); % custom built function to turn off pix button and the like

load([getPath('Param') 'AcqParameters.mat']);
load([getPath('Param') 'FitParameters.mat']);
Data_Path = AcqParameters.Data_Path;


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
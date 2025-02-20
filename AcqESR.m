
%% TURN ANDOR CAMERA ON BEFORE EXECUTING

close all ; clear global ; clearvars
addpath(genpath('Subfolders'));addpath(genpath(getPath('Main')));

%% Parameters  --  Copy-paste your Param folder in ESR Programs\Subfolders\Param
global TestWithoutHardware CameraType ObjCamera smb RF_Address 

[TestWithoutHardware, RF_Address, Data_Path, CameraChoice] = readConfigFile('Config.txt');

CheckAndUpdateAcqParameters('','default');

%% Comments on Camera Andor

% Frame Rate and Pixel Clock settings are useless for Andor Camera, they have been turned invisible

%% Opening Graphique and connection to camera

SaveAcqParameters({{Data_Path,'Data_Path'}});

f = figure2('Name','ESR Acquisition','CloseRequestFcn',@CloseReq);%create figure handle
if isprop(f,'WindowState')
    f.WindowState = 'maximized';
end

tgroup = uitabgroup(f);
tab1 = uitab(tgroup,'Title','ESR');
tab2 = hguitab(tgroup,'Title','Camera');
tab_fitparam = hguitab(tgroup,'Title','Fit Parameters');
tab_additional = hguitab(tgroup,'Title','Additional Parameters');
tgroup.SelectedTab = tab2;

Tab1;
Tab2;
Tab_FitParam;
Tab_Additional;

InitCameraAtStart(CameraChoice);

if ~isempty(ObjCamera)

tagcamtype=findobj('tag','cameratype');
tagcamtype.String = ['Camera ' CameraType];

Total_handles=guihandles(f);
guidata(f,Total_handles);

panel = Total_handles;
eval(['panel.NumPeaksChoice.SelectedObject = panel.NumPeaks' num2str(FitParameters.NumPeaks) ';' ]);

UpdateFileInfo({{Data_Path,'Data_Path'}});

FuncCameraRanges(Total_handles);

FuncAcqContinue(Total_handles);

end






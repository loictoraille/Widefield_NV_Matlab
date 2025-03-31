
%% TURN ANDOR CAMERA ON BEFORE EXECUTING

close all ; clear global ; clearvars
addpath(genpath('Subfolders'));addpath(genpath(getPath('Main')));

%% Parameters  --  Copy-paste your Param folder in ESR Programs\Subfolders\Param
global TestWithoutHardware CameraType ObjCamera smb RF_Address 

[TestWithoutHardware, RF_Address, Data_Path, CameraChoice] = readConfigFile('Config.txt');

CheckAndUpdateAcqParameters('','default');CheckAndUpdateFitParameters('','default');

%% Comments on Camera Andor

% Frame Rate and Pixel Clock settings are useless for Andor Camera, they have been turned invisible

%% Opening Graphique and connection to camera

SaveAcqParameters({{Data_Path,'Data_Path'}});

f = figure2('Name','ESR Acquisition','CloseRequestFcn',@CloseReq);%create figure handle
if isprop(f,'WindowState')
    f.WindowState = 'maximized';
end

tgroup = uitabgroup(f);
tab1 = uitab(tgroup,'Title','ESR - Main Acquisition Tab');
tab2 = hguitab(tgroup,'Title','Camera - Vizualisation');
tab_fitparam = hguitab(tgroup,'Title','Fit Parameters');
tab_additional = hguitab(tgroup,'Title','Additional Parameters');
tab_readtemp = hguitab(tgroup,'Title','Continuous temperature reading');
tab_alignpiezo = hguitab(tgroup,'Title','Check Piezo Auto-Alignment');
tgroup.SelectedTab = tab2;

Tab1;
Tab2;
Tab_FitParam;
Tab_Additional;
Tab_ReadTemp;
Tab_AlignPiezo;
TurnUnusedSettingsInvisible();

if TestWithoutHardware

    Total_handles=guihandles(gcf);
    guidata(f,Total_handles);

else

    Total_handles=guihandles(gcf);
%     guidata(f,Total_handles);

    InitCOMPorts(Total_handles);
    Total_handles=guidata(gcf);

    % To start ContinuousTempReading by default when lauching software
%     if isfield(Total_handles, 'UserData') && ~isempty(Total_handles.UserData) && ~isempty(Total_handles.UserData.Lakeshore)
%         btnStart = findobj('tag', 'startCTR');
%         StartContinuousTempReading(btnStart, []);
%     end

    InitPiezo(Total_handles);

    InitCameraAtStart(CameraChoice);

    if ~isempty(ObjCamera)

        tagcamtype=findobj('tag','cameratype');
        tagcamtype.String = ['Camera ' CameraType];

        panel = Total_handles;
        eval(['panel.NumPeaksChoice.SelectedObject = panel.NumPeaks' num2str(FitParameters.NumPeaks) ';' ]);

        UpdateFileInfo({{Data_Path,'Data_Path'}});

        FuncCameraRanges(Total_handles);

        FuncAcqContinue(Total_handles);

    end

end




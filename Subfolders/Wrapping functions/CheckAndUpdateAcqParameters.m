function CheckAndUpdateAcqParameters(File,String_Default_Value)

% Function to load AcqParameters and update it to the current list of parameters, adding default when a parameter is absent
% The goal is that the user only needs to copy paste their parameter file and keep their configuration this way

% loads the AcqParameters stored in the file if possible, else loads the external one
if isempty(File) || (~isempty(File) && ~ismember('AcqParameters', who('-file',File)))
    load([getPath('Param') 'AcqParameters.mat']);    
else
    load(File,'AcqParameters'); 
end

% Get the full path to the grandparent folder
[parentPath, ~, ~] = fileparts(getPath('Main'));
[grandparentPath, ~, ~] = fileparts(parentPath);

% Default AOI
AOI.X = 1;AOI.Y = 1;AOI.Width = 1280;AOI.Height = 1024;

% Default MagneticScan (Scan Theta / Scan Phi parameters)
MagneticScan.ScanTheta_Enable = 1;
MagneticScan.ScanTheta_AngleStart = 0;
MagneticScan.ScanTheta_AngleStop = 180;
MagneticScan.ScanTheta_AngleStep = 3;
MagneticScan.ScanTheta_PhiValue = 120;
MagneticScan.ScanTheta_MagneticFieldValue = 8;
MagneticScan.ScanPhi_Enable = 1;
MagneticScan.ScanPhi_AngleStart = 0;
MagneticScan.ScanPhi_AngleStop = 360;
MagneticScan.ScanPhi_AngleStep = 6;
MagneticScan.ScanPhi_ThetaValue = 60;
MagneticScan.ScanPhi_MagneticFieldValue = 8;

fieldNames = {'Data_Path','Save','RandomFreq','RefMWOff','AutoAlignCrop','AutoAlignCam',...
    'RefreshMode','ReadTemp','FinishSweep','FinishScan','MWPower','NumPoints','NumSweeps','FCenter',...
    'FSpan','BackupNSweeps','RepeatScan','nomSave','ExposureTime','ExposureUnit','AOI','FrameRate','PixelClock',...
    'CalibUnit_str','PixelCalib_nm','AOILEVEL','DelEx','RFAlwaysON','AutoAlignPiezo',...
    'PiezoX','PiezoY','PiezoZ','PiezoRangeX','PiezoRangeY','PiezoRangeZ','PiezoStepX','PiezoStepY','PiezoStepZ',...
    'PiezoLight','CalibPiezoX','CalibPiezoY','CalibPiezoZ','ROISquareSize',...
    'SaveMode','COM_Lakeshore','COM_Betsa','ResetPiezo','AF','AF_NumberSweeps','AF_Scan','AF_NumberScan',...
    'AF_Method','LaserShutter','LaserShutterPort',...
    'TR_Period_Minute','DisplayLight','MaxLum','MaxLumAlwaysAuto','SensorTempA','SensorTempA_Name','SensorTempB','SensorTempB_Name',...
    'SensorTempC','SensorTempC_Name','SensorTempD','SensorTempD_Name',...
    'FileNamePrefix','FileNamePrefixChoice','FileNameUserPrefix',...
    'BxCoil','ByCoil','BzCoil','XcoilCalib','YcoilCalib','ZcoilCalib','B_state','Bname_User1','Bname_User2',...
    'MagSweep','BSweepMin','BSweepMax','BuildName','PrintName','CreationTime','SetupType',...
    'MagneticScan'};

defaultValues = {grandparentPath,0,0,0,0,1,...
                0,0,1,0,20,200,20,2.87,...
                200,5,1,'backup',0.1,'ms',AOI,20,40,...
                'pixel',463,1,1,0,0,...
                8,3,6,0.2,0.2,0.5,5,5,11,...
                0.027,294,206,300,200,...
                'slow&compressed',"3","20",1,0,3,0,1,...
                'DCTR',1,'1.3',...
                1,0,4096,0,1,'Diode',1,'Thermocouple',...
                0,'Diode',0,'Thermocouple',...
                'PlaceHolder','Date+Base','Data_Acq',...
                1,2,3,1.527,1.104,1.504,'OFF','User1','User2',...
                0,0,10,'backup','backup','undefined','BASE',...
                MagneticScan};

% --- Migrate fields that exist under a different case ---
currentFields = fieldnames(AcqParameters);
for i = 1:length(currentFields)
    oldName = currentFields{i};
    if ismember(oldName, fieldNames)
        continue % Exact match, no action needed
    end
    idx = find(strcmpi(oldName, fieldNames), 1);
    if ~isempty(idx)
        correctName = fieldNames{idx};
        AcqParameters.(correctName) = AcqParameters.(oldName);
        AcqParameters = rmfield(AcqParameters, oldName);
        fprintf('Migrated field ''%s'' -> ''%s''\n', oldName, correctName);
    end
end

% --- Remove obsolete fields no longer in the current fieldNames list ---
currentFields = fieldnames(AcqParameters);
obsoleteFields = currentFields(~ismember(currentFields, fieldNames));
if ~isempty(obsoleteFields)
    AcqParameters = rmfield(AcqParameters, obsoleteFields);
    fprintf('Removed %d obsolete field(s) from AcqParameters: %s\n', ...
        numel(obsoleteFields), strjoin(obsoleteFields, ', '));
end

% Loop through each field name
for i = 1:length(fieldNames)
    fieldName = fieldNames{i};
    if strcmp(String_Default_Value,'default')
        defaultValue = defaultValues{i};
    else
        defaultValue = NaN;
    end
    
    % Check if the field exists in the structure
    if ~isfield(AcqParameters, fieldName)
        % If the field does not exist, create it and assign the default value
        AcqParameters.(fieldName) = defaultValue;
    end
end

if isempty(File)
    save([getPath('Param') 'AcqParameters.mat'],'AcqParameters');    
else
    save(File,'AcqParameters','-append')
end

end
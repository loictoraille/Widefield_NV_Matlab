function CheckAndUpdateAcqParameters(File,String_Default_Value)

% Function to load AcqParameters and update it to the current list of parameters, adding default when a parameter is absent
% The goal is that the user only needs to copy paste their parameter file and keep their configuration this way

if isempty(File)
    load([getPath('Param') 'AcqParameters.mat']);    
else
    load(File,'AcqParameters')
end

% Get the full path to the grandparent folder
[parentPath, ~, ~] = fileparts(getPath('Main'));
[grandparentPath, ~, ~] = fileparts(parentPath);

% Default AOI
AOI.X = 1;AOI.Y = 1;AOI.Width = 1280;AOI.Height = 1024;

fieldNames = {'Data_Path','Save','RandomFreq','RefMWOff','AutoAlignCrop','AutoAlignCam',...
    'RefreshMode','ReadTemp','FinishSweep','MWPower','NumPoints','NumSweeps','FCenter',...
    'FSpan','BackupNSweeps','RepeatScan','nomSave','ExposureTime','ExposureUnit','AOI','FrameRate','PixelClock',...
    'CalibUnit_str','PixelCalib_nm','AOILEVEL','DelEx','RFAlwaysON','AutoAlignPiezo',...
    'PiezoX','PiezoY','PiezoZ','PiezoRange','PiezoSteps','PiezoLight','CalibPiezoX','CalibPiezoY','CalibPiezoZ','ROISquareSize',...
    'SaveMode','COM_Lakeshore','COM_Betsa','ResetPiezo','SetupType','AF','AF_NumberSweeps',...
    'TR_Period_Minute'};

defaultValues = {grandparentPath,0,0,0,0,1,0,0,1,20,200,20,2.87,200,5,1,'backup',0.1,'ms',AOI,20,40,'pixel',...
        463,1,1,0,0,8,3,6,0.2,5,0.027,294,206,300,200,'slow&compressed',"3","20",1,'ENS2',0,3,1};

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
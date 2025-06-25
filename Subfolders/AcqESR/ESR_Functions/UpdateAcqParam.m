function UpdateAcqParam(hobject,~)

if exist("hobject",'var') && isfield(hobject,'Save')
    panel = hobject;
else
    panel=guidata(gcbo);
end

load([getPath('Param') 'AcqParameters.mat']);

Data_Path = AcqParameters.Data_Path;

%%

Save = panel.Save.Value;
RandomFreq = panel.RandomFreq.Value;
AutoAlignCrop = panel.AutoAlignCrop.Value;
AutoAlignCam = panel.AutoAlignCam.Value;
AutoAlignPiezo = panel.AutoAlignPiezo.Value;
RefreshMode = panel.RefreshMode.Value;
ReadTemp = panel.ReadTemp.Value;
FinishSweep = panel.FinishSweep.Value;
DelEx = panel.DelEx.Value;
RFAlwaysON = panel.RFAlwaysON.Value;
RefMWOff = str2double(panel.RefMWOff.String);

MWPower = str2double(panel.MWPower.String);
NumPoints = str2double(panel.NumPoints.String);
NumSweeps = str2double(panel.NumSweeps.String);
FCenter = str2double(panel.FCenter.String);
FSpan = str2double(panel.FSpan.String);
BackupNSweeps = str2double(panel.BackupNSweeps.String);
CalibUnit_str = panel.calibunit.SelectedObject.String;
PixelCalib_nm = str2double(panel.pixelcalibvalue.String);
ROISquareSize = str2double(panel.roisquaresize.String);
RepeatScan = str2double(panel.RepeatScan.String);

PiezoX = str2double(panel.piezoX.String);
PiezoY = str2double(panel.piezoY.String);
PiezoZ = str2double(panel.piezoZ.String);
PiezoRangeX = str2double(panel.piezoRangeX.String);
PiezoRangeY = str2double(panel.piezoRangeY.String);
PiezoRangeZ = str2double(panel.piezoRangeZ.String);
PiezoStepX = str2double(panel.piezoStepX.String);
PiezoStepY = str2double(panel.piezoStepY.String);
PiezoStepZ = str2double(panel.piezoStepZ.String);
PiezoLight = str2double(panel.piezoLightValue.String);
CalibPiezoX = str2double(panel.calibPiezoX.String);
CalibPiezoY = str2double(panel.calibPiezoY.String);
CalibPiezoZ = str2double(panel.calibPiezoZ.String);

SaveMode = panel.SaveModeChoice.SelectedObject.String;

FileNamePrefix = panel.FileNamePrefix.String;
FileNamePrefixChoice = panel.FileNamePrefixChoice.SelectedObject.String;
FileNameUserPrefix = panel.FileNameUserPrefix.String;

%%
nomSave = NameGen(Data_Path,FileNamePrefix,Save);
panel.nameFile.String = ['File: ' nomSave];
%%

if panel.start.Value ~=1 % do not update is scan is running
    panel.numberSweep.String = ['Sweep number /' num2str(NumSweeps)];
    panel.numberFreq.String = ['Freq number /' num2str(NumPoints)];
end

COM_Lakeshore = panel.comLakeshore.String;
COM_Betsa = panel.comBetsa.String;

ResetPiezo = panel.ResetPiezo.Value;

AF = panel.AF.Value;
AF_NumberSweeps = str2double(panel.AF_NumberSweeps.String);
AF_Method = panel.AF_Method.String;

TR_Period_Minute = str2double(panel.tr_periodminute.String);

DisplayLight = panel.DisplayLight.Value;
MaxLum = str2double(panel.MaxLum.String);

SensorTempA = panel.SensorA.Value;
SensorTempB = panel.SensorB.Value;
SensorTempA_Name = panel.SensorA_Name.String;
SensorTempB_Name = panel.SensorB_Name.String;

%%

SaveAcqParameters({{Data_Path,'Data_Path'},{Save,'Save'},{RandomFreq,'RandomFreq'},{RefMWOff,'RefMWOff'},{AutoAlignCrop,'AutoAlignCrop'},...
    {AutoAlignCam,'AutoAlignCam'},{AutoAlignPiezo,'AutoAlignPiezo'},{RefreshMode,'RefreshMode'},{ReadTemp,'ReadTemp'},{FinishSweep,'FinishSweep'},...
    {MWPower,'MWPower'},{NumPoints,'NumPoints'},{NumSweeps,'NumSweeps'},{FCenter,'FCenter'},{DelEx,'DelEx'},{RFAlwaysON,'RFAlwaysON'},...
    {FSpan,'FSpan'},{BackupNSweeps,'BackupNSweeps'},{RepeatScan,'RepeatScan'},{nomSave,'nomSave'},{CalibUnit_str,'CalibUnit_str'},...
    {PixelCalib_nm,'PixelCalib_nm'},{ROISquareSize,'ROISquareSize'},...
    {PiezoX,'PiezoX'},{PiezoY,'PiezoY'},{PiezoZ,'PiezoZ'},{PiezoRangeX,'PiezoRangeX'},{PiezoRangeY,'PiezoRangeY'},{PiezoRangeZ,'PiezoRangeZ'},...
    {PiezoStepX,'PiezoStepX'},{PiezoStepY,'PiezoStepY'},{PiezoStepZ,'PiezoStepZ'},...
    {PiezoLight,'PiezoLight'},{CalibPiezoX,'CalibPiezoX'},{CalibPiezoY,'CalibPiezoY'},{CalibPiezoZ,'CalibPiezoZ'},...
    {SaveMode,'SaveMode'},{COM_Lakeshore,'COM_Lakeshore'},{COM_Betsa,'COM_Betsa'},{ResetPiezo,'ResetPiezo'},...
    {AF,'AF'},{AF_NumberSweeps,'AF_NumberSweeps'},{AF_Method,'AF_Method'},{TR_Period_Minute,'TR_Period_Minute'},{DisplayLight,'DisplayLight'},...
    {MaxLum,'MaxLum'},...
    {SensorTempA,'SensorTempA'},{SensorTempB,'SensorTempB'},{SensorTempA_Name,'SensorTempA_Name'},{SensorTempB_Name,'SensorTempB_Name'},...
    {FileNamePrefix,'FileNamePrefix'},{FileNamePrefixChoice,'FileNamePrefixChoice'},{FileNameUserPrefix,'FileNameUserPrefix'}});

end
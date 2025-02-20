function UpdateAcqParam(~,~)

panel=guidata(gcbo);

load([getPath('Param') 'AcqParameters.mat']);

Data_Path = AcqParameters.Data_Path;

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
RepeatScan = min(200,str2double(panel.RepeatScan.String));
panel.RepeatScan.String = num2str(RepeatScan);

PiezoX = str2double(panel.piezoX.String);
PiezoY = str2double(panel.piezoY.String);
PiezoZ = str2double(panel.piezoZ.String);
PiezoRange = str2double(panel.piezoRange.String);
PiezoSteps = str2double(panel.piezoSteps.String);
PiezoLight = str2double(panel.piezoLightValue.String);
CalibPiezoX = str2double(panel.calibPiezoX.String);
CalibPiezoY = str2double(panel.calibPiezoY.String);
CalibPiezoZ = str2double(panel.calibPiezoZ.String);

SaveMode = panel.SaveModeChoice.SelectedObject.String;

nomSave = NameGen(Data_Path,'ESR_WideField',Save);

panel.nameFile.String = ['File: ' nomSave];
panel.numberSweep.String = ['Sweep number /' num2str(NumSweeps)];
panel.numberFreq.String = ['Freq number /' num2str(NumPoints)];

SaveAcqParameters({{Data_Path,'Data_Path'},{Save,'Save'},{RandomFreq,'RandomFreq'},{RefMWOff,'RefMWOff'},{AutoAlignCrop,'AutoAlignCrop'},...
    {AutoAlignCam,'AutoAlignCam'},{AutoAlignPiezo,'AutoAlignPiezo'},{RefreshMode,'RefreshMode'},{ReadTemp,'ReadTemp'},{FinishSweep,'FinishSweep'},...
    {MWPower,'MWPower'},{NumPoints,'NumPoints'},{NumSweeps,'NumSweeps'},{FCenter,'FCenter'},{DelEx,'DelEx'},{RFAlwaysON,'RFAlwaysON'},...
    {FSpan,'FSpan'},{BackupNSweeps,'BackupNSweeps'},{RepeatScan,'RepeatScan'},{nomSave,'nomSave'},{CalibUnit_str,'CalibUnit_str'},...
    {PixelCalib_nm,'PixelCalib_nm'},{ROISquareSize,'ROISquareSize'},...
    {PiezoX,'PiezoX'},{PiezoY,'PiezoY'},{PiezoZ,'PiezoZ'},{PiezoRange,'PiezoRange'},{PiezoSteps,'PiezoSteps'},...
    {PiezoLight,'PiezoLight'},{CalibPiezoX,'CalibPiezoX'},{CalibPiezoY,'CalibPiezoY'},{CalibPiezoZ,'CalibPiezoZ'},...
    {SaveMode,'SaveMode'}});

end
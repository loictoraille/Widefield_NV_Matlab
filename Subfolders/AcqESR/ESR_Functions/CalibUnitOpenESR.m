function CalibUnitOpenESR(~,~)
global M 

panel = guidata(gcbo);

CalibUnit_str = panel.calibunit.SelectedObject.String;
PixelCalib_nm = str2double(panel.pixelcalibvalue.String);

CropOrUpdateImage();

end
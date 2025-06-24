function [Lum_Initial,Lum_Initial_LaserOff] = StartFunction(i_scan, Lum_Initial, Lum_Initial_LaserOff, nomSave, time_one_scan)
global M ObjCamera CameraType handleImage MW_Gen TestWithoutHardware RF_Address Lum_Current

StartScript; 

ScanScript;

end
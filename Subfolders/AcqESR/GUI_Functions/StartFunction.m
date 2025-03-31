function [Lum_Initial,Lum_Initial_LaserOff] = StartFunction(i_scan, Lum_Initial, Lum_Initial_LaserOff, nomSave)
global M ObjCamera CameraType handleImage smb TestWithoutHardware RF_Address Lum_Current

StartScript; 

ScanScript;

end
global ObjCamera
NET.addAssembly('C:\Program Files\IDS\uEye\Develop\DotNet\signed\uEyeDotNet.dll')
ObjCamera=uEye.Camera();
[~,CamID]=ObjCamera.Device.GetCameraID;
ObjCamera.Init(CamID);

% ObjCamera.Display.Mode.Set(uEye.Defines.DisplayMode.DiB);
% ObjCamera.Size.AOI.Set(ROIX,ROIY,ROIWidth,ROIHeight)
% ObjCamera.Timing.Exposure.Set(CamExposure);
% ObjCamera.Timing.Framerate.Set(CamFrameRate);
% ObjCamera.Timing.PixelClock.Set(CamPixelClock);
% CCDPixWidth=ROIWidth;%1280;
% CCDPixHeight=ROIHeight;%1024;
% ObjCamera.PixelFormat.Set(uEye.Defines.ColorMode.SensorRaw8);
% ObjCamera.Gain.Hardware.Scaled.SetMaster(GainScaled)

ObjCamera.Parameter.Load('ESR_IniParameters/Parameter.ini')%File saved from Camera Software (with ROI, PixelClock,...)
ObjCamera.Timing.PixelClock.Set(7);
ObjCamera.Timing.Framerate.Set(2);
[~,BitsPerPix]=ObjCamera.PixelFormat.GetBitsPerPixel();
[~,AOI]=ObjCamera.Size.AOI.Get;
ROIWidth=AOI.Width;
ROIHeight=AOI.Height;
[e,I]=ObjCamera.Memory.Allocate(ROIWidth,ROIHeight,BitsPerPix);
ObjCamera.Memory.SetActive(I);
ObjCamera.Trigger.Set(uEye.Defines.TriggerMode.Software);


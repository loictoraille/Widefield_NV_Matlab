
function LoadCameraParam()
global ObjCamera CameraType

Full_uEye_Load = 0;

if strcmp(CameraType,'uEye') && Full_uEye_Load == 1 %% DEPRECATED: takes 5 full seconds to load,
% better to use the same load as the other cameras
    % Different because the loading function automatically loads everything for the uEye
    ObjCamera.Parameter.Load([getPath('Param') 'ESR_uEyeIniParameters/Parameter.ini'])%File saved from Camera Software (with ROI, PixelClock,...)
   
    AOI = GetAOI();
    
    load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
    
    AcqParameters.AOILEVEL = AcqParameters.AOILEVEL +1;
    
    AcqParameters.AOI.Width(AcqParameters.AOILEVEL) = AOI.Width;
    AcqParameters.AOI.Height(AcqParameters.AOILEVEL) = AOI.Height;
    AcqParameters.AOI.X(AcqParameters.AOILEVEL) = AOI.X;
    AcqParameters.AOI.Y(AcqParameters.AOILEVEL) = AOI.Y;
    
    save([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
    
else    
    load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
    
    ExposureTime = AcqParameters.ExposureTime;
    AOI = AcqParameters.AOI;
    FrameRate = AcqParameters.FrameRate;
    PixelClock = AcqParameters.PixelClock;
    
    AOI = CheckAOI(AOI);
    SetAOI(AOI.X,AOI.Y,AOI.Width,AOI.Height);
    FrameRate = CheckFrameRate(FrameRate);
    SetFrameRate(floor(FrameRate*1000-1)/1000);
    SetPixelClock(PixelClock);
    SetExp(ExposureTime);
end


end

function SaveCameraParam()
global ObjCamera CameraType

% load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');

% AOI = AcqParameters.AOI();

[ExposureTime,ExposureUnit] = GetExp();
FrameRate = GetFrameRate();
PixelClock = GetPixelClock();

% DEPRECATED: takes 5 full seconds to load,
% better to use the same load as the other cameras
% if strcmp(CameraType,'uEye') 
%     ObjCamera.Parameter.Save([getPath('Param') 'ESR_uEyeIniParameters/Parameter.ini']);%File saved from Camera Software (with ROI, PixelClock,...)
% end

% SaveAcqParameters({{ExposureTime,'ExposureTime'},{FrameRate,'FrameRate'},{PixelClock,'PixelClock'},{AOI,'AOI'}});

SaveAcqParameters({{ExposureTime,'ExposureTime'},{ExposureUnit,'ExposureUnit'},{FrameRate,'FrameRate'},{PixelClock,'PixelClock'}});

end
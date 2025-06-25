
function ImageSize = GetBitsPerPixel()
% I'm not sure it's essential for every camera, but it's all over the code, so it's simpler to add a new camera here
% just in case

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc,ImageSize] = AT_GetInt(ObjCamera,'ImageSizeBytes');
    AT_CheckWarning(rc);

elseif strcmp(CameraType,'uEye') 
    [~,ImageSize]=ObjCamera.PixelFormat.GetBitsPerPixel();

elseif strcmp(CameraType,'Peak')
    VideoFormat = ObjCamera.VideoFormat;
    if contains(VideoFormat,'8')
        ImageSize = 8;
    elseif contains(VideoFormat,'10')
        ImageSize = 10;
    else
        ImageSize = 12;
    end

elseif strcmpi(CameraType,'Thorlabs')
    % check
    ImageSize = ObjCamera.BitDepth; % for now

elseif strcmp(CameraType,'heliCam') %TODO to adapt
	disp("warning (dev): GetsBitsPerPixel not set")
	ImageSize = 16;


end


end

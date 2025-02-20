
function ImageSize = GetBitsPerPixel()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc,ImageSize] = AT_GetInt(ObjCamera,'ImageSizeBytes');
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye') 
    [~,ImageSize]=ObjCamera.PixelFormat.GetBitsPerPixel();
elseif strcmp(CameraType,'Peak')
    Format = ObjCamera.VideoFormat;
    if strcmp(Format,'Mono12')
        ImageSize = 12; % need to be checked
    end
end


end

function PixelEncoding = GetPixelEncoding()
global ObjCamera CameraType

if strcmp(CameraType,'Andor')
    
    [rc,pixelIndex] = AT_GetEnumIndex(ObjCamera,'PixelEncoding');
    AT_CheckWarning(rc);

    [rc,pixelStatus] = AT_GetEnumStringByIndex(ObjCamera,'PixelEncoding',pixelIndex,256);
    AT_CheckWarning(rc);

%     disp(pixelStatus);

    if contains(pixelStatus,'32')
        PixelEncoding = 32;
    elseif contains(pixelStatus,'16')
        PixelEncoding = 16;
    else
        PixelEncoding = 12;
    end

elseif strcmp(CameraType,'uEye')
    
    [~,PixelEncoding]=ObjCamera.PixelFormat.GetBitsPerPixel();
    
elseif strcmp(CameraType,'Peak')    
    VideoFormat = ObjCamera.VideoFormat;
    if contains(VideoFormat,'8')
        PixelEncoding = 8;
    elseif contains(VideoFormat,'10')
        PixelEncoding = 10;
    else
        PixelEncoding = 12;
    end

elseif strcmp(CameraType,'heliCam')    
	%VideoFormat = ObjCamera.VideoFormat;
    %if contains(VideoFormat,'8')
    %    PixelEncoding = 8;
    %elseif contains(VideoFormat,'10')
    %    PixelEncoding = 10;
    %else
    %    PixelEncoding = 12;
    %end

	%Good enough for now
	disp("warning (dev) : pixel encoding to set for the helicam");
    PixelEncoding = 16; % TODO: to get from the camera the encoding 


end


end

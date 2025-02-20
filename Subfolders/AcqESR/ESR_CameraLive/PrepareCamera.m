
function [ImageZero,ImageSize,AOI] = PrepareCamera()
global ObjCamera CameraType

% Make sure to end previous running acquisition
EndAcqCamera();

%Obtain memory allocation according to ROI size
ImageSize = GetBitsPerPixel();% careful, the definition is different depending on the camera (bytes per image or bytes per pixel)
AOI = GetAOI();
ImageZero = zeros(AOI.Width,AOI.Height);

if strcmp(CameraType,'Andor') 
    [rc] = AT_Command(ObjCamera,'AcquisitionStart');
    AT_CheckWarning(rc);    
    [rc] = AT_QueueBuffer(ObjCamera,ImageSize);
    AT_CheckWarning(rc);
    [rc] = AT_Command(ObjCamera,'SoftwareTrigger');
    AT_CheckWarning(rc);
    % First image to prevent bug from wait buffer
elseif strcmp(CameraType,'Peak') 
    start(ObjCamera);
    % essential so that the getsnapshot function does not initialize every time
else    
    % uEye has no equivalent function it seems, or would need to try out
    % with a trigger as well
end


end



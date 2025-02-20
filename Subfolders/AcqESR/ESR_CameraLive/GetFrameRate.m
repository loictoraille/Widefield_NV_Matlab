
function Fra = GetFrameRate()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc, Fra] = AT_GetFloat(ObjCamera,'FrameRate');
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye')
    [~,Fra]=ObjCamera.Timing.Framerate.Get();%Query current values  
elseif strcmp(CameraType,'Peak')
    src_mycam = get(ObjCamera, 'Source');
    Fra = src_mycam.AcquisitionFrameRate;
end    


end
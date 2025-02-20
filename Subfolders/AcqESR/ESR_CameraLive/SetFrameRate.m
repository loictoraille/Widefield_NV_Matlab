
function SetFrameRate(FrameRateIn)
global ObjCamera CameraType

if strcmp(CameraType,'Andor')
    [rc] = AT_SetFloat(ObjCamera,'FrameRate',FrameRateIn);
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye')
    ObjCamera.Timing.Framerate.Set(FrameRateIn);
elseif strcmp(CameraType,'Peak')
    src_mycam = get(ObjCamera, 'Source');
    set(src_mycam, 'AcquisitionFrameRate', FrameRateIn);
else

end

end
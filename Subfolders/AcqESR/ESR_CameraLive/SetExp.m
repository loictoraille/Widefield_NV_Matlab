
function SetExp(ExpIn)

global ObjCamera CameraType

if strcmp(CameraType,'Andor')
    [rc] = AT_SetFloat(ObjCamera,'ExposureTime', ExpIn/1000); % Andor in s
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye')
    ObjCamera.Timing.Exposure.Set(ExpIn); % uEye in ms
elseif strcmp(CameraType,'Peak')
    src_mycam = get(ObjCamera, 'Source');    
    set(src_mycam, 'ExposureTime', 1000*ExpIn); % Peak in µs
else
end

end
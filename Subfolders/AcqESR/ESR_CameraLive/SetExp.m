
function SetExp(ExpIn)

global ObjCamera CameraType

if strcmp(CameraType,'Andor')
    [rc] = AT_SetFloat(ObjCamera,'ExposureTime', ExpIn/1000); % Andor in s
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye')
    ObjCamera.Timing.Exposure.Set(ExpIn); % uEye in ms
elseif strcmp(CameraType,'Peak')
    src_mycam = get(ObjCamera, 'Source');    
    set(src_mycam, 'ExposureTime', 1000*ExpIn); % Peak in us
elseif strcmpi(CameraType,'Thorlabs')
    ObjCamera.ExposureTime_us = 1000*ExpIn; % Thorlabs in us
elseif strcmp(CameraType,'heliCam')
	%writing the value to later make a call to charge new parameters altogether
	% in the camera
	ObjCamera.sensitivity = ExpIn/100;
	% TODO: Do we make a call right on fast parameters away ?
else
end

end

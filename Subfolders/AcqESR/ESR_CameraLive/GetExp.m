
function [Exp,Exp_unit] = GetExp()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc, Exp] = AT_GetFloat(ObjCamera,'ExposureTime');
    AT_CheckWarning(rc);
    Exp = Exp*1000;% to correct for Andor which is in s
    Exp_unit = 'ms';
elseif strcmp(CameraType,'uEye')
    [~,Exp]=ObjCamera.Timing.Exposure.Get();%Query current values
    Exp = Exp; % uEye is in ms
    Exp_unit = 'ms';
elseif strcmp(CameraType,'Peak')
    src_mycam = get(ObjCamera, 'Source');
    Exp = src_mycam.ExposureTime/1000; % to correct for Peak which is in µs
    Exp_unit = 'ms';
end


end
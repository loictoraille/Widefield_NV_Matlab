
function [Exp,Exp_unit] = GetExp()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc, Exp] = AT_GetFloat(ObjCamera,'ExposureTime');
    AT_CheckWarning(rc);
    Exp = Exp*1000;% to correct for Andor which is in s
    Exp_unit = 'ms';
elseif strcmp(CameraType,'uEye')
    [~,Exp]=ObjCamera.Timing.Exposure.Get(); %Query current values
    Exp = Exp; % uEye is in ms
    Exp_unit = 'ms';
elseif strcmp(CameraType,'Peak')
    src_mycam = get(ObjCamera, 'Source');
    Exp = src_mycam.ExposureTime/1000; % to correct for Peak which is in us
    Exp_unit = 'ms';
elseif strcmpi(CameraType,'Thorlabs')
    Exp = double(ObjCamera.ExposureTime_us)/1000; % to correct for Thorlabs which is in us
    Exp_unit = 'ms';

elseif strcmp(CameraType,'heliCam')
    % sensitivity ratio of acquising time for the capteur on the whole acquisition
    % One way to estimate equivalent time would be :
    % Exp = nbPeriode*sensitivity/freq <- To be checked
    % 
    % TODO: write a real function for the equivalence between sensitivity and other things
	Exp = ObjCamera.sensitivity*100;
	Exp_unit = "%";

end


end

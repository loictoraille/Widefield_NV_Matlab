
function ExpRange = GetExpRange()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc, ExpRange.Minimum] = AT_GetFloatMin(ObjCamera,'ExposureTime');
    AT_CheckWarning(rc);
    [rc, ExpRange.Maximum] = AT_GetFloatMax(ObjCamera,'ExposureTime');
    AT_CheckWarning(rc);     
    ExpRange.Minimum = ExpRange.Minimum*1000; % Andor in s
    ExpRange.Maximum = ExpRange.Maximum*1000;    
elseif strcmp(CameraType,'uEye') 
    [~,ExpRange]=ObjCamera.Timing.Exposure.GetRange();%Query Ranges
    ExpRange.Minimum = ExpRange.Minimum; % uEye in ms
    ExpRange.Maximum = ExpRange.Maximum;
elseif strcmp(CameraType,'Peak')
    src_mycam = get(ObjCamera, 'Source');
    res = propinfo(src_mycam,'ExposureTime');
    ExpRange.Minimum = res.ConstraintValue(1)/1000; % Peak in us
    ExpRange.Maximum = res.ConstraintValue(2)/1000;
elseif strcmpi(CameraType,'Thorlabs')
    ExpRange.Minimum = ObjCamera.ExposureTimeRange_us.Minimum/1000; % Thorlabs in us
    ExpRange.Maximum = ObjCamera.ExposureTimeRange_us.Maximum/1000;
    
elseif strcmp(CameraType,'heliCam')
	%TODO: To adapte to a version independent of the sensitivity and the frequency of the demodulation 
    ExpRange.Minimum = 0; 
    ExpRange.Maximum = 100;

end


end

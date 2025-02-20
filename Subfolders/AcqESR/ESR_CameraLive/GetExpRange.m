
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
    ExpRange.Minimum = res.ConstraintValue(1)/1000; % Peak in µs
    ExpRange.Maximum = res.ConstraintValue(2)/1000;
end


end
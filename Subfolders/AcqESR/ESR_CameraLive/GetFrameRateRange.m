
function FraRange = GetFrameRateRangeRange()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc, FraRange.Minimum] = AT_GetFloatMin(ObjCamera,'FrameRate');
    AT_CheckWarning(rc);
    [rc, FraRange.Maximum] = AT_GetFloatMax(ObjCamera,'FrameRate');
    AT_CheckWarning(rc);        
elseif strcmp(CameraType,'uEye') 
    [~,FraRange]=ObjCamera.Timing.Framerate.GetFrameRateRange();%Query Ranges
elseif strcmp(CameraType,'Peak') 
    src_mycam = get(ObjCamera, 'Source');
    res = propinfo(src_mycam,'AcquisitionFrameRate');
    FraRange.Minimum = res.ConstraintValue(1);
    FraRange.Maximum = res.ConstraintValue(2);
end


end
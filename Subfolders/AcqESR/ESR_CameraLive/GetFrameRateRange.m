
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
elseif strcmpi(CameraType,'Thorlabs')
    FraRange.Minimum = ObjCamera.FrameRateControlValueRange_fps.Minimum;
    FraRange.Maximum = ObjCamera.FrameRateControlValueRange_fps.Maximum;

elseif strcmp(CameraType,'heliCam')
	%TODO: To be changed when the speed of the camera is improved, why is FraRange.Minimum is important ? 
    FraRange.Minimum = 0;
    FraRange.Maximum = 1; 

end


end

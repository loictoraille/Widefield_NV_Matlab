function SendAOItoCAM(SetLeft,SetTop,SetWidth,SetHeight)

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc] = AT_SetInt(ObjCamera,'AOIWidth',double(SetHeight));
    AT_CheckWarning(rc);
    
    [rc] = AT_SetInt(ObjCamera,'AOILeft',double(SetTop));    
    AT_CheckWarning(rc);
    
    [rc] = AT_SetInt(ObjCamera,'AOIHeight',double(SetWidth));
    AT_CheckWarning(rc);
    
    [rc] = AT_SetInt(ObjCamera,'AOITop',double(SetLeft));
    AT_CheckWarning(rc);
    
elseif strcmp(CameraType,'uEye')
    ObjCamera.Size.AOI.Set(SetLeft, SetTop, SetWidth, SetHeight);    
elseif strcmp(CameraType,'Peak')    
    set(ObjCamera,'ROI',[SetLeft, SetTop, SetWidth, SetHeight]);
elseif strcmp(CameraType,'heliCam') %TODO : check here for debug
	% the same solution is used for the heliCam as in the Peak case
    set(ObjCamera,'ROI',[SetLeft, SetTop, SetWidth, SetHeight]);
else
    
end


end

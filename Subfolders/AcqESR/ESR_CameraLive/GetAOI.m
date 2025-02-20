
function AOI = GetAOI()

global ObjCamera CameraType

if strcmp(CameraType,'Andor')     
    [rc,AOI.X] = AT_GetInt(ObjCamera,'AOITop');
    AT_CheckWarning(rc);
    [rc,AOI.Y] = AT_GetInt(ObjCamera,'AOILeft');
    AT_CheckWarning(rc);
    [rc,AOI.Width] = AT_GetInt(ObjCamera,'AOIHeight');
    AT_CheckWarning(rc);
    [rc,AOI.Height] = AT_GetInt(ObjCamera,'AOIWidth');  
    AT_CheckWarning(rc);
    [rc,AOI.Stride] = AT_GetInt(ObjCamera,'AOIStride'); % padding added to width, stride >= width
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye')
    [~,AOI]=ObjCamera.Size.AOI.Get();
elseif strcmp(CameraType,'Peak') 
    [AOI_re] = ObjCamera.ROIPOsition;
    AOI.X = AOI_re(1);
    AOI.Y = AOI_re(2);
    AOI.Width = AOI_re(3);
    AOI.Height = AOI_re(4);
end


end
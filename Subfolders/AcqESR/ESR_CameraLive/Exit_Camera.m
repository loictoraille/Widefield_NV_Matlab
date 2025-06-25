
function Exit_Camera()
global ObjCamera CameraType

SaveCameraParam();

AOI = GetAOI();
if strcmp(CameraType,'uEye')
    temp.X = AOI.X;
    temp.Y = AOI.Y;
    temp.Width = AOI.Width;
    temp.Height = AOI.Height;
    clear AOI
    AOI = temp;
end
SaveAcqParameters({{AOI,'AOI'}});

EndAcqCamera();

if strcmp(CameraType, 'Andor')
    [rc] = AT_Close(ObjCamera);
    AT_CheckWarning(rc);
    [rc] = AT_FinaliseLibrary();
    AT_CheckWarning(rc);
    disp('Andor Camera shutdown');
    
elseif strcmp(CameraType, 'uEye')   
    ObjCamera.Exit;

elseif strcmp(CameraType,'Peak')
    delete(ObjCamera);    
elseif strcmp(CameraType,'heliCam')
	heliCamCloseCamera(ObjCamera);
elseif strcmpi(CameraType,'Thorlabs')
    ObjCamera.Dispose; %Releasing the camera
    delete(ObjCamera);
end

clear global ObjCamera
clear global CameraType

end

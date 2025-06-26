
function Exit_Camera()
global ObjCamera CameraType

panel = guidata(gcbo);

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
    tlCameraSDK = panel.UserData.tlCameraSDK;

    ObjCamera.Dispose; % Releasing the camera
    delete(ObjCamera);
    tlCameraSDK.Dispose; % Releasing the SDK
    delete(tlCameraSDK);
end

clear global ObjCamera
clear global CameraType

end

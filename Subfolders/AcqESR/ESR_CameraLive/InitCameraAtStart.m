
function InitCameraAtStart(CameraChoice)
global ObjCamera CameraType handleImage TestWithoutHardware

% Make sure to stop an eventual running acquisition
% if ~isempty(ObjCamera)
%     EndAcqCamera();
% end

if strcmp(CameraChoice,'Andor')
    if exist([matlabroot '\toolbox\AndorSDK3\andorsdk3functions.mexw64'], 'file') ~= 3 % check if AndorSDK3 is installed on the computer
        disp('Andor SDK3 is not installed');
    else
        % Two things are needed: the toolbox needs to be installed in the root folder,
        % and the AndorSDK3 also needs to be in the ESR Programs subfolders to be addressed correctly
        if isempty(ObjCamera)
            [rc] = AT_InitialiseLibrary();
            AT_CheckError(rc);
            [rc,ObjCamera] = AT_Open(0);
            if rc ~= 6 % check if camera opened successfully
                AT_CheckError(rc);
                disp('Andor Camera initialized');
                CameraType = 'Andor';
                EndAcqCamera();
                
                AndorSensorCooling();
                
                [rc] = AT_SetEnumString(ObjCamera,'CycleMode','Continuous');
                AT_CheckWarning(rc);
                [rc] = AT_SetEnumString(ObjCamera,'TriggerMode','Software');
                AT_CheckWarning(rc);
                [rc] = AT_SetEnumString(ObjCamera,'SimplePreAmpGainControl','16-bit (low noise & high well capacity)');
                AT_CheckWarning(rc);
                [rc] = AT_SetEnumString(ObjCamera,'PixelEncoding','Mono16');
                AT_CheckWarning(rc);
                InitAOILEVEL();
                LoadCameraParam();
                ListUselessSettings = {'sldframe','framin','framax','fratext','Input_FrameRate','sldpix','pixmin','pixmax','pixtext','Input_PixelClock','maxspeed'};
                TurnOffUselessSettings(ListUselessSettings);
            else
                clear global ObjCamera
                global ObjCamera
            end
        end
    end
    
elseif strcmp(CameraChoice,'uEye')

    % tries to open uEye Camera
    if isempty(ObjCamera)
        if exist('C:\Program Files\IDS\uEye\Develop\DotNet\signed\uEyeDotNet.dll', 'file') ~= 2 % check if uEye dll is installed on the computer
            disp('uEye dll is not installed');
        else
            NET.addAssembly('C:\Program Files\IDS\uEye\Develop\DotNet\signed\uEyeDotNet.dll');
            ObjCamera=uEye.Camera();%Define Camera Object
            [~,CamID]=ObjCamera.Device.GetCameraID;
            ObjCamera.Init(); %Initialize camera
            CameraType = 'uEye';
            InitAOILEVEL();
            %     updateuEyeParameterFile(); % To make sure TriggerMode is ok, manually changes the file
            % Deprecated: no longer uses the uEye .ini file loading, so don't bother
            % To load the uEye .ini, activate the Full_uEye_Load in the LoadCameraParam function
            LoadCameraParam();
            %     ObjCamera.Gain.Hardware.Factor.SetMaster(400); % To set the gain, need to do some tests
            disp('uEye Camera initialized');
            ObjCamera.Trigger.Set(uEye.Defines.TriggerMode.Software);%%To make sure TriggerMode is ok, may be unnecessary now
            ObjCamera.PixelFormat.Set(uEye.Defines.ColorMode.Mono12);%%To make sure the value CMode=Mono12 so that reshape function works in TakeCameraImage;indeed ColorMode is not loaded in parameter.ini
        end
    end

        
elseif strcmp(CameraChoice,'Peak')
    ObjCamera = ImaqInit();
    src_mycam = get(ObjCamera, 'Source');
    
    % Configure vidObj1 properties.
    set(ObjCamera, 'FramesPerTrigger', 1);
        
    % Configure the object for manual trigger mode.
    triggerconfig(ObjCamera, 'manual');    

    CameraType = 'Peak';
    
    InitAOILEVEL();
    LoadCameraParam();
    ListUselessSettings = {'sldpix','pixmin','pixmax','pixtext','Input_PixelClock','maxspeed'};
    TurnOffUselessSettings(ListUselessSettings);

elseif strcmp(CameraChoice,'heliCam')
	%TODO: Maybe clear the ObjCamera before initializing it
	ObjCamera = HelicamHandler();
	heliCamSetParameters(ObjCamera);
	CameraType = "heliCam";
end

if isempty(ObjCamera)
    disp('Connexion to camera was unsuccessful, check if camera is plugged in and turned on');
else

	UpdateImageWithROI;

	title(['Max pixel value ' num2str(max(max(ImageZero(:,3:end-2)))) '/' num2str(maxLum)]);
	set(haxes,'Tag','Axes_Camera');

end

end

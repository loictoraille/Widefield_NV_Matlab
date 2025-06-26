
function InitCameraAtStart(CameraChoice,panel)
global ObjCamera CameraType handleImage TestWithoutHardware

% Make sure to stop an eventual running acquisition
% if ~isempty(ObjCamera)
%     EndAcqCamera();
% end

if strcmpi(CameraChoice,'Andor')
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
                CameraType = 'Andor'; % strcmpi to not be sensitive to Case for the CameraChoice selection. Further tests most often use strcmp, we avoid problems this way
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
    
elseif strcmpi(CameraChoice,'uEye')

    if exist('C:\Program Files\IDS\uEye\Develop\DotNet\signed\uEyeDotNet.dll', 'file') ~= 2 % check if uEye dll is installed on the computer
        disp('uEye dll is not installed');
    else
        NET.addAssembly('C:\Program Files\IDS\uEye\Develop\DotNet\signed\uEyeDotNet.dll');
        ObjCamera=uEye.Camera();%Define Camera Object
        [~,CamID]=ObjCamera.Device.GetCameraID;
        ObjCamera.Init(); %Initialize camera
        CameraType = 'uEye'; % strcmpi to not be sensitive to Case for the CameraChoice selection. Further tests most often use strcmp, we avoid problems this way
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


elseif strcmpi(CameraChoice,'Peak')
    ObjCamera = ImaqInit();
    src_mycam = get(ObjCamera, 'Source');
    
    % Configure vidObj1 properties.
    set(ObjCamera, 'FramesPerTrigger', 1);
        
    % Configure the object for manual trigger mode.
    triggerconfig(ObjCamera, 'manual');    

    CameraType = 'Peak'; % strcmpi to not be sensitive to Case for the CameraChoice selection. Further tests most often use strcmp, we avoid problems this way
    
    InitAOILEVEL();
    LoadCameraParam();
    ListUselessSettings = {'sldpix','pixmin','pixmax','pixtext','Input_PixelClock','maxspeed'};
    TurnOffUselessSettings(ListUselessSettings);

elseif strcmpi(CameraChoice,'Thorlabs')
    dllPath = 'C:\Users\MS283248\Documents\DLL';
    if exist([dllPath '\Thorlabs.TSI.TLCamera.dll'], 'file') ~= 2 % check if Thorlabs dll is installed on the computer
        disp('Thorlabs dll file was not found');
    else        
        setenv('PATH', [dllPath ';' getenv('PATH')]);
        NET.addAssembly([dllPath, '\Thorlabs.TSI.TLCamera.dll']);
        tlCameraSDK = Thorlabs.TSI.TLCamera.TLCameraSDK.OpenTLCameraSDK;
        panel.UserData.tlCameraSDK = tlCameraSDK;
        serialNumbers = tlCameraSDK.DiscoverAvailableCameras;
        if serialNumbers.Count > 0
        ObjCamera = tlCameraSDK.OpenCamera(serialNumbers.Item(0), false); % Open the first TLCamera using the serial number
        ObjCamera.OperationMode = Thorlabs.TSI.TLCameraInterfaces.OperationMode.SoftwareTriggered;
        ObjCamera.FramesPerTrigger_zeroForUnlimited = 1; % set to zero for continuous acquisition?
        CameraType = 'Thorlabs'; % strcmpi to not be sensitive to Case for the CameraChoice selection. Further tests most often use strcmp, we avoid problems this way
        InitAOILEVEL();
        LoadCameraParam();
        ListUselessSettings = {'sldframe','pixmin','pixmax','pixtext','Input_PixelClock'};
        TurnOffUselessSettings(ListUselessSettings);
        else
            disp('Thorlabs camera is probably not connected')
        end
    end
elseif strcmpi(CameraChoice,'heliCam')
	%TODO: Maybe clear the ObjCamera before initializing it
	if isempty(ObjCamera)
		ObjCamera = HelicamHandler();
		heliCamSetParameters(ObjCamera);
		CameraType = "heliCam"; % strcmpi to not be sensitive to Case for the CameraChoice selection. Further tests most often use strcmp, we avoid problems this way
	end
end

if isempty(ObjCamera)
    disp('Connexion to camera was unsuccessful, check if camera is plugged in and turned on');
else

	UpdateImageWithROIScript;

	title(haxes,['Max pixel value = ' num2str(round(max(max(ImageZero))))]);
	set(haxes,'Tag','Axes_Camera');

end

guidata(gcf,panel);

end

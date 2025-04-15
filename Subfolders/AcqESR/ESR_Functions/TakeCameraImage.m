function ImageMatrix=TakeCameraImage(ImageSize,AOI)
global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc] = AT_QueueBuffer(ObjCamera,ImageSize);
    AT_CheckWarning(rc);
    [rc] = AT_Command(ObjCamera,'SoftwareTrigger');
    AT_CheckWarning(rc);
    [rc,buf] = AT_WaitBuffer(ObjCamera,10000);
    % Be careful with this thing, it seems to create a lag that can only
    % be reset by calling a new SoftwareTrigger without waitbuffer this
    % time (implemented in prepare camera)
    % Check if it works as it is
    
    % When the acquisition has been started there is a function AT_WaitBuffer that can be used to put the calling thread to block until the current image
    % has been captured and is ready for the program to use. A time out value in milliseconds is also specified to AT_WaitBuffer to force it to return if
    % the acquisition has not occurred in that time frame
    AT_CheckError(rc);
    [rc,ImageMatrix] = AT_ConvertMono16ToMatrix(buf,AOI.Width,AOI.Height,AOI.Stride);
    AT_CheckWarning(rc);      
elseif strcmp(CameraType,'uEye')
    %Allocate mem ID
    [~,MemID]=ObjCamera.Memory.Allocate(AOI.Width,AOI.Height,ImageSize);
    ObjCamera.Memory.SetActive(MemID);
    %Function to acquire Camera Image
    ObjCamera.Acquisition.Freeze(true);
    [~,fin]=ObjCamera.Acquisition.IsFinished();
    while fin==0
        [~,fin]=ObjCamera.Acquisition.IsFinished();
    end
    [~,LastImageID]=ObjCamera.Memory.GetLast;
    [~,CMode]=ObjCamera.PixelFormat.Get();
    [~,BytesArray]=ObjCamera.Memory.CopyToArray(LastImageID,CMode);
    ImageMatrix=reshape(uint32(BytesArray),AOI.Width,AOI.Height,1)';
    %% if error here, check the parameter file in ESR_uEyeIniParameters: the colormode must be 26 '
    
elseif strcmp(CameraType,'Peak')
    ImageMatrix = getsnapshot(ObjCamera);

elseif strcmp(CameraType,'heliCam')
	% TODO to get a single image mode for quick and live acquisition
	disp('Unfinished TAkeCameraImage')
	if ObjCamera.quickmode
		%TODO: improve the change between
	
		ImageMatrix = heliCamGetQuickImage(ObjCamera); % quick mode setup	
	else
		ImageMatrix = heliCamGetImage(ObjCamera); % normal mode 
	end
end

end

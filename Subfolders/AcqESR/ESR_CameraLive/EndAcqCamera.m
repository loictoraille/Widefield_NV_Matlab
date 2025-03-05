
function EndAcqCamera()
global ObjCamera CameraType

if strcmp(CameraType,'Andor')
    [rc] = AT_Command(ObjCamera,'AcquisitionStop');
%     AT_CheckWarning(rc);
    [rc] = AT_Flush(ObjCamera);
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye')
    ObjCamera.Acquisition.Stop;
    [~,MemID] = ObjCamera.Memory.GetActive();
    if MemID ~= 0
        ObjCamera.Memory.Free(MemID);
    end
elseif strcmp(CameraType,'Peak')
    stop(ObjCamera);    

elseif strcmp(CameraType,'heliCam')
	% TODO: function to write here
	heliCamStopAcq(ObjCamera);
end

end

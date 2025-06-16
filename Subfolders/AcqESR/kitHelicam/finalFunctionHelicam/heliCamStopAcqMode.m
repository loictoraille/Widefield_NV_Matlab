function heliCamStopAcqMode(ObjCamera)
	% function to change camera mode from acquisition mode

	ObjCamera.c4dev.stopAcquisition(); % this function doesn't take any parameters
	ObjCamera.AcqMode = false;
end

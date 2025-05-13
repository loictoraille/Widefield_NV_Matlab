function heliCamStopAcqMode(ObjCamera)
	% function to change camera mode from acquisition mode
	% to configuration mode

	if ObjCamera.AcqMode
		ObjCamera.c4dev.stopAcquisition(); % this function doesn't take any parameters
		ObjCamera.AcqMode = false;
	else
		disp("warning : Camera mode already set to Configuration"); % the camera may crash if set tp the mode it already in 
	end
end

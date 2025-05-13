function heliCamStartAcqMode(ObjCamera)
	% function to change camera mode from configuration
	% to the acquisition mode

	%TODO: Understand the point of this integer in the function

	%TODO: bind the state of ObjCamera.AcqMode to a reading of the actual value on the camera 
	if ObjCamera.AcqMode
		disp("warning : Camera mode already set to Acquisition"); % the camera may crash if the command is send when the camera 
	else
		ObjCamera.c4dev.startAcquisition(4); % I do not know why it take an integer but 4 worked so far TODO: find why is this parameter important
		ObjCamera.AcqMode = true;
	end
end

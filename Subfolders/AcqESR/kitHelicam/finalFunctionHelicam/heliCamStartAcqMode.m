function heliCamStartAcqMode(ObjCamera)
	% function to change camera mode from configuration
	% to the acquisition mode

	ObjCamera.c4dev.startAcquisition(4); % I do not know why it take an integer but 4 worked so far TODO: find why is this parameter important
	ObjCamera.AcqMode = true;

end

function heliCamStopAcqMode(ObjCamera)
	% function to change camera mode from acquisition mode
	% to configuration mode
	c4dev.stopAcquisition(); % this function doesn't take any parameters

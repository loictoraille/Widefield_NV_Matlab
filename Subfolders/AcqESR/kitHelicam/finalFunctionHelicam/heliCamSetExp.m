function heliCamSetExp(ObjCamera,Exposure)
	% Function to set the exposure
	% TODO : remove this function in the next big change of code
	sensitivity = Exposure;
	
	ObjCamera.c4dev.writeFloat("LockInSensitivity",sensitivity);
	ObjCamera.sensitivity = sensitivity
end

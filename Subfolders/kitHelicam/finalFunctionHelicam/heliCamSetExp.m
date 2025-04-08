function heliCamSetExp(ObjCamera,Exposure)
	% Function to set the exposure
	% 
	sensitivity = Exposure;
	
	ObjCamera.c4dev.writeFloat("LockInSensitivity",sensitivity);
	ObjCamera.sensitivity = sensitivity.
end

function heliCamSetExp(ObjCamera,Exposure)
	% Function to set the exposure

	sensitivity = Exposure; %TODO: to do the adaptation from exposure time to 
	
	ObjCamera.c4dev.writeFloat("LockInSensitivity",sensitivity);

end

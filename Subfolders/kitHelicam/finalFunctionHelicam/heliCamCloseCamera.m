function heliCamShutdown(ObjCamera)
	% function that will correctly disconnected the camera from the computer
	% If the camera is not correctly disconnected from the computer it prevent
	% any other software using. It might also stuck the firmware.

	%TODO: check the acquisition mode before doing this, or the programme might crash
	ObjCamera.c4dev.stopAcquisition();
	ObjCamera.c4dev.release();
	ObjCamera.c4if.release();


	%TODO: variable management 
	% do we delete ObjCamera to avoid conflict

end

function heliCamCloseCamera(ObjCamera)
	heliCamStopAcqMode(ObjCamera);
	% end of use the camera
	ObjCamera.c4dev.release(); %end of the interface for the camera
	ObjCamera.c4if.release();  % cut f the network interface, mandatory to avoid conflict
	disp("Closed connexion with the Camera");
end

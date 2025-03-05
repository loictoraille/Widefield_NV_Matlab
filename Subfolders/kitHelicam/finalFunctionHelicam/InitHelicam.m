function InitHelicam(ObjCamera)	
	% establish camera connection	
	% must be call to comunicate with the camera at startup

	
	c4sys = heliotis.C4HandlerCLR();
	c4sys.reset();
	
	ifNo = selectInterface(c4sys); % computer side
	c4if = c4sys.openInterface(ifNo);
	devNo = selectDevice(c4if); % camera side
	c4dev = c4if.openDevice(devNo);

	% ObjCamera should carry all the method
    % to configure and control the camera
    
	ObjCamera.c4dev = c4dev;
	ObjCamera.c4sys = c4sys;
	ObjCamera.c4if  = c4if;

end

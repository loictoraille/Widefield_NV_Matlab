function InitHelicam(ObjCamera)	
	% establish camera connection	
	% must be call to comunicate with the camera at startup

	if ~NET.isNETSupported
	    disp('Supported .NET Framework not found')
	    return
	end
	
	NET.addAssembly('C4HdlCLR');
	import C4HdlCLR.*
	
	c4sys = heliotis.C4HandlerCLR();
	c4sys.reset();
	
	ifNo = selectInterface(c4sys); % computer side
	c4if = c4sys.openInterface(ifNo);
	devNo = selectDevice(c4if); % camera side
	c4dev = c4if.openDevice(devNo);

	% ObjCamera should carry all the method
    % to configure and control the camera
    % -> c4dev is the interface that write commande to the camera
    % and send the software trigger
	% -> c4sys TODO : describe what the c4sys object is for (probably the driver interface)
    % -> c4if is the network interface
    
	ObjCamera.c4dev = c4dev;
	ObjCamera.c4sys = c4sys;
	ObjCamera.c4if  = c4if;

	%TODO: set all variable fo the ObjCamera
	% from the ToWrite.md file

	ObjCamera.TriggerMode    = "TriggerSoftware"; 
	%TODO : charge a config file for parameters 
	ObjCamera.firstSetup = true;
	ObjCamera.AcqMode        = false;
	
	% for the heliCamGetImage functiun
	ObjCamera.removeOffset   = true;
	ObjCamera.NFramesDiscard =  3; 
	heliCamSetParameters(ObjCamera);
	
	

	

end

classdef  HelicamHandler < handle 
	properties
		%%%%%%%%%%% handler
	
		c4dev;
		c4if ;
		c4sys;



		% paramters are all around the code but they all need to be
		% initialize here, you can not add a variable to class after it's creation (as far as I know)

		%%%%%%%%%%% Camera parameters

		TriggerMode;
		NFramesDiscard = 3;
		sensitivity = 0.5;
		% Number of intergration periods
		NPeriods = 5;
		
		coupling = 'DC';
		% Reference frequency in Hz
		refFrequency = 10000.0;
		% Source of reference signal, 'Internal' or 'External'
		refSource = 'Internal';
		% Expected frequency deviation of external reference input in "%"
		expFrequencyDev = 5;
		
		%%%%%%%%%%% other persistante parameters

		firstSetup = true;
		AcqMode = false;
		removeOffset = false; % TODO: setup a calibration methode


	end

	methods 
	function obj = HelicamHandler(obj)
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
		    
			obj.c4dev = c4dev;
			obj.c4sys = c4sys;
			obj.c4if  = c4if;

			%TODO: set all variable fo the ObjCamera
			% from the ToWrite.md file

			obj.TriggerMode    = "TriggerSoftware"; 
			%TODO : charge a config file for parameters 
			obj.firstSetup     = true;
			obj.AcqMode        = false;
			
			% for the heliCamGetImage functiun
			obj.removeOffset   = true;
			obj.NFramesDiscard =  3; 
	end

end

end

classdef  HelicamHandler < handle 
	properties
		%%%%%%%%%%% handler
	
		c4dev;
		c4if ;
		c4sys;



		% paramters are all around the code but they all need to be
		% initialize here, you can not add a variable to class after it's creation (as far as I know)

		%%%%%%%%%%% Camera parameters

		TriggerMode = "TriggerSoftware";
		NFramesDiscard = 3; %TODO: check if this value is really irrelevent, i.e if first frame are really not exploitable
		sensitivity = 0.5;
		% Number of intergration periods
		NPeriods = 10; % Increase this value and exposure to get more accurate values

		%Number of frames per burst of acquisition 
		NbFrames = 5;

		%Coupling mode of the camera
		coupling = 'AC';
		% Reference frequency in Hz
		refFrequency = 10000.0;
		% Source of reference signal, 'Internal' or 'External'
		refSource = 'External';
		% Expected frequency deviation of external reference input in "%"
		expFrequencyDev = 5;

		% Signal generator DC offset in % of full range
		sgnOffset = 20.0;
		% Signal generator peak-to-peak amplitude in % of full range
		sgnAmplitude = 10.0;
		% Signal generator frequency in Hz
		sgnFrequency = 9975.0;

		%reference freuency entry for external source
		LockInReferenceSourceSignal = "FI2";
				
		%%%%%%%%%%% other persistante parameters

		firstSetup = true;
		AcqMode = false;
		removeOffset = true; % TODO: setup a calibration methode
		quickmode = true; % TODO: add methode to change the configuration between quick and slow acquisition

		% maximum brightness of pixel
		maxLum = 600; % TODO: change to the real value of the camera
		lumFactor = 10; % TODO: adapt in a way the luminosity of the camera to the live mode for better representation


	end

	methods 
	function ObjCamera = HelicamHandler(ObjCamera)
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

			%TODO: set all variable fo the ObjCamerad			% from the ToWrite.md file
			%TODO : charge a config file for parameters 
			
			% for the heliCamGetImage functiun
			disp("default parameters");
			heliCamSetParameters(ObjCamera);
			
	end

end

end

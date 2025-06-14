function heliCamSetParameters(ObjCamera)
	% Function that set all the parameters of the camera
	% we change all the parameters at once
	% Parameters must be set thanks to the c4dev object in the camera
	% structure, depending on the type of the parameter different parameters must be called
	

	%TODO check change in the parameters that need to be updated 
	% as to not set up everything each time
	
	%Parameters that need to be set regularly
	%sensitivity
	%phase % TODO: phase exploration is something to look for
	
	%frequence multiplier
	%NbFrames
	%Trigger mode
	%Calibration
	%AC/DC coupling


	if ObjCamera.AcqMode
		disp("WARNING : AcqMode = true ,the setting of parameters might not work ");
	end
	if ObjCamera.firstSetup
	%First set up of the camera
		disp("heliCamSetParameters : default mode");
	 %TODO: Initialize default parameters elsewhere to avoid conflict
		%ObjCamera.sensitivity = 0.5;
		% Number of intergration periods
		%ObjCamera.NPeriods = 5;
		% Background suppression on/off switch, 'AC' or 'DC'
		ObjCamera.coupling = 'AC';
		% Reference frequency in Hz
		ObjCamera.refFrequency = 10000.0;
		% Source of reference signal, 'Internal' or 'External'
		ObjCamera.refSource = 'Internal';
		disp("default to internal oscillateur for setting");
		% Expected frequency deviation of external reference input in %
		ObjCamera.expFrequencyDev = 5;
		
		% Illumination Driving Signal
		
		% Signal generator DC offset in % of full range
		ObjCamera.sgnOffset = 20.0;
		% Signal generator peak-to-peak amplitude in % of full range
		ObjCamera.sgnAmplitude = 10.0;
		% Signal generator frequency in Hz
		ObjCamera.sgnFrequency = 9975.0;

		%Number of frame per burst of acquisition
		ObjCamera.NbFrames = 4; %minimum value

	    ObjCamera.c4dev.writeString("TriggerSelector", "RecordingStart");
	    ObjCamera.c4dev.writeString("TriggerMode", "Off");
	    ObjCamera.c4dev.writeString("TriggerSelector", "FrameStart");
	    ObjCamera.c4dev.writeString("TriggerMode", "On");
	    ObjCamera.c4dev.writeString("TriggerSource", "Software");
	    
	    % LIA
	    
	    ObjCamera.c4dev.writeString("DeviceOperationMode", "LockInCam");
	    ObjCamera.c4dev.writeString("Scan3dExtractionMethod", "rawIQ");
	    
	    ObjCamera.c4dev.writeFloat("LockInSensitivity", ObjCamera.sensitivity);
	    ObjCamera.c4dev.writeInteger("LockInTargetTimeConstantNPeriods", ObjCamera.NPeriods);
	    ObjCamera.c4dev.writeString("LockInCoupling", ObjCamera.coupling);
	    ObjCamera.c4dev.writeInteger("LockInExpectedFrequencyDeviation", ObjCamera.expFrequencyDev);
	    ObjCamera.c4dev.writeFloat("LockInTargetReferenceFrequency", ObjCamera.refFrequency);
	    
	    ObjCamera.c4dev.writeString("LockInReferenceSourceType", ObjCamera.refSource);
	    
	    % For external reference signal only
	    ObjCamera.c4dev.writeString("LockInReferenceFrequencyScaler", "Off");
	    ObjCamera.c4dev.writeString("LockInReferenceSourceSignal", "FI2");

	    %%%% Uncomment this part to test the camera with it's internal generator
		    %% Illumination
		    % % setup of the generator    
	    ObjCamera.c4dev.writeFloat("SignalGeneratorOffset", ObjCamera.sgnOffset);
	    ObjCamera.c4dev.writeFloat("SignalGeneratorAmplitude", ObjCamera.sgnAmplitude);
	    ObjCamera.c4dev.writeString("LightControllerSelector", "LightController0");
	    ObjCamera.c4dev.writeString("SignalGeneratorMode", "On");
	    ObjCamera.c4dev.writeFloat("SignalGeneratorFrequency",ObjCamera.sgnFrequency);
	    ObjCamera.c4dev.writeString("LightControllerSource", "SignalGenerator");

	    ObjCamera.c4dev.writeInteger("AcquisitionBurstFrameCount",ObjCamera.NbFrames);
			ObjCamera.firstSetup = false;
			disp("heliCamSetParameters dev : default mode to fast");
			disp("heliCamSetParameters dev : First set of the Camera is default, pause of one seconde");
			pause(3); %TODO safety measure to let time to the camera to do the setup
	end		

	

end

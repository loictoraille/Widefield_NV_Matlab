function heliCamSetParameters(ObjCamera)
	% Function that set all the parameters of the camera
	% we change all the parameters at once
	% Parameters must be set thanks to the c4dev object in the camera
	% structure, depending on the type of the parameter different parameters must be called
	

	%TODO check change in the parameter that need to be updated 
	% as to not set up everything each time
	
	%Parameters that need to be set regularly
	%sensitivity
	%phase % TODO: phase exploration is something to look for
	
	%frequence multiplier
	%NbFrames
	%Trigger mode
	%Calibration
	%AC/DC coupling


	if ObjCamera.firstSetup
	%First set up of the camera

	 %TODO: Initialize default parameters elsewhere to avoid conflict
		ObjCamera.sensitivity = 0.5;
		% Number of intergration periods
		ObjCamera.NPeriods = 5;
		% Background suppression on/off switch, 'AC' or 'DC'
		ObjCamera.coupling = 'DC';
		% Reference frequency in Hz
		ObjCamera.refFrequency = 10000.0;
		% Source of reference signal, 'Internal' or 'External'
		ObjCamera.refSource = 'Internal';
		% Expected frequency deviation of external reference input in %
		ObjCamera.expFrequencyDev = 5;
		
		% Illumination Driving Signal
		
			% Signal generator DC offset in % of full range
			ObjCamera.sgnOffset = 20.0;
			% Signal generator peak-to-peak amplitude in % of full range
			ObjCamera.sgnAmplitude = 10.0;
			% Signal generator frequency in Hz
			ObjCamera.sgnFrequency = 9975.0;


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

	    
		    %% Illumination
		    % % setup of the generator    
		    %ObjCamera.c4dev.writeFloat("SignalGeneratorOffset", sgnOffset);
		    %ObjCamera.c4dev.writeFloat("SignalGeneratorAmplitude", sgnAmplitude);
		    %ObjCamera.c4dev.writeString("LightControllerSelector", "LightController0");
		    %ObjCamera.c4dev.writeString("SignalGeneratorMode", "On");
		    %ObjCamera.c4dev.writeFloat("SignalGeneratorFrequency", sgnFrequency);
		    %ObjCamera.c4dev.writeString("LightControllerSource", "SignalGenerator");

		ObjCamera.firstSetup = false;
	end		

end

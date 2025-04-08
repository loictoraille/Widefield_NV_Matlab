function [exp,expUnit] = heliCamGetExp(ObjCamera)
%Supposed to return the exposure of the camera but will actually return the "sensitivity" 
%TODO : maybe recalculate an exposure time from the sensitivity
% at fixed sensitivity, the exposure time is proportionnal to the period of the demodulation frequency
% which is not directly responsible to the camera
	
	sensitivity = ObjCamera.c4dev.readFloat("LockInSensitivity");
	disp("sensitivity % value is : ");
	sensitivity % output the value of sensitivity
	ObjCamera.Realsensitivity = sensitivity; % storing it somewhere	
	%TODO: write the correspondence from exposureTime
	 % to sensitivity

	 %Techniquely done : since sensitivity = modulation freq * exposition time
 
	exp = SensitivityToExposureTime(sensitivity); % is necessary ?

	expUnit = "%"; % sensitivity is a ratio
end

function [exp,expUnit] = heliCamGetExp(ObjCamera)
%Supposed to return the exposure of the camera but will actually return the "sensitivity" 
%TODO : Remove this function ?
	
	sensitivity = ObjCamera.c4dev.readFloat("LockInSensitivity");
	disp("sensitivity % value is : ");
	sensitivity % output the value of sensitivity
	%ObjCamera.Realsensitivity = sensitivity; % storing it somewhere	
	%TODO: write the correspondence from exposureTime
	 % to sensitivity

	 %Techniquely done : since sensitivity = modulation freq * exposition time
 
	exp = SensitivityToExposureTime(sensitivity); % is necessary ?

	expUnit = "%"; % sensitivity is a ratio
end

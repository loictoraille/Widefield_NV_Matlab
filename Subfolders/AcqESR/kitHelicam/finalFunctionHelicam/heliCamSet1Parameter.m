function heliCamSet1Parameter(ObjCamera,registerName,registerValue)
	% Function that can charge any parameter into the camera
  heliCamRegisterType; % to charge the dictionary of register type


  regType = registerType(registerName);
  
  if strcomp(regType,"Enumeration")
  	ObjCamera.c4dev.writeString(registerName,registerValue);

  elseif strcomp(regType,"Float")
  	ObjCamera.c4dev.writeFloat(registerName,registerValue);

  elseif strcomp(regType,"Integer")
  	ObjCamera.c4dev.writeInteger(registerName,registerValue);
 
  elseif strcomp(regType,"Boolean")
  	ObjCamera.c4dev.writeInteger(registerName,registerValue);
  end
	
end

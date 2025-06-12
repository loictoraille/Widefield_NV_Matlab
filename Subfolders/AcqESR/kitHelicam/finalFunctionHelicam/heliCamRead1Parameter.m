function registerValue = heliCamRead1Parameter(ObjCamera,registerName)
	% Function that can read the value of any register of the camera
  heliCamRegisterType; % to charge the dictionary of register type


  regType = registerType(registerName);
  
  if strcomp(regType,"Enumeration")
  	registerValue = ObjCamera.c4dev.readString(registerName);

  elseif strcomp(regType,"Float")
  	registerValue = ObjCamera.c4dev.readFloat(registerName);

  elseif strcomp(regType,"Integer")
  	registerValue = ObjCamera.c4dev.readInteger(registerName);
 
  elseif strcomp(regType,"Boolean")
  	Value = ObjCamera.c4dev.readString(registerName);
  	registerValue = Value==1 ;
  end
	
end

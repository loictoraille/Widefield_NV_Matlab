function heliCamLoadConfig(ObjCamera,pathTemplate,pathNewConfigFile)
  % Function that copy an old config and but actualise parameters to the actual value from the camera
  configFile = fopen(pathTemplate,'r');
  NewConfigFile = fopen(pathNewConfigFile,'a');
  % TODO: check if the file existe to overwrite it or change the new file
  % name

 while True
    configLine = fgetl(configFile); %charge the next line

    if configLine == -1
      % reach the end of file
      break; 
    end
    
    formatedLine = split(configLine,["%" "#"]) % remove the comment
    


    if length(formatedLine)<2
      % comment only line or wrongly formated
      disp(formatedLine(1));
      fprintf(NewConfigFile,configLine);
      newLine = configLine; % copy the comment as is into the new config file
    else 

	%parsing of the command
	% 
	    formatedLine = split(formatedLine(1),"=");
      registerName = formatedLine(1);
      registerValue = formatedLine(2);
      
      if strfind(registerName,"Selector")
      	% Selector register are like cursor that you move to access specific register of the camera
      	% they should not be chnaged
        heliCamSet1Parameter(ObjCamera,registerName, registerValue);
      else
        registerValue = heliCamRead1Parameter(ObjCamera,registerName); %read the state of the value in the camera
      end

      newLine = strrep(configLine,formatedLine(2),string(registerValue)); %replace the old value by the new one

    end

    fprintf(NewConfigFile, newLine);
  

   end

   fclose(configFile);
   fclose(NewConfigFile);

end

function heliCamLoadConfig(ObjCamera,path)
  %function that read the config file of the camera from scratch
	configFile = fopen(path,'r');




  

	 while True
	    configLine = fgetl(configFile); %charge the next line

	    if configLine == -1
	      % reach the end of file
	      break; 
	    end
	    formatedLine = split(configLine,["%" "#"])

	    if strlength(formatedLine(1)==0 %empty line or commented line
	      continue; 
	    end
	    
	    formatedLine = split(formatedLine(1),["="]);

	    if length(formatedLine)<2
	      disp("ignored line config :");
	      disp(configLine);
	      continue;
	    end 

		%parsing of the command
	    registerName = formatedLine(1);
	    registerValue = formatedLine(2);
		%charging of the command
	    heliCamSet1Parameter(ObjCamera,registerName,registerValue);


	   end

	   fclose(configFile);


end

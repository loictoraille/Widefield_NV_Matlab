function devNo = selectDevice(c4if)
    % device selection with user interaction 
	% TODO : add the expected ip address to variable of the Camera to change it from an interface

	cameraIP = '169.254.2.3';
    devNo = -1;
    disp('Device: ')
    nofDev = c4if.updateDeviceList();
    if (nofDev == 0)
        disp('No device detected!');
        return
    end
	
	disp('Autmatic detection of device activate, expecting to find a device at :');
	disp(cameraIP);

    for i = 0:(nofDev-1)
        curDevName = c4if.getDeviceName(i);
        disp(num2str(i + 1) + ": " + string(curDevName));

        if length(strfind(string(curDevName),cameraIP))
        	devNo = i;
        	disp('found device');
        	return
        end
    end
    val = input('select a device (exit with any other value): ');
    if ((val <= 0) || (val > nofDev))
        disp('Device selection is out of range!');
        return
    end
    devNo = (val - 1);
end

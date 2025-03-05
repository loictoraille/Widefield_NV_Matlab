function devNo = selectDevice(c4if)
    % device selection with user interaction 
    devNo = -1;
    disp('Device: ')
    nofDev = c4if.updateDeviceList();
    if (nofDev == 0)
        disp('No device detected!');
        return
    end

	disp('Autmatic detection of device activate, expecting to find a device at 192.168.2.71');

    for i = 0:(nofDev-1)
        curDevName = c4if.getDeviceName(i);
        disp(num2str(i + 1) + ": " + string(curDevName));

        if lenght(strfind(string(curDevName),'192.168.2.71'))
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

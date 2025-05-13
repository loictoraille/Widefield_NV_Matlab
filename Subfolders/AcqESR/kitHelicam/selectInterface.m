function ifNo = selectInterface(c4sys)
    % interface selection with user interaction
    ifNo = -1;
    disp('Interfaces: ')
    nofIf = c4sys.updateInterfaceList();
    if (nofIf == 0)
        disp('No interface detected!');
        return
    end

    disp('Automatic selection of interface activated, expect the ethernet interface to be at 192.168.2.70');
    
    for i = 0:(nofIf-1)
        curIfName = c4sys.getInterfaceName(i);
        disp(num2str(i + 1) + ": " + string(curIfName));

		if length(strfind(string(curIfName),'192.168.2.70'))
			ifNo = i;
			disp('found interface');
		end
    end

	if ifNo >= 0
		return
	end

    
    val = input('select an interface (exit with any other value): ');
    if ((val <= 0) || (val > nofIf))
        disp('Interface selection is out of range!');
        return
    end
    ifNo = (val - 1);
end

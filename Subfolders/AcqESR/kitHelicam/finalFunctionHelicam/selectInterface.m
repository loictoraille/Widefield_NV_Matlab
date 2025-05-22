function ifNo = selectInterface(c4sys)
    % interface selection with user interaction
    %
    % TODO : match the expected IP an variable editable
    % from the user interface
    % 

	localIPinterface = '169.254.2.1';
    
    ifNo = -1;
    disp('Interfaces: ')
    nofIf = c4sys.updateInterfaceList();
    if (nofIf == 0)
        disp('No interface detected!');
        return
    end

    disp('Automatic selection of interface activated, expect the ethernet interface to be at :');
    disp(localIPinterface);

    % each interface is print
    % if one interface match the ip name then it must be 
    for i = 0:(nofIf-1)
        curIfName = c4sys.getInterfaceName(i);
        disp(num2str(i + 1) + ": " + string(curIfName));

		if length(strfind(string(curIfName),localIPinterface))
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

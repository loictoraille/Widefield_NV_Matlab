function ifNo = selectInterface(c4sys)
    % interface selection with user interaction
    ifNo = -1;
    disp('Interfaces: ')
    nofIf = c4sys.updateInterfaceList();
    if (nofIf == 0)
        disp('No interface detected!');
        return
    end
    for i = 0:(nofIf-1)
        curIfName = c4sys.getInterfaceName(i);
        disp(num2str(i + 1) + ": " + string(curIfName));
    end
    val = input('select an interface (exit with any other value): ');
    if ((val <= 0) || (val > nofIf))
        disp('Interface selection is out of range!');
        return
    end
    ifNo = (val - 1);
end


function testCOMPort(StringIn)
% test function for COM ports
panel = guidata(gcbo);

eval(['COM_Exist = isfield(panel.UserData,''' StringIn ''');']);
eval(['comPORT = panel.com' StringIn '.String;']);

if COM_Exist == 1
    eval(['str_comPort = panel.UserData.' StringIn '.Port;']);
    str_toTest = "COM" + num2str(comPORT);
    if strcmp(str_comPort,str_toTest)
        COM_connected = 1;
    else
        COM_connected = 0;
    end
end

if COM_connected == 0    
    if ~isempty(comPORT)
        testCOM = serialport("COM"+comPORT,9600);
         disp(['COM Port ' num2str(comPORT) ' is responding to matlab code']);
        clear testCOM
    end
else
    disp(['COM Port ' num2str(comPORT) ' is already connected with matlab code']);
end


end



function InitPiezo(~,~)
global NI_card TestWithoutHardware

if ~TestWithoutHardware
    
try
    % Initialise la connexion à la carte NI
    NI_card = daq("ni");
    daq_list = daqlist;
catch 
    disp('NI card initialization failed: have you turned on the NI card? Is the correct toolbox installed?');
    NI_card = [];
    daq_list = [];
end

    %     dq.Rate = 8000; % pour changer le rate, a tester

if exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist)

    addoutput(NI_card, daq_list.DeviceID(1), "ao0", "Voltage"); % X
    addoutput(NI_card, daq_list.DeviceID(1), "ao1", "Voltage"); % Y
    addoutput(NI_card, daq_list.DeviceID(1), "ao2", "Voltage"); % Z
    addoutput(NI_card, daq_list.DeviceID(1), "ao3", "Voltage"); % light

    write(NI_card,[0, 0, 0, 0]); % initialisation a 0 V
    
    h=findobj('tag','initpiezo');
    
    h.ForegroundColor = [0,1,0];
    h.Value = 1;
    
    [X_value, Y_value, Z_value, Light_value] = ReadPiezoInput();
    
    hlight=findobj('tag','lightpiezo');
    hlight.Value = 1;
    hlight.ForegroundColor = [0,1,0];
    
    CheckMaxAndWriteNI(X_value, Y_value, Z_value, Light_value);
else
    disp('NI_card was not found, check if it is plugged in and turned on, then restart Matlab')
end
    
end

end

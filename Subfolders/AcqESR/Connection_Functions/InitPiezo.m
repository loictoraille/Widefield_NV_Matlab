function InitPiezo(panel)
global NI_card SetupType

load([getPath('Param') 'AcqParameters.mat']);

if strcmpi(SetupType,"CEA") || strcmpi(SetupType,"ENS1")

    % initialise la connexion à la carte NI
    NI_card = daq("ni");
    daq_list = daqlist;

    %     dq.Rate = 8000; % pour changer le rate, à tester

    if exist('NI_card','var') && any(isprop(NI_card,'Running')) && ~isempty(daqlist)

        addoutput(NI_card, daq_list.DeviceID(1), "ao0", "Voltage"); % X
        addoutput(NI_card, daq_list.DeviceID(1), "ao1", "Voltage"); % Y
        addoutput(NI_card, daq_list.DeviceID(1), "ao2", "Voltage"); % Z
        addoutput(NI_card, daq_list.DeviceID(1), "ao3", "Voltage"); % light

        write(NI_card,[0, 0, 0, 0]); % initialisation à 0 V

        panel.switchpiezo.String = 'Piezo ON';
        panel.switchpiezo.Value = 1;
        panel.switchpiezo.ForegroundColor = [0,0,1];

        if strcmpi(SetupType,"ENS1")
            panel.light.Value = 1;
            panel.light.ForegroundColor = [0,0,1];
        end

        if strcmpi(SetupType,"CEA")
            panel.shutterlaser.Value = 1;
            panel.shutterlaser.ForegroundColor = [0,0,1];
        end

        Smart_PZ_Light_Laser_Write(panel);
        disp('Piezo via NI_card connected successfully.')
    else
        disp('NI_card was not found, check if it is plugged in and turned on, then restart Matlab')
    end

else

end

end
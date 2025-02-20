
%% Small code to continuously loop Y_Value between -10 and 10, stop with control-C

% initialise la connexion à la carte NI
NI_card = daq("ni");
daq_list = daqlist;


addoutput(NI_card, daq_list.DeviceID(1), "ao0", "Voltage"); % X
addoutput(NI_card, daq_list.DeviceID(1), "ao1", "Voltage"); % Y
addoutput(NI_card, daq_list.DeviceID(1), "ao2", "Voltage"); % Z
addoutput(NI_card, daq_list.DeviceID(1), "ao3", "Voltage"); % light

X_value = 0;
Y_value = 0;
Z_value = 0;
Light_value = 0;

CheckMaxAndSendToNI(NI_card,X_value, Y_value, Z_value, Light_value); % initialisation à 0 V

% User_designed function

% while 0==0
%     while Y_value > -10
%         Y_value = Y_value - 1;
%         CheckMaxAndSendToNI(NI_card,X_value, Y_value, Z_value, Light_value); % initialisation à 0 V
%         pause(0.05);
%     end
%     while Y_value < 10
%         Y_value = Y_value + 1;
%         CheckMaxAndSendToNI(NI_card,X_value, Y_value, Z_value, Light_value); % initialisation à 0 V
%         pause(0.05);
%     end
% end    

while 0==0
    while Y_value > -10
        Y_value = Y_value - 1;
        CheckMaxAndSendToNI(NI_card,X_value, Y_value, Z_value, Light_value); % initialisation à 0 V
        pause(0.05);
    end
    while Y_value < 10
        Y_value = Y_value + 1;
        CheckMaxAndSendToNI(NI_card,X_value, Y_value, Z_value, Light_value); % initialisation à 0 V
        pause(0.05);
    end
end    

%%


CheckMaxAndSendToNI(NI_card,0, 0, 0, 0); % initialisation à 0 V

%%

function CheckMaxAndSendToNI(NI_card,X_value, Y_value, Z_value, L_value)

if X_value < -10
    X_value = -10;
end
if X_value > 10
    X_value = 10;
end

if Y_value < -10
    Y_value = -10;
end
if Y_value > 10
    Y_value = 10;
end

if Z_value < 0
    Z_value = 0;
end
if Z_value > 10
    Z_value = 10;
end

write(NI_card,[X_value, Y_value, Z_value, L_value]);
    
end
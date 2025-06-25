function MW_Gen = Connect_RF()
global TestWithoutHardware RF_Address
% It seems that I could upgrade directly VISA_Instrument to visadev 

if ~TestWithoutHardware
    
    try
        if contains(RF_Address,'TCPIP')
            MW_Gen = VISA_Instrument(RF_Address);
        elseif contains(RF_Address,'GPIB')
            MW_Gen = visadev(RF_Address);
        end
        MW_Gen.Write('FREQ:MODE CW');%RF mode = continuous
    catch
        disp('Unable to connect to RF generator');
    end    
    
else    
    MW_Gen = NaN;
end

end

%% Problèmes rencontrés
%%- Enlever parefeu
%%- Mettre Generateur en adresse statique avec une adresse IP (129.175.56.95) et un masque
%%de sous reseau de type 255.255.255.0.
%%Dans les paramètres du reseau sur l'ordi, dans les paramètres IPv4 :
%%adresse IP, choisir une adresse ip de type '129.175.56.XX', qui a les 3
%%même premiers chiffres que le générateur pour être dans le même segment
%%de réseau'. Masque : 255.255.255.0, passerelle =ip du générateur, serveur
%%DNS préféré = ip du générateur, serveur DNS auxiliaire = ne rien mettre.


function smb = Connect_RF()
global TestWithoutHardware RF_Address

if ~TestWithoutHardware
    
    try
        smb = VISA_Instrument(RF_Address);
        smb.Write('FREQ:MODE CW');%RF mode = continuous
    catch
        disp('Unable to connect to RF generator');
    end    
    
else    
    smb = NaN;
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


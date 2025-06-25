function WriteSMB(stringIn)
global MW_Gen

maxRetries = 2; % During long acquisitions, the connexion to the MW generator can stop. This code is here to disconnect then connect again to the generator so that the acquisition can continue
for attempt = 1:maxRetries
    try
        MW_Gen.Write(stringIn);
        break; % Exit loop if successful
    catch ME
        if attempt == maxRetries
            disp(['Failed to send command to RF generator after ' num2str(maxRetries) ' attempts:']);
            disp(ME.message);
            disp('Trying to disconnect RF generator');
            try
                if ismethod(MW_Gen, 'Close') % this function does not exist for visadev
                    MW_Gen.Close();
                end
                clear MW_Gen
            catch
                disp('Unable to disconnect to RF generator');
            end
            try
                MW_Gen = Connect_RF();
                MW_Gen.Write(stringIn);
            catch
                disp('Unable to reconnect to RF generator');
            end

        else
            pause(0.01); % Wait before retrying
        end
    end
end

end
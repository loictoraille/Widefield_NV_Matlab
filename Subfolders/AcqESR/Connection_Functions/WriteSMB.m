function WriteSMB(stringIn)
global smb

maxRetries = 2;
for attempt = 1:maxRetries
    try
        smb.Write(stringIn);
        break; % Exit loop if successful
    catch ME
        if attempt == maxRetries
            disp('Failed to send command to RF generator after %d attempts: %s', maxRetries, ME.message);
            disp('Trying to disconnect RF generator');
            try
                smb.Close();
            catch
                disp('Unable to disconnect to RF generator');
            end
            try
                smb = Connect_RF();
                smb.Write(stringIn);
            catch
                disp('Unable to reconnect to RF generator');
            end

        else
            pause(0.01); % Wait before retrying
        end
    end
end

end
function [TestWithoutHardware, RF_Address, Data_Path, CameraChoice] = readConfigFile(filename)
    % Initialize default values
    TestWithoutHardware = 0;
    RF_Address = '';
    Data_Path = '';
    CameraChoice = '';

    % Open the file
    fid = fopen(filename, 'r');
    if fid == -1
        error('Could not open file %s for reading.', filename);
    end

    % Read the file line by line
    while ~feof(fid)
        % Read the key
        key = strtrim(fgetl(fid));
        if ~ischar(key) || isempty(key)
            continue; % Skip empty lines
        end
        
        % Read the value
        value = strtrim(fgetl(fid));
        if ~ischar(value) || isempty(value)
            continue; % Skip empty lines
        end

        % Assign the value to the corresponding variable
        if contains(key,'TestWithoutHardware')
                TestWithoutHardware = str2double(value);
        elseif contains(key,'RF_Address')
                RF_Address = value;
        elseif contains(key,'Data_Path')
                Data_Path = strrep(value,'/','\');
        elseif contains(key,'CameraChoice')
                CameraChoice = value;
        end

        % Skip the next empty line
        if ~feof(fid)
            fgetl(fid);
        end
    end

    % Close the file
    fclose(fid);
end

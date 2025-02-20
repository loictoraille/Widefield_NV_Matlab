function updateuEyeParameterFile()
    % Define the file name
    fileName = [getPath('Param') 'ESR_uEyeIniParameters/Parameter.ini'];

    % Read the file
    fileData = fileread(fileName);

    % Update the values
    fileData = regexprep(fileData, 'Trigger delay=\d+', 'Trigger delay=0');
    fileData = regexprep(fileData, 'Trigger input=\d+', 'Trigger input=1');

    % Write the updated data back to the file
    fid = fopen(fileName, 'w');
    fwrite(fid, fileData);
    fclose(fid);
end
function NextFileFunction(~,~)
global Ftot M AcqParameters CameraType

panel = guidata(gcbo);

load([getPath('Param') 'FileInfo.mat'],'-mat','Data_Path')

folderPath = Data_Path;
fileName = panel.fname.String;

% Extract the base name and the number from the file name
    [~, baseName, ~] = fileparts(fileName);
    numStr = regexp(baseName, '\d+$', 'match');
    baseName = strrep(baseName,' ','');
    
    if isempty(numStr)
        disp('The file name does not end with a number.');
    end
    
    % Convert the number string to a number
    num = str2double(numStr{1});
    
    % Generate the new file name with the incremented number
    newNum = num + 1;
    newFileName = [baseName(1:end-length(numStr{1})), num2str(newNum), '.mat'];
    
    % Check if the new file exists in the folder
    exists = isfile(fullfile(folderPath, newFileName));

if exists
    pname = Data_Path;
    fname = newFileName;
    OpenFileCommonScript;
end

end
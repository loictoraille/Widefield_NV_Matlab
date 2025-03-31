function CheckAndUpdateFitParameters(File,String_Default_Value)

% Function to load FitParameters and update it to the current list of parameters, adding default when a parameter is absent
% The goal is that the user only needs to copy paste their parameter file and keep their configuration this way

if isempty(File) || (~isempty(File) && ~ismember('FitParameters', who('-file',File)))
    load([getPath('Param') 'FitParameters.mat']);    
else
    load(File,'FitParameters')
end

% Get the full path to the grandparent folder
[parentPath, ~, ~] = fileparts(getPath('Main'));
[grandparentPath, ~, ~] = fileparts(parentPath);

fieldNames = {'VisuFit'};

defaultValues = {1};

% Loop through each field name
for i = 1:length(fieldNames)
    fieldName = fieldNames{i};
    if strcmp(String_Default_Value,'default')
        defaultValue = defaultValues{i};
    else
        defaultValue = NaN;
    end
    
    % Check if the field exists in the structure
    if ~isfield(FitParameters, fieldName)
        % If the field does not exist, create it and assign the default value
        FitParameters.(fieldName) = defaultValue;
    end
end

if isempty(File)
    save([getPath('Param') 'FitParameters.mat'],'FitParameters');    
else
    save(File,'FitParameters','-append')
end

end
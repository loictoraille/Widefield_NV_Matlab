function mycam = ImaqInit()

% Check if we can check out a license for the Image Acquisition Toolbox.
canCheckoutLicense = license('checkout', 'Image_Acquisition_Toolbox');

% Check if the Image Acquisition Toolbox is installed.
isToolboxInstalled = exist('videoinput', 'file');

if ~(canCheckoutLicense && isToolboxInstalled)
    % Toolbox could not be checked out or toolbox is not installed.
    error(message('imaq:obj2mfile:invalidToolbox'));
end

% Device Properties.
adaptorName = 'gentl';
deviceID = 1;
vidFormat = 'Mono12';
tag = '';

% Search for existing video input objects.
existingObjs1 = imaqfind('DeviceID', deviceID, 'VideoFormat', vidFormat, 'Tag', tag);

toolboxstruct = imaqhwinfo;

if isempty(toolboxstruct.InstalledAdaptors)
    disp('You need to install the correct GenICam and Generic video toolbox support packages')
else
    if isempty(existingObjs1)
        % If there are no existing video input objects, construct the object.
        vidObj1 = videoinput(adaptorName, deviceID, vidFormat);
    else
        % There are existing video input objects in memory that have the same
        % DeviceID, VideoFormat, and Tag property values as the object we are
        % recreating. If any of those objects contains the same AdaptorName
        % value as the object being recreated, then we will reuse the object.
        % If more than one existing video input object contains that
        % AdaptorName value, then the first object found will be reused. If
        % there are no existing objects with the AdaptorName value, then the
        % video input object will be created.

        % Query through each existing object and check that their adaptor name
        % matches the adaptor name of the object being recreated.
        for i = 1:length(existingObjs1)
            % Get the object's device information.
            objhwinfo = imaqhwinfo(existingObjs1{i});
            % Compare the object's AdaptorName value with the AdaptorName value
            % being recreated.
            if strcmp(objhwinfo.AdaptorName, adaptorName)
                % The existing object has the same AdaptorName value as the
                % object being recreated. So reuse the object.
                vidObj1 = existingObjs1{i};
                % There is no need to check the rest of existing objects.
                % Break out of FOR loop.
                break;
            elseif(i == length(existingObjs1))
                % We have queried through all existing objects and no
                % AdaptorName values matches the AdaptorName value of the
                % object being recreated. So the object must be created.
                vidObj1 = videoinput(adaptorName, deviceID, vidFormat);
            end %if
        end %for
    end %if


mycam = vidObj1;

end


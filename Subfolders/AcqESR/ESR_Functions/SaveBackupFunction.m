function SaveBackupFunction(hobject,~)

set(hobject,'ForegroundColor',[0,1,0]);
drawnow;

tic
disp('saving backup...')

load([getPath('Param') 'AcqParameters.mat']);
Data_Path = AcqParameters.Data_Path;

nomSave = NameGen(Data_Path,'ESR_WideField',1);

% List of variables to save
varList = {'M', 'Ftot', 'CenterF_GHz', 'Width_MHz', 'NPoints', 'Acc', ...
           'MWPower', 'T', 'ExposureTime', 'FrameRate', 'PixelClock', ...
           'RANDOM', 'AcqParameters', 'CameraType', 'AcquisitionTime_minutes', 'Lum_Current'};

load([Data_Path 'backup.mat'],varList{:}); % slower than copy paste, but compresses the files
save([Data_Path nomSave '.mat'], varList{:});

disp(['backup saved compressed as ' nomSave '.mat']);

toc

set(hobject,'ForegroundColor',[0,0,0]);
drawnow;

end


function CompressFunction(hobject,~)

set(hobject,'ForegroundColor',[0,0,1]);
drawnow;

tic
disp('saving compressed file...')

panel=guidata(gcbo);
DataPath = panel.DataPath.String;
nomSave = panel.fname.String;
nomSave = nomSave(7:end);

% List of variables to save
varList = {'M', 'Ftot', 'CenterF_GHz', 'Width_MHz', 'NPoints', 'Acc', ...
           'MWPower', 'T', 'ExposureTime', 'FrameRate', 'PixelClock', ...
           'RANDOM', 'AcqParameters', 'CameraType', 'AcquisitionTime_minutes', 'Lum_Current'};

load([DataPath nomSave '.mat'],varList{:}); % slower than copy paste, but compresses the files

if ~exist('Lum_Current','var')
    Lum_Current = M(:,:,1);
end

% varListFast = [varList, '-v7.3', '-nocompression'];
% save([DataPath nomSave '.mat'],varListFast{:}); % to save fast and heavy

save([DataPath nomSave '.mat'], varList{:});

disp(['filed saved compressed as ' nomSave '.mat']);

toc

set(hobject,'ForegroundColor',[0,0,0]);
drawnow;

end
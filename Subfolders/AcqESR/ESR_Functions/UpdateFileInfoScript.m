%% Update FileInfo

if ~exist('Data_Path','var')
    Data_Path = pname;
end

save([getPath('Param') 'FileInfo.mat'],'fname','pname','Data_Path');
UpdateFileInfo({{T,'T'},{Acc,'NumSweep'},{AcqParameters,'AcqParameters'},...
 {CameraType,'CameraType'},{AcquisitionTime_minutes,'AcquisitionTime_minutes'}});
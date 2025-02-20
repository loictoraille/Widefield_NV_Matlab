function OpenFileFunction(~,~)
global Ftot M AcqParameters CameraType Lum_Current

load([getPath('Param') 'FileInfo.mat'],'-mat','Data_Path')

if exist('Data_Path','var')
    [fname,pname] = uigetfile('*.mat','Load file',Data_Path); 
else
    [fname,pname] = uigetfile('*.mat','Load file');
end

OpenFileCommonScript;

end
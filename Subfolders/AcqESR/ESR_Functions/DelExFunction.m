function DelExFunction(hobject,~)
global M Ftot

% import data 

panel=guidata(gcbo);

load([getPath('Param') 'FileInfo.mat'],'fname','pname','Data_Path');

if fname ~= 0
    ImportDataScript; 
    LoadParamFromAcqParamScript;
    nomSave = AcqParameters.nomSave; % had to get it out to prevent the bad name generation
end

% manipulate M & Ftot

Ftot = Ftot(2:end-1);
M = M(:,:,2:end-1);

% update AcqParameters

AcqParameters.DelEx = 1;

% change name

NewSaveName = [fname '_DelEx'];

% save new file

save([Data_Path NewSaveName],'M','Ftot','CenterF_GHz','Width_MHz','NPoints','Acc','MWPower','T','ExposureTime',...
    'FrameRate','PixelClock','RANDOM','AcqParameters','CameraType','AcquisitionTime_minutes');

% opens new file

pname = Data_Path;
fname = NewSaveName;

OpenFileCommonScript;

end
function [ESRMatrix, v_MHz, pname, fname, NumSweep, AcqParameters, CameraType, AcquisitionTime_minutes] = openEsrImg(DataPath,FileName)   

if nargin == 1
[fname,pname] = uigetfile('*.mat','Load file',DataPath);
elseif nargin == 2
fname = FileName;
pname = DataPath;
else    
[fname,pname] = uigetfile('*.mat','Load file');
end

list = {'M','Ftot','Acc','AcqParameters','CameraType', 'AcquisitionTime_minutes'};

for i=1:numel(list)
    load([pname fname],list{i});
    if ~exist(list{i})
        if strcmp(list{i},'CameraType')
            CameraType = 'uEye';
        else
            eval([list{i} ' = NaN;']);
        end
    end
end

ESRMatrix = M;
v_MHz = 10^3*Ftot; % converting the frequency from GHz to MHz
NumSweep = Acc;

end
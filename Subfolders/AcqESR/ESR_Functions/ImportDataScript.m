%% Import Data

file=[pname fname];                             

if contains(fname, '.mat')
    fname = fname(1:end-4);
end

variableInfo = who('-file',file);
listVariables = {'M','Ftot','T','Acc','AcqParameters', 'CameraType', 'AcquisitionTime_minutes', 'Lum_Current','Lum_WithLightAndLaser'};
for i=1:numel(listVariables)
    if ismember(listVariables{i},variableInfo)
        load(file,listVariables{i})
    end
end  

if ~exist('T','var')
    T = NaN;
end

if ~exist('Lum_Current','var') || (exist('Lum_Current','var') && isempty(Lum_Current)) || (exist('Lum_Current','var') && ~isempty(Lum_Current) && any(size(M(:,:,1))~=size(Lum_Current)))
    Lum_Current = M(:,:,1);
end

if ~exist('Lum_WithLightAndLaser','var') || (exist('Lum_WithLightAndLaser','var') && isempty(Lum_WithLightAndLaser)) || (exist('Lum_WithLightAndLaser','var') && ~isempty(Lum_WithLightAndLaser) && any(size(M(:,:,1))~=size(Lum_WithLightAndLaser)))
    Lum_WithLightAndLaser = M(:,:,1);
end

if ~exist('AcqParameters','var')
    AcqParameters.Save = 1;
end


list2 = {'MWPower','ExposureTime','FrameRate', 'PixelClock'};
for i=1:numel(list2)
    if ~isfield(AcqParameters,list2{i})
        load(file,list2{i})
        eval(['AcqParameters.' list2{i} ' = ' list2{i} ';']);
    end
end  

if ~isfield(AcqParameters,'AOILEVEL') || (isfield(AcqParameters,'AOILEVEL') && isnan(AcqParameters.AOILEVEL))
    AcqParameters.AOILEVEL = 1;
end

if ~isfield(AcqParameters,'FCenter') 
    load(file,'CenterF_GHz');
else
    CenterF_GHz = AcqParameters.FCenter;
end

if ~isfield(AcqParameters,'FSpan')
    load(file,'Width_MHz');
else
    Width_MHz = AcqParameters.FSpan;
end

if ~isfield(AcqParameters,'DisplayLight') || (isfield(AcqParameters,'DisplayLight') && isnan(AcqParameters.DisplayLight))
    AcqParameters.DisplayLight = 0;
end

if isempty(CameraType)
    CameraType = 'uEye';
end

if ~exist('AcquisitionTime_minutes','var')
    AcquisitionTime_minutes = NaN;
end

if ~isfield(AcqParameters,'CalibUnit_str')
    AcqParameters.CalibUnit_str = 'pixel';
    AcqParameters.PixelCalib_nm = '500';
end

if ~isfield(AcqParameters,'AOI')
    [AcqParameters.AOI.Height,AcqParameters.AOI.Width,~] = size(M);
end    

if ~isfield(AcqParameters,'ExposureUnit') || (isfield(AcqParameters,'ExposureUnit') && isnan(AcqParameters.ExposureUnit))
    AcqParameters.ExposureUnit = ''; % probably seconds but who knows
end    

CheckAndUpdateAcqParameters(file,'none');

load([getPath('Param') 'FitParameters.mat'],'FitParameters');

CheckAndUpdateFitParameters(file,'default');

NumPeaks = FitParameters.NumPeaks;

FitParameters.DataPath = pname;
if FitParameters.TreatedPathAutoChange == 1
    FitParameters.TreatedDataPath = [pname 'Fit_Results/'];
end

[wM,hM,~] = size(M);
SPX1 = Ftot*1000;%in MHz
SPY1 = squeeze(M(round(wM/2),round(hM/2),:));
UpdateBoundaryParameters(SPX1,SPY1,FitParameters);


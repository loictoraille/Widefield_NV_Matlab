
clearvars; clear global
addpath(genpath('Subfolders'));

load([getPath('Param') 'FitParameters.mat'],'FitParameters');
ReadFitParameters;

[FNames,pName] = uigetfile('*.mat','Select all the files you want to fit', 'MultiSelect','on',DataPath);

if string(class(FNames)) == "char" % to deal with the case where there is only 1 file
    fName = FNames;
    FitESR_fullAuto(pName,fName);
else
    for i = 1:length(FNames)
        disp(['Fitting file ' num2str(i) ' of ' num2str(length(FNames)) '.'])
        fName = FNames{i};
        FitESR_fullAuto(pName,fName);    
    end
end


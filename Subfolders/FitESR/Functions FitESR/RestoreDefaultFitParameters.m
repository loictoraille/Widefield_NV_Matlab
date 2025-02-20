function RestoreDefaultFitParameters(~,~)

load([getPath('StartFile') 'DefaultFitParameters.mat'],'FitParameters');

LoadFitParam(FitParameters);

end
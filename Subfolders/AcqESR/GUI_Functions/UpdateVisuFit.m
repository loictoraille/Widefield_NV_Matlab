function UpdateVisuFit(~,~)

load([getPath('Param') 'FitParameters.mat'],'FitParameters');

panel=guidata(gcbo);

FitParameters.VisuFit = panel.VisuFit.Value;

save([getPath('Param') 'FitParameters.mat'],'FitParameters');

end
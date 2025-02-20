function Input_Peaks(~,~)
global M Ftot

load([getPath('Param') 'FitParameters.mat'],'FitParameters')

panel=guidata(gcbo);

if FitParameters.FitMethod == 7 || FitParameters.FitMethod == 8
    NumPeaks = 2;
    panel.NumPeaksChoice.SelectedObject = panel.NumPeaks2;
else
    NumPeaks = str2double(panel.NumPeaksChoice.SelectedObject.String);
end
NumCompFittofield = floor(NumPeaks/2);

panel.NumCompFittofield.String = string(NumCompFittofield);  

FitParameters.NumPeaks = NumPeaks;
FitParameters.NumCompFittofield = NumCompFittofield;

[wM,hM,~] = size(M);
SPX1 = Ftot*1000;%in MHz
SPY1 = squeeze(M(round(wM/2),round(hM/2),:));
UpdateBoundaryParameters(SPX1,SPY1,FitParameters);

UpdateFitParam()
UpdateFit();

end

function ChangeTreatedDataPath(~,~)

panel=guidata(gcbo);

pname = uigetdir();
pname(strfind(pname,'\')) = '/';

TreatedDataPath = [pname '/Fit_Results/'];

panel.TreatedDataPath.String = TreatedDataPath;
panel.TreatedPathAutoChange.Value = 0;

UpdateFitParam();

end
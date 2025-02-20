function SwitchAutoPath(~,~)

panel=guidata(gcbo);

if panel.TreatedPathAutoChange.Value == 1
     panel.TreatedDataPath.String = [panel.DataPath.String 'Fit_Results/'];
end

UpdateFitParam();

end



function UpdatePrefixName(~,~)

panel = guidata(gcbo);

if strcmp(panel.FileNamePrefixChoice.SelectedObject.String, 'Base+Date')
    panel.FileNamePrefix.String = [date '-ESR-WideField'];
else
    panel.FileNamePrefix.String = panel.FileNameUserPrefix.String;
end

UpdateAcqParam;

end
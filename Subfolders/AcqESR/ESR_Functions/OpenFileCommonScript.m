

f = gcf;

panel=guidata(gcbo);

if panel.Fit.Value
    ind_fit = 1;
else
    ind_fit = 0;
end

panel = ToggleOffButtons();


f.Name = ['ESR Treatment: ' fname];

if pname ~= 0
    Data_Path = pname;
end

panel.fname.String = ['File: ' fname(1:end-4)];

%uicontrol('Parent',tab1,'Style','text','tag','nameFile','units','normalized','FontSize',16,'HorizontalAlignment','left','FontWeight','bold','Position',[0.01 0.21 0.24 0.05],'String',['File: ' AcqParameters.nomSave]);


if fname ~= 0
    UpdateFileInfo({{Data_Path,'Data_Path'}});
    
    ImportDataScript;
    UpdateFileInfoScript;
    
    UpdateGraphique_openESR;
end

if ind_fit
    panel.Fit.Value = 1;
    panel.Fit.ForegroundColor = [0,1,0];
    panel = CreateFit();
end
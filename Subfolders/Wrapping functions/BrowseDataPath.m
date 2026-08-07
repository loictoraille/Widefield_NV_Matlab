function BrowseDataPath(Start_Path)

panel = guidata(gcbo);

folder = uigetdir(Start_Path); folder = [folder '\'];

if folder ~= 0
    UpdateConfig('Data_Path', folder);
end

panel.ConfigDataPath.String = folder;

end
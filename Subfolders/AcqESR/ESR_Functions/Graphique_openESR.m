%% Create Graphique

clear f
close all

% screensize = get(groot,'Screensize');
% wS = screensize(3);
% hS = screensize(4);
% f = figure('Name',fname,'Position',[floor(wS/200) floor(hS/20) wS-1.8*floor(wS/200) hS-2.8*floor(hS/20)]);%create figure handle
f = figure('Name',['ESR Treatment: ' fname],'CloseRequestFcn',@CloseReqOpenESR);%create figure handle
if isprop(f,'WindowState')
    f.WindowState = 'maximized';
end
tgroup = uitabgroup(f);
tab1 = uitab(tgroup,'Title','ESR');
tab_fitparam = hguitab(tgroup,'Title','Fit Parameters');
tgroup.SelectedTab = tab1;

Tab1_OpenESR;%Tab1 elements
Tab_FitParam;

Total_handles=guihandles(f);
guidata(f,Total_handles);
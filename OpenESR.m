
clearvars; clear global
addpath(genpath('Subfolders'));addpath(genpath(getPath('Main')));
clear f     % in case a previous figure stayed open
close all   % be careful, if it closes a window with a closereq, it can do stuff here so it's better to do it a the beginning

%% Parameters
% Optional, is stored in FileInfo and will be updated to first file opened

[~,~, Data_Path, ~] = readConfigFile('Config.txt');

%% Execute
global Ftot M AcqParameters CameraType Lum_Current

% Starting File to simplify process
pname = getPath('StartFile');
fname = '21-Mar-2022-ESR_WideField-22.mat';

ImportDataScript;
UpdateFileInfoScript;    

Graphique_openESR;   

UpdateGraphique_openESR;

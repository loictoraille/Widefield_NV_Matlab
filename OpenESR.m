
clearvars; clear global
addpath(genpath('Subfolders'));addpath(genpath(getPath('Main')));

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


clearvars; clear global
addpath(genpath('Subfolders'));addpath(genpath(getPath('Main')));

%% 
DataPath = 'C:\Users\ADM_TORAILLEL\Documents\Loïc 11-02-22\Manips\NV\Stage Boubacar\';

%% Visualize fit results from a FitESR treated data file

[fname,pname] = uigetfile('*.mat','Load file',DataPath);

VisuFitScript;

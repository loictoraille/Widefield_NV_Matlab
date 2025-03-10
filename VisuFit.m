
clearvars; clear global
addpath(genpath('Subfolders'));addpath(genpath(getPath('Main')));

%% 
DataPath = 'C:\Users\Raman\Documents\Data_NV\';

%% Visualize fit results from a FitESR treated data file

[fname,pname] = uigetfile('*.mat','Load file',DataPath);

VisuFitScript;

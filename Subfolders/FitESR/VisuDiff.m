%Visualize fit results from a FitESR treated data file
% Check what this does, probably seems to make the difference between two files
clearvars
close all
%%
addpath('Functions FitESR')
DataPath = 'C:/Users/Mayeul Chipaux/Documents/Data/SQUIF/Data traitées/';

% figVisu = figure('Name','Visualisation Fit','Position',[700 350 1000 400]);%create figure handle
% movegui(figVisu,'center')

% tgroup = uitabgroup(figVisu);
% tab1 = uitab(tgroup,'Title','Visu');
% tgroup.SelectedTab = tab1;

[fname,pname] = uigetfile('*.mat','Load file PLUS',DataPath);
SpPlus = load([pname fname]);

[fname,pname] = uigetfile('*.mat','Load file MINUS',DataPath);
SpMinus = load([pname fname]);

%%
FitTot = SpPlus.FitTot;

B_renorm = SpPlus.B_renorm - SpMinus.B_renorm;
B0 = SpPlus.B0 - SpMinus.B0;
fname = [SpPlus.fname(1:end-5), SpPlus.fname(end-4), 'MINUS', SpMinus.fname(end-4), '.mat'];

%%
Cropping_Coord = SpPlus.Cropping_Coord;
ESRMatrix = SpPlus.ESRMatrix - SpMinus.ESRMatrix;
size_pix = SpPlus.size_pix;
NumComp = SpPlus.NumComp;
Calib_Dist = SpPlus.Calib_Dist;
FitMethod = SpPlus.FitMethod;
SaveName = SpPlus.SaveName;

%%
Calib_Dist = 0; % can be useful to turn off the calib to choose the coordinates for renormalization
ColorRescale = 1; % to modify the colorscale, 0 is natural min max, 1 is mean +- StdforRescalingTeslas*Standard Deviation
StdforRescalingTeslas = 5;
PlotScale = PlotParameters(FitTot, B_renorm, ColorRescale, StdforRescalingTeslas , NumComp);
figField = plotField(FitTot, B_renorm, B0, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%%
[h,w,~] = size(ESRMatrix);
ix = round(w/2); CropOn = 1; Calib_Dist = 1;

v_MHz = SpPlus.v_MHz;
plotESRImgXV(ESRMatrix, fname, ix, v_MHz, CropOn, Cropping_Coord, Calib_Dist, size_pix)

%%
TabVisuFit;

%load('/Users/antoinehilberer/Documents/MATLAB/Stage M2/FitESR 19-04-19/Data traitées/03-May-2019-ESR_WideField-20-Fit-Binning1.mat');
Start_VisuFit(BinThr,ClearFFT,Detrending_Factor,ESRMatrix,FitTot,NumComp,IsPair,Smoothing_Factor,VarWidths,size_pix,v_MHz,wcrop,x_start,x_stoptoend,x_um,y_start,y_stoptoend);
set(gcf,'WindowButtonUpFcn',{@mouseclick,ESRMatrix,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT});


function mouseclick(object,eventdata,ESRMatrix,v_MHz,FitTot,BinThr,VarWidths,NumComp,IsPair,Smoothing_Factor,Detrending_Factor,ClearFFT)
        C=get(gca,'CurrentPoint'); % Point Coordinate
        xpix = floor(C(1,1))
        ypix = floor(C(1,2))
        jx = squeeze(FitTot(ypix,xpix,:));
        [spectre,~] = extractEsrThr(ESRMatrix, xpix, ypix, BinThr);
        spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT);
        Update_VisuFit(v_MHz,jx, spectre, VarWidths, NumComp, IsPair);
end
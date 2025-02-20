% function FitESR_fullAuto(path_name,file_name)

%% Parameters + use as a script 
%Possible to comment the 'function...' line and define path_name and file_name directly or using the usual function
%In that case, also clearvars and addpath
clearvars; clear global
addpath(genpath('Subfolders'));

load([getPath('Param') 'FitParameters.mat'],'FitParameters');
ReadFitParameters;

[ESRMatrix, v_MHz, path_name, file_name, NumSweep, AcqParameters, CameraType, AcquisitionTime_minutes] = openEsrImg(DataPath);

%% Open file

[ESRMatrix, v_MHz, pname, fname, NumSweep, AcqParameters, CameraType, AcquisitionTime_minutes] = openEsrImg(path_name,file_name);

[h,w,~] = size(ESRMatrix);
[x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);
[x_um, y_um] = xyAxes_um(wcrop,hcrop,size_pix); % they are defined here to add them to the saved file

%% Full Fit
disp(file_name)
[FitTot, BinMap] = FitCimg(ESRMatrix, v_MHz,  Cropping_Coord, FitParameters);

%% Reconstruct Bfield and prepare for plot
clear B0
if NumComp == 1;NumCompFittofield = 1;end
SaveName = CreateSaveName(NumComp,Cropping_Coord,BinThr,VarWidths,Smoothing_Factor,Detrending_Factor,ClearFFT,TrackingFit,fname,FitMethod,RemPositive);
B = fittofield(FitTot, NumComp, NumCompFittofield);
[B,~] = DefineCorrectPermutation(B,CorrectPermutation); 
[B_renorm, B0(:,:,1), B0(:,:,2), B0(:,:,3)] = Renormalize(Renormalize_Parameters, B);
PlotScale = PlotParameters(FitTot, B_renorm, ColorRescale, StdforRescalingTeslas, NumComp);

%% Plot Magnetic field Map

figField = plotField(FitTot, B_renorm, B0, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Save

pStart = LoadPStart([getPath('Param') 'PstartFitBin'] NumComp, VarWidths, IsPair);% to add it in the saved file

SaveName = CreateSaveName(NumComp,Cropping_Coord,BinThr,VarWidths,Smoothing_Factor,Detrending_Factor,ClearFFT,TrackingFit,fname,FitMethod,RemPositive);
save([TreatedDataPath SaveName]);
saveas(figField,[TreatedDataPath SaveName(1:end-4) '-Magnetic field Map.jpg'],'jpeg');

close(figField);
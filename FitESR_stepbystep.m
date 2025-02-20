
%% Initialize, parameters and open file

clearvars ;
addpath(genpath('Subfolders'));addpath(genpath(getPath('Main')));

load([getPath('Param') 'FitParameters.mat'],'FitParameters');
ReadFitParameters;

[ESRMatrix, v_MHz, pname, fname, NumSweep, AcqParameters] = openEsrImg(DataPath);

[Calib_Dist,size_pix] = UpdateCalibParameters(AcqParameters,Calib_Dist,size_pix);

[h,w,~] = size(ESRMatrix);
[x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);
[x_um, y_um] = xyAxes_um(wcrop,hcrop,size_pix);

%% Plot the photoluminescence image at a given frequency

iv = 5; CropOn = 1; Calib_Dist = 0; % choose to plot in µm or pixels, cropped or not
titleFIG = 'PL/PL0';
% titleFIG = 'Photoluminescence (a.u.)';

plotESRImgXY(ESRMatrix, fname, iv, CropOn, Cropping_Coord, Calib_Dist, size_pix, titleFIG); 

% saveas(gcf,[TreatedDataPath '\' fname(1:end-4) '-Luminescence image.jpeg'],'jpeg');

%% Plot 6 PL/PL0 images at a given frequency

iv = 1; %this value doesn't matter here
CropOn = 1; Calib_Dist = 0; % choose to plot in µm or pixels, cropped or not
plotESRImgXY_PL_PL0_6(ESRMatrix, fname, iv, CropOn, Cropping_Coord, Calib_Dist, size_pix); %function to plot six images

%% Save raw data as a text file
DataSaveName = 'ESRMatrix'; % change to what you want
save(DataSaveName,'ESRMatrix','-ascii');

%% Save one image out of raw data in a text file
DataSaveName = 'ESRMatrix'; % change to what you want
indexmat = 4; % num of frequency to save

DataSaveName = [DataSaveName '_freqnum' num2str(indexmat)]; 
Image = ESRMatrix(:,:,indexmat); % the last number is the index of the image
save(DataSaveName, 'Image','-ascii');

%% Fit ESR at a specific location
%Set up parameters in FitParameters.mat
PlotpStart = 1; 
% if UsePstart == 0;PlotpStart = 0; end

ix = round(wcrop/2);iy = round(hcrop/2); % in pixels   
% ix = 30; iy = 25;
[spectre, BinOut] = extractEsrThr(ESRMatrix, ix+x_start-1, iy+y_start-1, BinThr);
spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive);

clear pStart % don't hesitate to comment this line
if ~exist('pStart','var')
    pStart = LoadPStart([getPath('Param') 'PstartFit'],NumComp, VarWidths, IsPair);
end % use the saved pStart in case of loading

isPlot = true;
pStart = lastUpdatePstart(spectre, pStart);
jx = fitOneEsr(v_MHz, spectre, pStart, isPlot, FitParameters);
if isPlot
    Ffit = DefJacFw(v_MHz, VarWidths, NumComp, IsPair); % necessary for the plot
    PlotFitParam(v_MHz, spectre, ix, iy, x_um, y_um, fname, Ffit(pStart), Ffit(jx), BinThr, BinOut, Calib_Dist, FitMethod, PlotpStart);
end

CheckJx(ix, iy, jx, NumComp, IsPair);

B = fittofield(jx, NumComp, NumCompFittofield);

%% Overwrite the fit starting point with the fit results
WritePstartFit(jx, v_MHz, NumComp, IsPair, VarWidths, 'PstartFit'); 

%% Define the CorrectPermutation for B
% only works if NumComp ~= 1 
[B,Perm] = DefineCorrectPermutation(B); % need to paste the resulting correctpermutation in the parameters afterwards

%% Fit on whole Cimg
[FitTot, BinMap] = FitCimg(ESRMatrix, v_MHz,  Cropping_Coord, FitParameters);

%% Reconstruct Bfield and prepare for plot
clear B0
if NumComp == 1;NumCompFittofield = 1;end
SaveName = CreateSaveName(NumComp,Cropping_Coord,BinThr,VarWidths,Smoothing_Factor,Detrending_Factor,ClearFFT,TrackingFit,fname,FitMethod,RemPositive);
B = fittofield(FitTot, NumComp, NumCompFittofield);
[B,Perm] = DefineCorrectPermutation(B,CorrectPermutation); 
[B_renorm, B0(:,:,1), B0(:,:,2), B0(:,:,3)] = Renormalize(Renormalize_Parameters, B);
PlotScale = PlotParameters(FitTot, B_renorm, ColorRescale, StdforRescalingTeslas , NumComp);

%% Plot Magnetic field Map
% if ncomp = 1, plots the full fit results
Calib_Dist = 0; % can be useful to turn off the calib to choose the coordinates for renormalization
figField = plotField(FitTot, B_renorm, B0, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Plot Contrast, Width, FFT and Autocorrelation of left peak
% for NumComp=1 and FitMethod=1
figField = plotContrastWidthFFTAutocorLeftPeak(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Plot Photoluminescence, Contrast, Width and Frequency of left peak
% for NumComp=1 and FitMethod=1
figField = plotContrastWidthFrequencyLeftPeak(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Save Contrast of Right Peak and Width of Right Peak

Contrast_RightPeak = FitTot(:,:,2);
Width_RightPeak = FitTot(:,:,6);
save('Contrast', 'Contrast_RightPeak','-ascii');
save('Width', 'Width_RightPeak','-ascii');

%% Plot BinMap

Calib_Dist = 0; % choose to plot in µm or pixels, cropped or not
plotBinningMap(BinMap, fname, CropOn, Cropping_Coord, Calib_Dist, size_pix)

%% Plot contrasts
% warning, this was specifically coded for one situation, need to be generalized
figField = plotContrast(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Plot Center Frequency
% warning, this was specifically coded for one situation, need to be generalized
figField = plotCenterFrequency(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Plot Splittings
% warning, this was specifically coded for one situation, need to be generalized
figField = plotSplittings(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Plot the ESR Map at a given ix value

ix = round(w/2); CropOn = 1; Calib_Dist = 1;
plotESRImgXV(ESRMatrix, fname, ix, v_MHz, CropOn, Cropping_Coord, Calib_Dist, size_pix) 

%% Plot ESR at a specific location
saveESR = 0; %saves ESR in svg, png and data form
secondAxis = 1; %creates second axis with real luminescence on the right
withTitle = 1; %removes title for graphic reasons
FigureSize = 0.85; % choose small size for big text when saving

ix = 33; iy = 32;
% ix = round(wcrop/2);iy = round(hcrop/2); % in pixels 

[spectre, BinOut] = extractEsrThr(ESRMatrix, ix+x_start-1, iy+y_start-1, BinThr);
spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive);
plotESRSp(spectre, ix, iy, v_MHz, x_um, y_um, fname, BinThr, BinOut, Calib_Dist, secondAxis, withTitle, FigureSize, TreatedDataPath, saveESR); 

%% Save

pStart = LoadPStart([getPath('Param') 'PstartFit'],NumComp, VarWidths, IsPair);% to add it in the saved file

SaveName = CreateSaveName(NumComp,Cropping_Coord,BinThr,VarWidths,Smoothing_Factor,Detrending_Factor,ClearFFT,TrackingFit,fname,FitMethod,RemPositive);
save([TreatedDataPath SaveName]);

[~,num_figs] = size(figField);

if num_figs > 1
    for i=1:num_figs
        saveas(figField{i},[TreatedDataPath SaveName(1:end-4) '-FitResults_' num2str(i) '.jpg'],'jpeg');
    end
else
    saveas(figField,[TreatedDataPath SaveName(1:end-4) '-Magnetic field Map.jpg'],'jpeg');
end
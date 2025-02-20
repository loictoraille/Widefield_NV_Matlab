
% OUTDATED, use FitParameters.mat instead

%% Define here all parameters for the FitESR treatment
DataPath = 'C:\Users\ADM_TORAILLEL\Documents\Loïc 11-02-22\Manips\Ilots\Cassandra\DataNV 22032022\';
TreatedDataPath = 'C:\Users\ADM_TORAILLEL\Documents\Loïc 11-02-22\Manips\Ilots\Cassandra\DataNV 22032022\Results\';

NumComp = 1; % number of orientation components / pairs of peaks in the ESR
IsPair = true; % true when there are both left and right peaks for each pair ; NumComp*2*IsPair = number of peaks
NumCompFittofield = 1; % number of components used to reconstruct the magnetic field, 4 is better, 3 if one is noisy

if ~exist('size_pix','var') %only modify size_pix if not included in exp file or false in exp file
    size_pix = 0.463; % µm  
end
Calib_Dist = 1; % 1 is to plot in µm, 0 to plot in pixels

Cropping_Coord = [0 66 40 196 170]; % First number is on or off, then it's either center + size of square (3 numbers),
% or two opposite corners (4 numbers). The numbers are written in the same order as in the plotESRImgXY representation.

FitMethod = 1;  %1 TWO Lorentzians per ESR peak spaced by 3MHz (N15 hyperfine Interaction)
                %2 Not Implemented yet, ONE Lorentzian per ESR peak (no hyperfine interaction)
                %3 Not Implemented yet, THREE Lorentzians per ESR peak spaced by 2MHz(N14 hyperfine Interqction)
                %4 Polynomial Fit                 
                %5 New fit method ; only one which uses the automatic baseline removing script. Beware, it takes more time.
                
UsePstart = 0; % Use PstartFit or do automatic search
AutoBase = 0; % Only works with FitMethod 5: to remove the baseline
                
BinThr = 5; % side of the binning square if BinThr < 100 ; else automatic binning using BinThr as a target luminescence threshold (more info in extractEsrThr)

VarWidths = 1; % authorizes or not a variable width for each ESR peak, most often 1, can be useful as 0 in cases where
% imposing a general width helps to locate a noisy component

CorrectPermutation = [-2,1,3]; % Use [B,Perm] = DefineCorrectPermutation(B); to define the CorrectPermutation
Renormalize_Parameters = [0,5,42,45]; % first number = renormalize mode, second = side of square for renorm, then 
% (optional) is the center pixel coordinates used in renorm mode 1
ColorRescale = 1; % to modify the colorscale, 0 is natural min max, 1 is mean +- StdforRescalingTeslas*Standard Deviation
StdforRescalingTeslas = 5;

Smoothing_Factor = 0; % binning on the frequency values for a given ESR spectrum, can help in case of noise
Detrending_Factor = 0; % removing a general trend in the ESR, the number is the degree of the polynome used
ClearFFT = {0,22,'max'}; % frequency filter in the fourier transform, adapt the freqs (see ClearingFFT) depending on data
TrackingFit = 0; % type of tracking used for the full fit (see FitCimg)
RemPositive = 0; % to remove positive peaks that can occur when it is very noisy
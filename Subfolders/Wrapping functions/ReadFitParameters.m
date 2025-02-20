
% script to load the values written in FitParameters

DataPath = FitParameters.DataPath;
TreatedDataPath = FitParameters.TreatedDataPath;
TreatedPathAutoChange = FitParameters.TreatedPathAutoChange;

NumPeaks = FitParameters.NumPeaks;

smooth_order = FitParameters.smooth_order;
smooth_window = FitParameters.smooth_window;
minDistBetweenPeaks = FitParameters.minDistBetweenPeaks;
height_threshold = FitParameters.height_threshold;
WidthMinToKeep = FitParameters.WidthMinToKeep;

type_function = FitParameters.type_function;
NumComp = FitParameters.NumComp;
IsPair = FitParameters.IsPair;
UsePstart = FitParameters.UsePstart;
AutoBase = FitParameters.AutoBase;
BinThr = FitParameters.BinThr;

Calib_Dist = FitParameters.Calib_Dist;
WithPreset = FitParameters.WithPreset;
size_pix = FitParameters.size_pix;

Smoothing_Factor = FitParameters.Smoothing_Factor;
Detrending_Factor = FitParameters.Detrending_Factor;
ClearFFT = FitParameters.ClearFFT;
TrackingFit = FitParameters.TrackingFit;
RemPositive = FitParameters.RemPositive;
VarWidths = FitParameters.VarWidths;
FitMethod = FitParameters.FitMethod;

% Has been fixed elsewhere
% if FitMethod == 7 || FitMethod == 8 % fast methods that only works for two peaks and only looks for the middle frequency
%     NumPeaks = 2; NumComp = 1;
% end

SMOOTH = FitParameters.SMOOTH;

CorrectPermutation = FitParameters.CorrectPermutation;
Renormalize_Parameters = FitParameters.Renormalize_Parameters;
ColorRescale = FitParameters.ColorRescale;
StdforRescalingTeslas = FitParameters.StdforRescalingTeslas;
NumCompFittofield = FitParameters.NumCompFittofield;

LowerBound = FitParameters.LowerBound;
cmin = FitParameters.cmin;
fmmin = FitParameters.fmmin;
fdmin = FitParameters.fdmin;
fwmin = FitParameters.fwmin;
y0min = FitParameters.y0min;

UpperBound = FitParameters.UpperBound;
cmax = FitParameters.cmax;
fmmax = FitParameters.fmmax;
fdmax = FitParameters.fdmax;
fwmax = FitParameters.fwmax;
y0max = FitParameters.y0max;

full_lower_bound = FitParameters.full_lower_bound;
full_upper_bound = FitParameters.full_upper_bound;
full_lower_bound_auto = FitParameters.full_lower_bound_auto;
full_upper_bound_auto = FitParameters.full_upper_bound_auto;


function LoadFitParam()

load([getPath('Param') 'FitParameters.mat'],'FitParameters');

panel=guidata(gcbo);

panel.DataPath = FitParameters.DataPath;
panel.TreatedDataPath = FitParameters.TreatedDataPath;
panel.TreatedPathAutoChange = FitParameters.TreatedPathAutoChange;

panel.NumPeaks = FitParameters.NumPeaks;

panel.smooth_order = FitParameters.smooth_order;
panel.smooth_window = FitParameters.smooth_window;
panel.minDistBetweenPeaks = FitParameters.minDistBetweenPeaks;
panel.height_threshold = FitParameters.height_threshold;
panel.WidthMinToKeep = FitParameters.WidthMinToKeep;

panel.type_function = FitParameters.type_function;
panel.NumComp = FitParameters.NumComp;
panel.IsPair = FitParameters.IsPair;
panel.UsePstart = FitParameters.UsePstart;
panel.AutoBase = FitParameters.AutoBase;
panel.BinThr = FitParameters.BinThr;

panel.Calib_Dist = FitParameters.Calib_Dist;
WithPreset = FitParameters.WithPreset;
size_pix = FitParameters.size_pix;

Smoothing_Factor = FitParameters.Smoothing_Factor;
Detrending_Factor = FitParameters.Detrending_Factor;
ClearFFT = FitParameters.ClearFFT;
TrackingFit = FitParameters.TrackingFit;
RemPositive = FitParameters.RemPositive;
VarWidths = FitParameters.VarWidths;
FitMethod = FitParameters.FitMethod;

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





















end
function FuncUpdateFitParam()
global M Ftot

load([getPath('Param') 'FitParameters.mat'],'FitParameters');

panel=guidata(gcbo);

FitParameters.DataPath = panel.DataPath.String;
FitParameters.TreatedDataPath = panel.TreatedDataPath.String;
FitParameters.TreatedPathAutoChange = panel.TreatedPathAutoChange.Value;

FitParameters.smooth_order = str2double(panel.smooth_order.String);
FitParameters.smooth_window = str2double(panel.smooth_window.String);
FitParameters.minDistBetweenPeaks = str2double(panel.minDistBetweenPeaks.String);
FitParameters.height_threshold = str2double(panel.height_threshold.String);
% deprecated
% FitParameters.WidthMinToKeep = str2double(panel.WidthMinToKeep.String);

if strcmp(panel.calibunit.SelectedObject.String,'pixel')
   FitParameters.Calib_Dist = 0;
else
   FitParameters.Calib_Dist = 1;
end
FitParameters.size_pix = str2double(panel.pixelcalibvalue.String);
FitParameters.WithPreset = panel.WithPreset.Value;

FitParameters.FitMethod = str2double(panel.FitMethod.String);

if FitParameters.FitMethod == 7 || FitParameters.FitMethod == 8
    FitParameters.NumPeaks = 2;
    panel.NumPeaksChoice.SelectedObject = panel.NumPeaks2;
else
    FitParameters.NumPeaks = str2double(panel.NumPeaksChoice.SelectedObject.String);
end

FitParameters.type_function = panel.type_function.String;
FitParameters.NumComp = FitParameters.NumPeaks/2;
FitParameters.IsPair = 1; % archaic, forced value here
FitParameters.UsePstart = panel.UsePstart.Value;
FitParameters.AutoBase = panel.AutoBase.Value;
FitParameters.BinThr =  str2double(panel.Bin_txt.String);

FitParameters.Smoothing_Factor = str2double(panel.Smoothing_Factor.String);
FitParameters.Detrending_Factor = str2double(panel.Detrending_Factor.String);
ClearFFT = strsplit(panel.ClearFFT.String);
ClearFFT{1} = str2double(ClearFFT{1});
ClearFFT{2} = str2double(ClearFFT{2});
FitParameters.ClearFFT = ClearFFT;
FitParameters.TrackingFit = str2double(panel.TrackingFit.String);
FitParameters.RemPositive = panel.RemPositive.Value;
FitParameters.VarWidths = panel.VarWidths.Value;

if FitParameters.Smoothing_Factor ~= 0
    FitParameters.SMOOTH = 1;
else
    FitParameters.SMOOTH = 0;
end

FitParameters.NumCompFittofield = str2double(panel.NumCompFittofield.String);
FitParameters.CorrectPermutation = panel.CorrectPermutation.String;
FitParameters.Renormalize_Parameters = panel.Renormalize_Parameters.String;
FitParameters.StdforRescalingTeslas = str2double(panel.StdforRescalingTeslas.String);
FitParameters.ColorRescale = panel.ColorRescale.Value;

FitParameters.LowerBound = panel.LowerBound.Value;
FitParameters.cmin = panel.cmin.String;
FitParameters.fmmin = panel.fmmin.String;
FitParameters.fdmin = panel.fdmin.String;
FitParameters.fwmin = panel.fwmin.String;
FitParameters.y0min = panel.y0min.String;
FitParameters.UpperBound = panel.UpperBound.Value;
FitParameters.cmax = panel.cmax.String;
FitParameters.fmmax = panel.fmmax.String;
FitParameters.fdmax = panel.fdmax.String;
FitParameters.fwmax = panel.fwmax.String;
FitParameters.y0max = panel.y0max.String;

PixX = str2num(panel.PixX.String);    
PixY = str2num(panel.PixY.String);

SPX = Ftot*1000;%in MHz
SPY = squeeze(M(PixY,PixX,:));
[full_lower_bound,full_upper_bound,full_lower_bound_auto,full_upper_bound_auto] = CalculateBoundaryParameters(SPX,SPY,FitParameters);

FitParameters.full_lower_bound = full_lower_bound;
FitParameters.full_upper_bound = full_upper_bound;
FitParameters.full_lower_bound_auto = full_lower_bound_auto;
FitParameters.full_upper_bound_auto = full_upper_bound_auto;

save([getPath('Param') 'FitParameters.mat'],'FitParameters');





end
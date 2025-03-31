function LoadFitParam(FitParameters)

panel=guidata(gcbo);

panel.DataPath.String = FitParameters.DataPath;
panel.TreatedDataPath.String = FitParameters.TreatedDataPath;
panel.TreatedPathAutoChange.Value = FitParameters.TreatedPathAutoChange;

eval(['panel.NumPeaksChoice.SelectedObject = panel.NumPeaks' num2str(FitParameters.NumPeaks) ';' ]);

panel.smooth_order.String = num2str(FitParameters.smooth_order);
panel.smooth_window.String = num2str(FitParameters.smooth_window);
panel.minDistBetweenPeaks.String = num2str(FitParameters.minDistBetweenPeaks);
panel.height_threshold.String = num2str(FitParameters.height_threshold);
panel.WidthMinToKeep.String = num2str(FitParameters.WidthMinToKeep);

panel.type_function.String = FitParameters.type_function;
panel.UsePstart.Value = FitParameters.UsePstart;
panel.AutoBase.Value = FitParameters.AutoBase;
panel.BinThr.String = num2str(FitParameters.BinThr);

panel.Calib_Dist = FitParameters.Calib_Dist;
if FitParameters.Calib_Dist == 0
    panel.calibunit.SelectedObject = panel.calib_pixel_r1;
else
    panel.calibunit.SelectedObject = panel.calib_nm_r2;
end
panel.WithPreset.Value = FitParameters.WithPreset;
panel.size_pix.String = num2str(FitParameters.size_pix);

panel.Smoothing_Factor.String = num2str(FitParameters.Smoothing_Factor);
panel.Detrending_Factor.String = num2str(FitParameters.Detrending_Factor);
panel.ClearFFT.String = strjoin(string(FitParameters.ClearFFT));
panel.TrackingFit.String = num2str(FitParameters.TrackingFit);
panel.RemPositive.Value = FitParameters.RemPositive;
panel.VarWidths.Value = FitParameters.VarWidths;
panel.FitMethod.String = num2str(FitParameters.FitMethod);

panel.CorrectPermutation.String = strjoin(string(FitParameters.CorrectPermutation));
panel.Renormalize_Parameters.String = strjoin(string(FitParameters.Renormalize_Parameters));
panel.ColorRescale.Value = FitParameters.ColorRescale;
panel.StdforRescalingTeslas.String = num2str(FitParameters.StdforRescalingTeslas);
panel.NumCompFittofield.String = num2str(FitParameters.NumCompFittofield);

panel.LowerBound.Value = FitParameters.LowerBound;
panel.cmin.String = FitParameters.cmin;
panel.fmmin.String = FitParameters.fmmin;
panel.fdmin.String = FitParameters.fdmin;
panel.fwmin.String = FitParameters.fwmin;
panel.y0min.String = FitParameters.y0min;

panel.UpperBound.Value = FitParameters.UpperBound;
panel.cmax.String = FitParameters.cmax;
panel.fmmax.String = FitParameters.fmmax;
panel.fdmax.String = FitParameters.fdmax;
panel.fwmax.String = FitParameters.fwmax;
panel.y0max.String = FitParameters.y0max;

panel.VisuFit.Value = FitParameters.VisuFit;

end
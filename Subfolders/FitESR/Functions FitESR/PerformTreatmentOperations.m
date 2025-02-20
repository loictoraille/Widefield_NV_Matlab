
function spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive)

v=length(v_MHz);

spectre = Smoothing(spectre,Smoothing_Factor);
spectre = Detrending(v_MHz,spectre,Detrending_Factor);
spectre = ClearingFFT(spectre,v,ClearFFT);
spectre = RemovePositive(spectre,RemPositive);

end

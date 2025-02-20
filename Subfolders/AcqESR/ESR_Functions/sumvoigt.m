
function err = sumvoigt(frequence,varVoigt)

NumPeaks = length(varVoigt)/4;
err = @(p) p(end)/100000;
    for i=1:NumPeaks
        amp = @(p) p(i);
        cntr = @(p) p(NumPeaks + i);
        stdGauss = @(p) p(2*NumPeaks + i);
        stdLor = @(p) p(3*NumPeaks + i);
        err = @(p) err(p) + voigtfunc(frequence, cntr(p), amp(p), stdGauss(p), stdLor(p));
    end
end
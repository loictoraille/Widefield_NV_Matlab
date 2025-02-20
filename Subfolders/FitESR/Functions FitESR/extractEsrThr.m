function [spOut, binOut] = extractEsrThr(ESRMatrix, ix, iy, binThr)
% extractEsrThr extracts the ESR spectrum from ESRMatrix in pixel (iy, ix),
% depending on the value of BinThr
% Mayeul Chipaux, April 14th, 2019


thrLim = 100;

if binThr < thrLim 
 % in this case, we consider BinThr directly as a binning i.e. the side of
 % the square around (iy, ix) from which we sum all the spectra together.
    binOut = binThr;
    spOut = extractEsrCont(ESRMatrix, ix, iy, binOut);
else
 % in this case, we consider BinThr as a threshold below which the
 % values of spectra luminescence should not be. We recalculate a new binning from the 
 % mean of a single spectrum so we can average enough spectra 
    binOut = 1;
    spOut = extractEsrCont(ESRMatrix, ix, iy, binOut);
    meanSp = mean(spOut);
    if meanSp < binThr
        binMax = 25;% to prevent getting stuck in infinite loop when mean(spOut)=0
        binOut = min(sqrt(binThr/meanSp),binMax);
        spOut = extractEsrCont(ESRMatrix, ix, iy, binOut);
    end
end


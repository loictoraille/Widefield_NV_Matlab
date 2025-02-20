function [spectre_cfft] = ClearingFFT(spectre, v, ClearFFT)
% apply a filter in the fourier domain to remove all components under a
% threshold frequency, useful when there are periodic noises

if string(ClearFFT{3}) == 'max'
    clearFFT_freqstop = floor(v/2)+1;
end

clearFFT_freqstart = ClearFFT{2};

if ClearFFT{1} == 0
    [spectre_cfft] = spectre;    
else
    spectre_fft = fft(spectre);
    spectre_cleared_fft = spectre_fft;
    spectre_cleared_fft(clearFFT_freqstart:clearFFT_freqstop) = 0;
    spectre_cleared_fft(end-clearFFT_freqstop:end-clearFFT_freqstart) = 0;
    spectre_cfft = abs(ifft(spectre_cleared_fft));
    [spectre_cfft] = spectre_cfft;
end

end
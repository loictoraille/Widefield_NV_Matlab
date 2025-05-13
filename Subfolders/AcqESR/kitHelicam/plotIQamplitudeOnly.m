function plotIQamplitudeOnly(I,Q)
    % plot IQ
    % plot root mean square (rms) amplitude across field of view

    rms = squeeze(sqrt(mean(I.^2 + Q.^2)));
    imagesc(rms)
    colorbar
    
    xlabel('x in pxl')
    ylabel('y in pxl')
    title('rms amplitude')

end


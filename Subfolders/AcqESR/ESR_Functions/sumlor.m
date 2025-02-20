function err = sumlor(frequence,varlor)

NumPeaks = length(varlor)/3;
err = @(p) 0;
    for i=1:NumPeaks
        amp = @(p) p(i);
        cntr = @(p) p(NumPeaks + i);
        stdLor = @(p) p(2*NumPeaks + i);
        err = @(p) err(p) + amp(p)./ (1 +  (2*(frequence - cntr(p)) ./ stdLor(p)).^2  );
    end
end
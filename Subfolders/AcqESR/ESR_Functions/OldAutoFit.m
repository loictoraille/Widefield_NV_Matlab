function [FitPreset,FitResult,PFIT] = OldAutoFit(SPX,SPY)

bval = round(mean(SPY(1:5)));

p0 = [0.03 0.03 2870 10 2 2 bval];
    % contrast1, contrast2, fm, fd, width1, width2, baseline

options = optimoptions('lsqnonlin','Display', 'off');
[PFIT,~,~,~,~] = lsqnonlin(@(p) ESR_2peaks(p,SPX,SPY),p0,[],[],options);

FitPreset = ESR_2peaks(p0,SPX,SPY) + SPY;
FitResult = ESR_2peaks(PFIT,SPX,SPY) + SPY;


function e=ESR_2peaks(p,SPX,SPY)
    e = p(7) - (p(1)./(1+((SPX-(p(3)-p(4)/2))/(p(5)/2)).^2) + p(2)./(1+((SPX-(p(3)+...
        p(4)/2))/(p(6)/2)).^2)) - SPY;
end

end
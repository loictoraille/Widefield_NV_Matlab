function middleFreq = GetBarycentre(SPX,SPY)
Thresh_Bary = 0.75;

% baseline suppression
fmtSpectre = max(SPY) - SPY; % inverts the spectrum

avgSpectre = mean(fmtSpectre);
significantValue=fmtSpectre > (avgSpectre*Thresh_Bary); % considered above noise fluctuation
middleFreq =  dot(significantValue,fmtSpectre.*SPX)/dot(significantValue,fmtSpectre);

end
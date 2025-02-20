function PFIT = FromPosToPair(jx)

NumPeaks = length(jx)/3;

NewOrder = PeaksToPairOrder(NumPeaks);

% contrasts
PFIT(1:NumPeaks) = jx(NewOrder);

% mid frequency and splittings
for i=1:NumPeaks/2
    PFIT(NumPeaks+i) = jx(NumPeaks+NewOrder(2*i))-jx(NumPeaks+NewOrder(2*i-1));
    PFIT(NumPeaks+NumPeaks/2+i) = mean([jx(NumPeaks+NewOrder(2*i-1)),jx(NumPeaks+NewOrder(2*i))]);
end
    
% widths
PFIT(2*NumPeaks+1:3*NumPeaks) = jx(2*NumPeaks+NewOrder);

end
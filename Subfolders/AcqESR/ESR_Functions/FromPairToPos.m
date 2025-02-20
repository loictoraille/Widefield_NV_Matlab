function PstartOut = FromPairToPos(PstartIn)

NumPeaks = length(PstartIn)/3;

if NumPeaks < 1
    PstartOut = PstartIn.';
end

NewOrder = PairToPeaksOrder(NumPeaks);

% contrasts
PstartOut(1:NumPeaks) = PstartIn(NewOrder);

% frequency positions
for i=1:NumPeaks/2
    PstartOut(NumPeaks+i) = PstartIn(2*NumPeaks+1-i) - PstartIn(1.5*NumPeaks+1-i)/2;
    PstartOut(1.5*NumPeaks+i) = PstartIn(1.5*NumPeaks+i)+PstartIn(NumPeaks+i)/2;
end
    
% widths
PstartOut(2*NumPeaks+1:3*NumPeaks) = PstartIn(2*NumPeaks+NewOrder);

end
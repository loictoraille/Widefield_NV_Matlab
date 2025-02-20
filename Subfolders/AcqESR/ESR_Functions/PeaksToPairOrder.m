function Order = PeaksToPairOrder(NumPeaks)

for j=1:NumPeaks
    if rem(j,2) == 1
        Order(j) = NumPeaks/2-floor(j/2);
    else
        Order(j) = NumPeaks/2+j/2;
    end
end

end
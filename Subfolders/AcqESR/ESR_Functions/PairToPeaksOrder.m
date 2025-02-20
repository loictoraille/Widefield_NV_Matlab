function Order = PairToPeaksOrder(NumPeaks)

Order = [];
for j=1:NumPeaks/2
    Order = [Order NumPeaks-2*j+1];
end
for j=1:NumPeaks/2
    Order = [Order 2*j];
end

end
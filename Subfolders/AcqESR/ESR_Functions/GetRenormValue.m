function RenormValue = GetRenormValue(Spectrum)

SizeAverage = 5;

RenormValue = mean([mean(Spectrum(1:SizeAverage)) mean(Spectrum(end-SizeAverage:end))]);

end
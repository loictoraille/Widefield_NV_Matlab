function StrResult = BuildStrResult(PFITin,var)
NumPeaks = (length(PFITin)-1)/3;    
if rem(NumPeaks,2) ~= 0
    if var == 1
        StrResult = 'Freq = ';
        for i=1:NumPeaks
            StrResult = [StrResult num2str(round(PFITin(NumPeaks+i)/1000,2)) ','];
        end
        StrResult = [StrResult(1:end-1) ' MHz'];
    else
        StrPart1 = 'Contrasts = ';
        StrPart2 = 'Widths = ';
        for i=1:NumPeaks
            StrPart1 = [StrPart1 num2str(round(PFITin(i)*100,1)) ','];
            StrPart2 = [StrPart2 num2str(round(PFITin(2*NumPeaks+i),1)) ','];
        end
        StrPart1 = [StrPart1(1:end-1), ' %'];
        StrPart2 = [StrPart2(1:end-1), ' MHz'];
        StrResult = {StrPart1;StrPart2};
    end
else
    if var == 1
        StrPart1 = 'Middle Freq = ';
        StrPart2 = 'Splitting = ';
        for i=1:NumPeaks/2
            StrPart1 = [StrPart1 num2str(round(PFITin(1.5*NumPeaks+i)/1000,3)) ','];
            StrPart2 = [StrPart2 num2str(round(PFITin(NumPeaks+i),1)) ','];
        end
        StrPart1 = [StrPart1(1:end-1), ' GHz'];
        StrPart2 = [StrPart2(1:end-1), ' MHz'];
        StrResult = {StrPart1;StrPart2};
    else
        StrPart1 = 'Contrasts = ';
        StrPart2 = 'Widths = ';
        NewOrder = PairToPeaksOrder(NumPeaks);
        for i=1:NumPeaks
            StrPart1 = [StrPart1 num2str(round(PFITin(NewOrder(i))*100,1)) ','];
            StrPart2 = [StrPart2 num2str(round(PFITin(2*NumPeaks+NewOrder(i)),1)) ','];
        end
        StrPart1 = [StrPart1(1:end-1), ' %'];
        StrPart2 = [StrPart2(1:end-1), ' MHz'];
        StrResult = {StrPart1;StrPart2};
    end
end

end
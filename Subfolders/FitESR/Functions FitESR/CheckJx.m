function CheckJx(ix, iy, jx, NumComp, IsPair)
% checking if the pairs of peaks are not intertwined

if NumComp == 4 && IsPair
    if (jx(16)-jx(12)/2) < (jx(15)-jx(11)/2) && (jx(15)-jx(11)/2) < (jx(14)-jx(10)/2) && (jx(14)-jx(10)/2) < (jx(13)-jx(9)/2) && (jx(13)-jx(9)/2) < (jx(13)+jx(9)/2) && (jx(13)+jx(9)/2) < (jx(14)+jx(10)/2) && (jx(14)+jx(10)/2) < (jx(15)+jx(11)/2) && (jx(15)+jx(11)/2) < (jx(16)+jx(12)/2)
        Order_Peak = 'OK';
    else
        Order_Peak = 'Wrong';
        disp(['ESR Spectrum: x=' num2str(ix) ' pixels, y=' num2str(iy)  ' pixels: the peaks are not in the right order!']);
    end
end

end
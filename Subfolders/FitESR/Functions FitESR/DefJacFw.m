function Fout = DefJacFw(v_MHz, VarWidths, NumComp, IsPair)
% This method  is a double lorentzian for each peak, and returns as width
% the width of a singular peak (not doubled)

lor = @(a,fm,fw,x) a ./ (1 +  (2*(x - fm) ./ fw).^2  );

nbHyperfine = 1;
switch nbHyperfine
    case 2 %Nitrogen 15
        lor = @(a,fm,fw,x) lor(a,fm-1.5,fw,x) + lor(a,fm+1.5,fw,x);
    case 3 %Nitrogen 14
        lor = @(a,fm,fw,x) lor(a,fm-2,fw,x) + lor(a,fm,fw,x) + lor(a,fm+2,fw,x);
end

Fout = @(p) p(end);
for i = 1: NumComp
    if IsPair
        a1 = @(p) p(2*i-1);
        a2 = @(p) p(2*i);
        fd = @(p) p(2*NumComp+i);
        fm1 = @(p) p(3*NumComp+i) - fd(p)/2;
        fm2 = @(p) p(3*NumComp+i) + fd(p)/2;
        if VarWidths
            fw1 = @(p) p(4*NumComp+2*i-1);
            fw2 = @(p) p(4*NumComp+2*i);
        else
            fw1 = @(p) p(4*NumComp+2*1);
            fw2 = fw1;
        end
        Fout = @(p) Fout(p) - p(end) * ( lor(a1(p),fm1(p),fw1(p),v_MHz) + lor(a2(p),fm2(p),fw2(p),v_MHz));
    else
        a = @(p) p(i);
        fm =@(p)  p(NumCom + i);
        if VarWidths
            fw = @(p) p(2*NumComp + i);
        else
            fw = @(p) p(2*NumComp + 1);
        end
        Fout = @(p) Fout(p) -  p(end) * (lor(a(p),fm(p),fw(p),v_MHz));
    end
end


end
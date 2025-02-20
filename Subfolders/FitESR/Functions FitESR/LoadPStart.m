function pStart = LoadPStart(FileName,NumComp,VarWidths,IsPair)
%load the starting parameter for the fit
% a bit archaic, could be simplified

[pfit,message] = fopen([FileName '.txt'], 'r');
A = fscanf(pfit,'%s');
[test,Amax]=size(A);

indc11 = findstr(A,'c11');indc12 = findstr(A,'c12');indc21 = findstr(A,'c21');indc22 = findstr(A,'c22');
indc31 = findstr(A,'c31');indc32 = findstr(A,'c32');indc41 = findstr(A,'c41');indc42 = findstr(A,'c42');

indfd1 = findstr(A,'fd1');indfd2 = findstr(A,'fd2');indfd3 = findstr(A,'fd3');indfd4 = findstr(A,'fd4');

indfm1 = findstr(A,'fm1');indfm2 = findstr(A,'fm2');indfm3 = findstr(A,'fm3');indfm4 = findstr(A,'fm4');

indfw11 = findstr(A,'fw11');indfw12 = findstr(A,'fw12');indfw21 = findstr(A,'fw21');indfw22 = findstr(A,'fw22');
indfw31 = findstr(A,'fw31');indfw32 = findstr(A,'fw32');indfw41 = findstr(A,'fw41');indfw42 = findstr(A,'fw42');

indy0 = findstr(A,'y0');

c11 = str2num(A(indc11+4:indc12-1));c12 = str2num(A(indc12+4:indc21-1));c21 = str2num(A(indc21+4:indc22-1));
c22 = str2num(A(indc22+4:indc31-1));c31 = str2num(A(indc31+4:indc32-1));c32 = str2num(A(indc32+4:indc41-1));
c41 = str2num(A(indc41+4:indc42-1));c42 = str2num(A(indc42+4:indfd1-1));

fd1 = str2num(A(indfd1+4:indfd2-1));fd2 = str2num(A(indfd2+4:indfd3-1));fd3 = str2num(A(indfd3+4:indfd4-1));
fd4 = str2num(A(indfd4+4:indfm1-1));

fm1 = str2num(A(indfm1+4:indfm2-1));fm2 = str2num(A(indfm2+4:indfm3-1));fm3 = str2num(A(indfm3+4:indfm4-1));
fm4 = str2num(A(indfm4+4:indfw11-1));

fw11 = str2num(A(indfw11+5:indfw12-1));fw12 = str2num(A(indfw12+5:indfw21-1));fw21 = str2num(A(indfw21+5:indfw22-1));
fw22 = str2num(A(indfw22+5:indfw31-1));fw31 = str2num(A(indfw31+5:indfw32-1));fw32 = str2num(A(indfw32+5:indfw41-1));
fw41 = str2num(A(indfw41+5:indfw42-1));fw42 = str2num(A(indfw42+5:indy0-1));

y0 = str2num(A(indy0+3:end));

switch NumComp
    case .5
        pStart = [c11,fm1+fd1/2,y0];
    case 1
        if IsPair
            pStart = [c11, c12, fd1, fm1];
        else
            pStart = [c11, fm1];
        end
    case 2
        if IsPair
            pStart = [c11, c12, c21, c22, fd1, fd2, fm1, fm2];
        else
            pStart = [c11, c21, fm1, fm2];
        end
    case 3
       if IsPair
            pStart = [c11, c12, c21, c22, c31, c32, fd1, fd2, fd3, fm1, fm2, fm3];
          else
            pStart = [c11, c21, c31, fm1, fm2, fm3];
        end
    case 4 
       if IsPair
            pStart = [c11, c12, c21, c22, c31, c32, c41, c42, fd1, fd2, fd3, fd4, fm1, fm2, fm3, fm4];
else
            pStart = [c11, c21, c31, c41, fm1, fm2, fm3, fm4];
       end
end

if VarWidths == 0
    pStart = [pStart mean([fw11 fw12 fw21 fw22 fw31 fw32 fw41 fw42]) y0];
else
    switch NumComp
        case 1
            if IsPair
                pStart = [pStart, fw11, fw12, y0];
            else
                pStart = [pStart, fw11, y0];  
            end
        case 2
            if IsPair
                pStart = [pStart, fw11, fw12, fw21, fw22, y0];
            else
                pStart = [pStart, fw11, fw21, y0];
            end
        case 3
            if IsPair
                pStart = [pStart, fw11, fw12, fw21, fw22, fw31, fw32, y0];
            else
                pStart = [pStart, fw11, fw21, fw31, y0];  
            end
        case 4
            if IsPair
                pStart = [pStart, fw11, fw12, fw21, fw22, fw31, fw32, fw41, fw42, y0];  
            else
                pStart = [pStart, fw11, fw21, fw31, fw41, y0];  
            end
    end
end

pStart = pStart';

fclose(pfit);

end


    
    
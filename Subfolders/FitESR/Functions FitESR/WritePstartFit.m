function pOut = WritePstartFit(pIn, v_MHz, nComp, IsPair, VarWidths, strFile)

% we create a new pOut that we will use to write the parameters in the
% file, using the general case where nComp(pout) = 4, VarWidths = 1 IsPair =
% true...
pOut = LoadPStart([getPath('Param') 'PstartFit'],4 ,1 , true);

% we will replace part of this vector with the data that are really
% contained in pIn (with pIn maybe smaller than pOut).

% we first creat a index vector to select the position in pOut where we
% have to write the new values. The others stay unchanged.


ic = 1;     % from 1 to 2*nComp (if IsPair)
ifd = 9;    % from 9 to 9 + nComp
ifm = 13;   % 13 to 13 + nComp
ifw = 17;   % 17 to 17 + nComp
iy0 = 25;   %


iTmp = 0:nComp-1;
iTmpPair = [iTmp, iTmp+nComp];
if ~IsPair
    iVec = [ic+iTmp, ifm+iTmp];
else
    iVec = [ic+iTmpPair, ifd+iTmp, ifm+iTmp];
end

if VarWidths == 1
    if IsPair
        iVec = [iVec, ifw + iTmpPair, iy0];
    else
        iVec = [iVec, ifw + iTmp, iy0];
    end
else
    iVec = [iVec, ifw, iy0];
end

pOut(iVec) = pIn;
        
strStart = '********************* Fitting Parameters *********************\r\n \r\n';

strContrast = ['c11 = ' num2str(roundn(pOut(1),-3)) '\t c12 = ' num2str(roundn(pOut(2),-3)) '\t c21 = ' num2str(roundn(pOut(3),-3))...
'\t c22 = ' num2str(roundn(pOut(4),-3)) '\r\nc31 = ' num2str(roundn(pOut(5),-3)) '\t c32 = ' num2str(roundn(pOut(6),-3))...
'\t c41 = ' num2str(roundn(pOut(7),-3)) '\t c42 = ' num2str(roundn(pOut(8),-3)) '\r\n \r\n'];

strFd = ['fd1 = ' num2str(roundn(pOut(9),0)) '\t fd2 = ' num2str(roundn(pOut(10),0)) '\t fd3 = ' num2str(roundn(pOut(11),0))...$
'\t fd4 = ' num2str(roundn(pOut(12),0)) '\r\n \r\n'];

strFm = ['fm1 = ' num2str(roundn(pOut(13),0)) '\t fm2 = ' num2str(roundn(pOut(14),0)) '\t fm3 = ' num2str(roundn(pOut(15),0))...$
'\t fm4 = ' num2str(roundn(pOut(16),0)) '\r\n \r\n'];

strFw = ['fw11 = ' num2str(roundn(pOut(17),0)) '\t fw12 = ' num2str(roundn(pOut(18),0)) '\t fw21 = ' num2str(roundn(pOut(19),0))...
'\t fw22 = ' num2str(roundn(pOut(20),0)) '\r\nfw31 = ' num2str(roundn(pOut(21),0)) '\t fw32 = ' num2str(roundn(pOut(22),0))...
'\t fw41 = ' num2str(roundn(pOut(23),0)) '\t fw42 = ' num2str(roundn(pOut(24),0)) '\r\n \r\n'];

strY0 = ['y0 = ' num2str(roundn(pOut(25),-4))];

pStartString = strcat(strStart,strContrast,strFd,strFm,strFw,strY0);

fid = fopen([getPath('Param') strFile '.txt'],'w');
fprintf(fid, pStartString);
fclose(fid);

end
function [FitTot, BinMap] = FitCimg(ESRMatrix, v_MHz,  Cropping_Coord, FitParameters)
%Fit the entire ESRMatrix image with an ESR spectrum in each pixel
%Different tracking are possible ; in general it's better without tracking,
%but tracking 4 is then the second most succesful
%Other tracking possible : using vertical previous values as starting
%parameters for the full image, using vertical + left corner previous
%values, starting from the center and going in a spiral, etc...

% [xstart, ystart, xstoptoend, ystoptoend] = Cropping(Crop, Cropping_Coord);

ReadFitParameters;

[h, w, ~] = size(ESRMatrix);

[x_start, y_start, ~, ~, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);

% Ffit = DefJacFw(v_MHz, VarWidths, NumComp, IsPair);
pStart = LoadPStart([getPath('Param') 'PstartFitBin'],NumComp, VarWidths, IsPair);
FitTot = zeros(hcrop,wcrop,length(pStart));

% if LowerBound
%     pLb = full_lower_bound;
% else
%     pLb = [];
% end
% 
% if UpperBound
%     pUb = full_upper_bound;
% else
%     pUb = [];
% end  

pf = pStart;

tic
disp('Fit started');
BinMap=zeros(hcrop, wcrop);
for iy=1:hcrop
        if rem(iy,10) == 0
            disp([num2str(iy) '/' num2str(hcrop)])
        end
for ix=1:wcrop
    switch TrackingFit
        case 0
            pf = pStart;
        case 1
        % use a mean of pStart and 1 vertical previous value
            if iy <= 1
                pf = pStart;
            else 
                pf = pStart/2 + squeeze(FitTot(iy-1,ix,:))/2;
            end
        case 2
        % fit using vertical previous values as starting parameters
            if iy <= 3
                pf = pStart;
            else
                pf = squeeze((FitTot(iy-1,ix,:)+FitTot(iy-2,ix,:)+FitTot(iy-3,ix,:))/3);
            end    
        case 3
        % fit using vertical previous values as starting parameters
        % starting from the bottom
        iy = hcrop - iy + 1;
            if iy > hcrop-3
                pf = pStart;
            else
                pf = squeeze((FitTot(iy+1,ix,:)+FitTot(iy+2,ix,:)+FitTot(iy+3,ix,:))/3);
            end   
        case 4
        % fit using vertical previous values as starting parameters
        % and starting from both ends
            if iy < hcrop/2
                if iy <= 3
                    pf = pStart;
                else
                    pf = squeeze((FitTot(iy-1,ix,:)+FitTot(iy-2,ix,:)+FitTot(iy-3,ix,:))/3);
                end
            else
                iy = hcrop+hcrop/2-iy;
                if iy > hcrop-3
                    pf = pStart;
                else
                    pf = squeeze((FitTot(iy+1,ix,:)+FitTot(iy+2,ix,:)+FitTot(iy+3,ix,:))/3);
                end
            end              
    end
    
    [spectre, BinOut] = extractEsrThr(ESRMatrix, ix+x_start-1, iy+y_start-1, BinThr);
    spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT, RemPositive);
    
    isPlot = false;
%     pf = lastUpdatePstart(spectre, pf);
%     disp(['ix = ' num2str(ix)]);
%     disp(['iy = ' num2str(iy)]);
%     if ix == 85 && iy == 1
%         disp('test');
%     end
    jx = fitOneEsr(v_MHz, spectre, pf, isPlot, FitParameters);
    CheckJx(ix, iy, jx, NumComp, IsPair);
    FitTot(iy,ix,:) = jx;
    BinMap(iy,ix) = BinOut;
    if TrackingFit == 3
        iy = hcrop - iy + 1;
    end
end
end

endfit = toc;

endfitmin = floor(endfit/60);  
if endfitmin < 1
    endfitsec = floor(endfit);
    disp(['Fit lasted ' num2str(endfitsec) ' seconds.']);
elseif endfitmin == 1
    disp(['Fit lasted ' num2str(endfitmin) ' minute.']);
else
    disp(['Fit lasted ' num2str(endfitmin) ' minutes.']);
end



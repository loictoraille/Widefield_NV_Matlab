function jx = fitOneEsr(V_MHz, Spectre, pStart, isPlot, FitParameters)
% fitOneEsr returns the jx by fitting a curve that depend on FitMethod

ReadFitParameters;

if FitMethod == 7 || FitMethod == 8
    FitStuff = 0;
else
    FitStuff = 1;
end

if FitStuff == 1
    [full_lower_bound,full_upper_bound,~,~] = CalculateBoundaryParameters(V_MHz,Spectre,FitParameters);
end

if LowerBound
    pLb = full_lower_bound;
else
    pLb = [];
end

if UpperBound
    pUb = full_upper_bound;
else
    pUb = [];
end    

if UsePstart
    pStart = pStart(:,1)';
else
    SPX = V_MHz;
    SPY = Spectre;
    if FitStuff == 1
        InvSPY = -SPY + max(SPY);
        Base = ones(length(SPY),1)*GetRenormValue(InvSPY);
        Corrected_Intensity = InvSPY-Base;
        SmoothedForFindPeaks = sgolayfilt(Corrected_Intensity, smooth_order, smooth_window);
        
        gcbo_test = gcbo;
        if ~isempty(gcbo_test)
            panel=guidata(gcbo);
            NumPeaks = str2double(panel.NumPeaksChoice.SelectedObject.String);
        else
            if IsPair
                NumPeaks = 2*NumComp;
            else
                NumPeaks = NumComp;
            end
        end
        
        if NumPeaks ~= 0
            [peakint, peakloc, widths] = findpeaks(SmoothedForFindPeaks, SPX, 'SortStr','descend','NPeaks',NumPeaks,'MinPeakDistance',minDistBetweenPeaks);
        else
            [peakint, peakloc, widths] = findpeaks(SmoothedForFindPeaks, SPX, 'MinPeakHeight', max(SmoothedForFindPeaks)*height_threshold);
        end
        
        % tri dans l'ordre des positions croissantes
        [~,order_peaks] = sort(peakloc);
        peakint = peakint(order_peaks);
        peakloc = peakloc(order_peaks);
        widths = widths(order_peaks);
        
        FoundPeaks = length(peakint);
        if FoundPeaks == 0
            pStart = pStart(:,1)';
        else
            if FoundPeaks ~= NumPeaks
                for upeaks = 1:(abs(FoundPeaks-NumPeaks))
                    peakint = [peakint;peakint(1)/max(SPY)];
                    peakloc = [peakloc;peakloc(1)];
                    widths = [widths;widths(1)];
                end
                NumPeaks = length(peakint);
            end
            pStart = [peakint; peakloc; widths];
            pStart = FromPosToPair(pStart);
            pStart = [pStart GetRenormValue(Spectre)];
            pLb(end) = pLb(end)*pStart(end);
            pUb(end) = pUb(end)*pStart(end);
        end
    end
end

switch FitMethod
    case 8 % Correlation method
%         MiddleFreq = OdmrCentre(SPX,SPY); % old correlation with rectangles
        MiddleFreq = OdmrCentreV2(SPX,SPY); % new correlation with lorentzians
        jx = [0 0 0 MiddleFreq 0 0 0];
    
    case 7 % Barycentre estimation for the middlefreq
        MiddleFreq = GetBarycentre(SPX,SPY);
        jx = [0 0 0 MiddleFreq 0 0 0];
    
    case 1  % in case 1 we fit TWO Lorentzians per ESR peak spaced 
            % by 3 MHz corresponding to the N14 hyperfine interaction  
        Ffit = DefJacFw(V_MHz, VarWidths, NumComp, IsPair);
        if UsePstart ~= 1
            pStart(1:NumPeaks) = pStart(1:NumPeaks)/pStart(end);
        end
        jx = fitOneEsrLor(Spectre, pStart, pLb, pUb, Ffit);
%     case 2  % NOT IMPLEMENTED YET In case 2 we fit ONE Lorentzians 

%     case 3  % NOT IMPLEMENTED YET In case 3 we fit THREE lorentzians per ESR peak
%     spaced by 2 MHz corresponding to the N14 hyperfine interaction 

    case 4  % In case 4 we use an order 3 polynomial to extract 
            % the positions of the peaks
        jx = fitOneEsrPoly(V_MHz, Spectre, pStart, NumComp, IsPair, VarWidths, isPlot);
        
    case 5 % Automatic advanced baseline removing 
        % usePstart part already covered at the start
%         if UsePstart
%             if IsPair
%                 numPeaks = numComp*2;
%             else
%                 numPeaks = numComp;
%             end
%             if rem(numPeaks,2) == 0
%                 pStart = LoadPStart('PstartFit',numPeaks/2,VarWidths,IsPair,V_MHz); 
%                 pStart(1:numPeaks) = pStart(1:numPeaks)*pStart(end);
%                 pStart = pStart(1:end-1);% deleting the baseline value for this fit method
%                 pStart = FromPairToPos(pStart).';
%             else
%                 disp('Cannot work with uneven number of peaks and UsePstart option for now');
%             end
%         else
%             pStart = 0;
%         end
        if length(pStart) > 1
            pStart(1:NumPeaks) = pStart(1:NumPeaks)*pStart(end);
            pStart = pStart(1:end-1);% deleting the baseline value for this fit method
            pStart = FromPairToPos(pStart).';% correct order and formatting
        end
        [~,~,jx] = AutoFit(V_MHz,Spectre,pStart,FitParameters);      
    
end

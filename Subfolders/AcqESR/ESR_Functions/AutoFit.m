function [FitPreset,FitResult,PFIT] = AutoFit(SPX,SPY,pStart,FitParameters)

ReadFitParameters;

WidthMinToKeep = convertToPixels(SPX,WidthMinToKeep);

minDistBetweenPeaks = convertToPixels(SPX,minDistBetweenPeaks);

InvSPY = -SPY + max(SPY); % to have positive peaks

[full_lower_bound_auto,full_upper_bound_auto] = RefreshBoundaryIntensities(full_lower_bound_auto,full_upper_bound_auto,SPY);

if AutoBase 
    [Base, Corrected_Intensity]=remove_baseline_GPT(InvSPY);
    % [Base, Corrected_Intensity]=baseline(sgolayfilt(InvSPY, 11, 101),WidthMinToKeep);
else
    Base = ones(length(SPY),1)*GetRenormValue(InvSPY);
    Corrected_Intensity = InvSPY-Base;
end

ind_Fail = 0;
if pStart == 0
    SmoothedForFindPeaks = sgolayfilt(Corrected_Intensity, smooth_order, smooth_window);

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
    if FoundPeaks > 0
        if FoundPeaks ~= NumPeaks
            for upeaks = 1:(abs(FoundPeaks-NumPeaks))
                peakint = [peakint;peakint(1)];
                peakloc = [peakloc;peakloc(1)];
                widths = [widths;widths(1)];
            end
            NumPeaks = length(peakint);
        end
        pStart = [peakint; peakloc; widths];
    else
        ind_Fail = 1;
    end
else
    NumPeaks = ceil(length(pStart)/3);
end

    if strcmp(type_function,'voigt')
        pStart = [pStart pStart(2*NumPeaks+1:end)/10];
        Fintermed = sumvoigt(SPX, pStart);
    elseif strcmp(type_function,'lor')
        Fintermed = sumlor(SPX, pStart);
    end

if ind_Fail ~= 0 %indicator to check if there are ANY peaks in the spectrum
    FitPreset = (-(Fintermed(pStart(1:end-1))+pStart(end)+Base-max(SPY))).';
    FitResult = Corrected_Intensity;
    PFIT = 0;
else

    
    if SMOOTH == 1
        Smoothed_Intensity = sgolayfilt(Corrected_Intensity, smooth_order, smooth_window);
    else
        Smoothed_Intensity = Corrected_Intensity;
    end
    
    pStart = [pStart;GetRenormValue(Smoothed_Intensity)];
    
    % disp(pStart(end));disp('next');
    
    Fres = @(p) Fintermed(p(1:end-1)) - Smoothed_Intensity + p(end);
    
    if LowerBound
        lb = full_lower_bound_auto;
    else
        lb = [];
    end
    
    if UpperBound
        ub = full_upper_bound_auto;
    else
        ub = [];
    end
    
    options = optimoptions('lsqnonlin','Display', 'off');
    [jx,~,~,~,~] = lsqnonlin(Fres,pStart,lb,ub,options); % Invoke optimizer
    
    % CheckBounds(jx,lb,ub); % the lower bound on the base is always limiting for now
    
    FitPreset = (-(Fintermed(pStart(1:end-1))+pStart(end)+Base-max(SPY))).';
    FitResult = (-(Fintermed(jx(1:end-1))+jx(end)+Base-max(SPY))).';
    Base = -Base+max(SPY);
    
    
    %%
    
    % figure;
    % plot(SPX,SPY)
    % hold on
    % plot(SPX,FitPreset);
    
    % FitPreset_2 = Fintermed(pStart(1:end-1))+pStart(end);
    % FitResult_2 = Fintermed(jx(1:end-1))+jx(end);
    %
    % figure;
    % plot(SPX,Smoothed_Intensity)
    % hold on
    % plot(SPX,FitPreset_2);
    % plot(SPX,FitResult_2);
    
    
    %%
    
    % jx gives out: contrasts, positions, widths, base after baseline removed
    % > no pairs of peaks, all independent!
    % PFIT must return contrasts, mid freq, splittings, mean(base)
    % in order: pairs of peaks going from the center toward the edges
    
    if strcmp(type_function,'voigt')
        newjx=jx(1:2*NumPeaks);
        for i=1:NumPeaks
            % formula to obtain the FWHM of a voigt function
            newjx(2*NumPeaks+i) = 0.5346*jx(3*NumPeaks+i)+sqrt(0.2166*jx(3*NumPeaks+i)^2+jx(2*NumPeaks+i)^2);
        end
        newjx = [newjx jx(end)];
        clear jx
        jx = newjx;
        clear newjx
    end
    
    if rem(NumPeaks,2) == 0
        % if NumPeaks is odd, impossible to determine pairs so leave it as it is,
        % else modify in pair form
        PFIT = FromPosToPair(jx(1:end-1));
    else
        PFIT = jx(1:end-1).';
    end
    renorm = GetRenormValue(Base) - jx(end);
    PFIT = [PFIT renorm];
    PFIT(1:NumPeaks) = PFIT(1:NumPeaks)/renorm;
    
end

end
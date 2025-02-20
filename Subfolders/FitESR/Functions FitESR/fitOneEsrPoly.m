function jxOut = fitOneEsrPoly(V_MHzIn, SpIn, jxIn, nComp, IsPair, varWidths, isPlot)
%fitOneEsrPoly extracts the fitting parameters jx using an order 3 
%polynomial fit
% Mayeul Chipaux, 07 Jully 2019

freq_shift_coeff = 1.1; % shift used for the difference with itself, based on width in pstart
span_coeff = 1.5; %width cut around one peak, based on freq_shift_coeff


jxOut = jxIn;
if isPlot ~= 0;figPlotPoly = figure('Position',[300,350,550,450]);
else;figPlotPoly = NaN;end

if ~IsPair %if IsPair == false
    iFm = nComp + 1; %In jx, the positions of the pics are in position 5:8 (if nCom = 4)
	
    for iComp=0:nComp-1
        vM_MHz = jxIn(iFm + iComp);
        iFw = 2*nComp+1; %The witdhs of the peaks are from position 9(if nComp = 4)
        if varWidths == 1
            iFw = iFw + iComp;
        end
        dv_MHz = freq_shift_coeff * jxIn(iFw);
         
        vSpan_MHz = span_coeff * dv_MHz;

        jxOut(iFm + iComp) = zeroPoly3Fit(V_MHzIn, SpIn, vM_MHz, vSpan_MHz, dv_MHz, isPlot, figPlotPoly);
        
        jxOut(iFm + iComp);
     end
else %if IsPair == true
    iFd = 2*nComp+1; %In jx, the distance between the pics are in position 9:12 (if nComp = 4)
    iFm = 3*nComp+1; %In jx, the central positions  of the pairs of peaks are in 13:16
    
    for iComp=0:nComp-1
        r=zeros(2,1);
        for iPair= 0:1 %4 pairs of ERS peaks
            vM_MHz = jxIn(iFm + iComp) + jxIn(iFd + iComp)/2 * (2*iPair - 1);
            % vM_MHz = FreqCentral +- deltaFrequence/2, 
            % with 2*iPair - 1 = - 1 for iPair = 0 and +1 for iPair = 1
            iFw = 4*nComp+1; % The witdhs of the peaks are from position 17
            if varWidths == 1
                iFw = iFw + iComp + iPair;
            end
            dv_MHz = freq_shift_coeff * jxIn(iFw);
            vSpan_MHz = span_coeff * dv_MHz;
%                 [iComp, iPair]
            r(iPair + 1) = zeroPoly3Fit(V_MHzIn, SpIn, vM_MHz, vSpan_MHz, dv_MHz, isPlot, figPlotPoly);
        end
        
        jxOut(iFm + iComp) = 1/2 * (r(1) + r(2));
        jxOut(iFd + iComp) = r(2) - r(1);
    end
end

end % End of function


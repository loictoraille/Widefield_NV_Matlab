function r = zeroPoly3Fit(V_MHzIn, SpIn, vCent_MHz, vSpan_MHz, dv_MHz, isPlot, figPlotPoly)
%returns the order 3 polynomial and its central root fitted in spIn that is
%différienciated.
if nargin < 6 
    isPlot = false;
end
[subV_MHz, subSp] = extSubSp(V_MHzIn, SpIn, vCent_MHz, vSpan_MHz);

[dV_MHz, dSp] = diffSp(subV_MHz, subSp, dv_MHz);

[p, ~, mu] = polyfit(dV_MHz, dSp,3);
y2 = polyval(p, dV_MHz, [], mu);

R=sort(roots(p)) * mu(2) + mu(1);
r=roots2root(R,V_MHzIn);

if isPlot
    if isnan(r)
    disp('No roots found, spectrum is probably equal to zero')
    end
    
    figPlotPoly;
    
    subplot(2,1,1)
    title('Peak selection')
    plot(subV_MHz, subSp, 'b')
    hold on
    line([r,r], [min(subSp), max(subSp)])
    grid on
    xlabel('\nu (MHz)');
    ylabel('Luminescence (au)');
    
    subplot(2,1,2)
    title('Luminescence difference with itself, frequency shifted')
    plot(dV_MHz, dSp, 'b')
    hold on
    plot(dV_MHz, y2, 'g');
    line([r,r], [min([min(y2),-1]), max([max(y2),+1])]);
    grid on
    xlabel('d\nu (MHz)');
    ylabel('Luminescence Diff (au)');
end


end


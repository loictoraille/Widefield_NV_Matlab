function updateSpectra(v_MHz,jx,spectre,VarWidths, NumComp, IsPair, FitParameters)
%Update ESR fit plot upon mouseclick in VisuFit
ax=findobj('Tag','SpectreFit');
axes(ax)
lum_value = GetRenormValue(spectre);

if mean(spectre)>10
    plot(v_MHz,spectre./lum_value,'Color','Blue')
    hold on
else
    plot(v_MHz,spectre,'Color','Blue')
    hold on
end

if FitParameters.FitMethod == 7 || FitParameters.FitMethod ==  8
    MiddleFreq = jx(4);
    line(ax, [MiddleFreq MiddleFreq], get(ax, 'YLim'), 'Color', 'red', 'LineWidth', 2);    
else
    Ffit = DefJacFw(v_MHz, VarWidths, NumComp, IsPair);    
    Fout = Ffit(jx);
    plot(v_MHz,Fout./lum_value,'Color','Red')
end

hold off
set(ax,'Tag','SpectreFit')
xlim([v_MHz(1) v_MHz(end)])
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel('\nu (MHz)');
ylabel('Renormalized Luminescence (au)','VerticalAlignment','bottom','HorizontalAlignment','center');

end



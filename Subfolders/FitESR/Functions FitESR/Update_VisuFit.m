function updateFit(v_MHz,jx,spectre,VarWidths, NumComp, IsPair, ax)
%Update ESR fit plot upon mouseclick in VisuFit

axes(ax)

Ffit = DefJacFw(v_MHz, VarWidths, NumComp, IsPair);
Fout = Ffit(jx);

if mean(spectre)>10
    plot(v_MHz,spectre/Fout(end),'Color','Blue')
    hold on
else
    plot(v_MHz,spectre,'Color','Blue')
    hold on
end
plot(v_MHz,Fout/Fout(end),'Color','Red');
hold off
set(ax,'Tag','Axes2')
xlim([v_MHz(1) v_MHz(end)])
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel('\nu (MHz)');
ylabel('Renormalized Luminescence (au)','VerticalAlignment','bottom','HorizontalAlignment','center');

end



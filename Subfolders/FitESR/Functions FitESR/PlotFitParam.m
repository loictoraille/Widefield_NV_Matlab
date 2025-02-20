function PlotFitParam(v_MHz, spectre, ix, iy, x_um, y_um, fname, Fin, Fout, binThr, binning, Calib_Dist, FitMethod, PlotpStart)
%Plot fit starting point and results


if Calib_Dist == 0
    position_string = [' Pixels units: x = ' num2str(ix) '/' num2str(length(x_um)) ', y = ' ...
    num2str(iy) '/' num2str(length(y_um))];
else
    position_string = ['x = ' num2str(round(x_um(ix))) '/' num2str(round(x_um(end))) ' \mum, y = ' num2str(round(y_um(iy)))...
    '/' num2str(round(y_um(end))) ' \mum'];
end

if FitMethod == 4
    method_string = 'Poly Fit';
elseif FitMethod == 1
    method_string = 'Lorentzian Fit';
elseif FitMethod == 5
    method_string = 'Auto Fit';
end
    
figPosition = FigSizePosition(0.5);
fig = figure('Name',[fname '-ESR Spectrum on one point + fit'],'Position',figPosition);

if PlotpStart == 1
    plot(v_MHz,Fin/Fout(end),'-','Color','Green');
    hold on
end
plot(v_MHz,spectre/Fout(end),'-','Color','Blue')
% plot(v_MHz,spectre,'-','Color','Blue')
hold on
plot(v_MHz,Fout/Fout(end),'-','Color','Red');
title({'ESR Spectrum';position_string;['BinThr = ', num2str(binThr), ' ; Binning = ', num2str(binning)];method_string});
ax = gca;
set(ax,'box','off','color','none')  % set box property to off and remove background color
bx = axes('Position',get(ax,'Position'),'YLim',get(ax,'YLim'),'box','on','xtick',[],'ytick',[]);     % create new, empty axes with box but without ticks
axes(ax);    % set original axes as active 
linkaxes([ax bx]);  % link axes in case of zooming
xlim([v_MHz(1) v_MHz(end)]) 
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel('\nu (MHz)');
ylabel('Renormalized Luminescence (au)');

% Create second Y axes on the right.
a2 = axes('YAxisLocation', 'Right','Position',bx.Position);
% Hide second plot and adjust scale
a2.Color = 'none';
a2.XTick = [];
a2.TickDir = 'out';
if ~isnan(Fout(end));a2.YLim = ax.YLim*Fout(end);else;a2.YLim = ax.YLim;end
ylabel('Luminescence (au)');
set(get(a2,'YLabel'),'Rotation',-90,'VerticalAlignment','bottom','HorizontalAlignment','center');
axes(ax);    % set new axes as active 

end
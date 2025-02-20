function plotESRSp(spectre, ix, iy, v_MHz, x_um, y_um, fname, BinThr, Binning, Calib_Dist, secondAxis, withTitle, FigureSize, TreatedDataPath, saveESR)
% plot an ESR spectrum

renorm = GetRenormValue(spectre);

if Calib_Dist == 0
    position_string = [' Pixels units: x = ' num2str(ix) '/' num2str(length(x_um)) ', y = ' ...
    num2str(iy) '/' num2str(length(y_um))];
else
    position_string = ['x = ' num2str(round(x_um(ix))) '/' num2str(round(x_um(end))) ' \mum, y = ' num2str(round(y_um(iy)))...
    '/' num2str(round(y_um(end))) ' \mum'];
end

% fig = figure('Name',[fname '-ESR Spectrum on one point'],'Position',[580,350,700,450]);
fig = figure('Name',[fname '-ESR Spectrum on point' '_x-' num2str(ix) '_y-' num2str(iy)],'Position',FigSizePosition(FigureSize));

plot(v_MHz,spectre/renorm,'Color','Blue')
if withTitle
    title({'ESR Spectrum';position_string;['BinThr = ', num2str(BinThr), ' ; Binning = ', num2str(Binning)];''});
end
ax = gca;
xlabel('\nu (MHz)');
xlim([round(v_MHz(1),-1) round(v_MHz(end),-1)])
% ylim([0.97 1.005]);
ylabel('Renormalized Luminescence (a.u.)','VerticalAlignment','bottom','HorizontalAlignment','center'); 
ax.TickDir = 'out';
% the following to add box but erase ticks on the upper and right part of box
set(ax,'box','off','color','none')  % set box property to off and remove background color
bx = axes('Position',get(ax,'Position'),'YLim',get(ax,'YLim'),'YAxisLocation', 'Right','XAxisLocation', 'Top','box','off','xtick',[],'ytick',[]);     % create new, empty axes on top and right without ticks
axes(ax);    % set original axes as active 
% linkaxes([ax bx], 'xy');  % link axes in case of zooming? not the right function

if secondAxis
    
% Create second Y axes on the right.
a2 = axes('YAxisLocation', 'Right','Position',bx.Position);
% Hide second plot and adjust scale
a2.Color = 'none';
a2.XTick = [];
a2.TickDir = 'out';
a2.YLim = ax.YLim*renorm;
ylabel('Luminescence (au)');
set(get(a2,'YLabel'),'Rotation',-90,'VerticalAlignment','bottom','HorizontalAlignment','center');
axes(ax);    % set new axes as active 

end

    if saveESR == 1
        saveas(fig,[TreatedDataPath '\' fname(1:end-4) '-ESR Spectrum' '_x-' num2str(ix) '_y-' num2str(iy) '.png'],'png');
        saveas(fig,[TreatedDataPath '\' fname(1:end-4) '-ESR Spectrum' '_x-' num2str(ix) '_y-' num2str(iy) '.svg'],'svg');
        saveas(fig,[TreatedDataPath '\' fname(1:end-4) '-ESR Spectrum' '_x-' num2str(ix) '_y-' num2str(iy) '.pdf'],'pdf');

        M = [v_MHz spectre/renorm];
        writematrix(M,[TreatedDataPath '\' fname(1:end-4) '-ESR Spectrum' '_x-' num2str(ix) '_y-' num2str(iy) '.txt'],'Delimiter','tab');
    end


end
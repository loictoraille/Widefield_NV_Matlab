function plotMiddleFreq(FM, ESRMatrix, PlotScale, fname, size_pix, Calib_Dist, Cropping_Coord)

[h, w, ~] = size(ESRMatrix);
[~, ~, ~, ~, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);

if Calib_Dist == 1
    [x_axis, y_axis] = xyAxes_um(wcrop,hcrop,size_pix);
    xlabel_str = 'x (\mum)';
    ylabel_str = 'y (\mum)';
else 
    [x_axis, y_axis] = xyAxes(wcrop,hcrop);
    xlabel_str = 'x (pixels)';
    ylabel_str = 'y (pixels)';
end

if PlotScale(1) == 0
    StdforRescalingTeslas = 5;
    FMmin = mean(mean(FM,'omitnan'),'omitnan') - StdforRescalingTeslas*std(std(FM,'omitnan'),'omitnan');
    FMmax = mean(mean(FM,'omitnan'),'omitnan') + StdforRescalingTeslas*std(std(FM,'omitnan'),'omitnan');
else
    FMmin = PlotScale(1);
    FMmax = PlotScale(2);
end

% imagesc(x_axis,y_axis,FM);
imagesc(x_axis,y_axis,FM,'AlphaData',~isnan(FM));
%  pcolor([FM nan(hcrop,1); nan(1,wcrop+1)]);
%  pcolor(FM);
%  shading flat;
%  set(gca, 'ydir', 'reverse');
title({[fname '-Middle frequency (MHz)'];''},'Interpreter','none');
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel(xlabel_str);
ylabel(ylabel_str);
caxis([FMmin,FMmax]);
c = colorbar;
c.FontSize = 10.5;
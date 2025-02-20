function fig = plotSplittings(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName)

[h, w, ~] = size(ESRMatrix);

[x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);

if Calib_Dist == 1
    [x_axis, y_axis] = xyAxes_um(wcrop,hcrop,size_pix);
    xlabel_str = 'x (\mum)';
    ylabel_str = 'y (\mum)';
else 
    [x_axis, y_axis] = xyAxes(wcrop,hcrop);
    xlabel_str = 'x (pixels)';
    ylabel_str = 'y (pixels)';
end
    
if NumComp == 4    
    
%     FMmin1 = 2898;
%     FMmax1 = 2903;
%     FMmin2 = 2898;
%     FMmax2 = 2903;
%     FMmin3 = 2880;
%     FMmax3 = 2885;
%     FMmin4 = 2858;
%     FMmax4 = 2863;

    fig = figure('Name',[fname '-Contrast map'],'Position',[400,100,900,550]);     

    subplot(2,2,1); 
    imagesc(FitTot(:,:,9));
    title({'Splitting 1'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
%     caxis([FMmin1,FMmax1]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,2,2); 
    imagesc(FitTot(:,:,10));
    title({'Splitting 2'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
%     caxis([FMmin2,FMmax2]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,2,3); 
    imagesc(FitTot(:,:,11));
    title({'Splitting 3'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
%     caxis([FMmin3,FMmax3]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,2,4); 
    imagesc(FitTot(:,:,12));
    title({'Splitting 4'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
%     caxis([FMmin4,FMmax4]);
    c = colorbar;
    c.FontSize = 10.5;
    
elseif NumComp == 1 && FitMethod == 1

    C1 = FitTot(:,:,1);
    C2 = FitTot(:,:,2);
    FD = FitTot(:,:,3);
    FM = FitTot(:,:,4);
    FW1 = FitTot(:,:,5);
    FW2 = FitTot(:,:,6);
    
    C1min = PlotScale{1};
    C1max = PlotScale{2};
    C2min = PlotScale{3};
    C2max = PlotScale{4};
    FMmin = PlotScale{5};
    FMmax = PlotScale{6};
    FDmin = PlotScale{7};
    FDmax = PlotScale{8};
    FW1min = PlotScale{9};
    FW1max = PlotScale{10};
    FW2min = PlotScale{11};
    FW2max = PlotScale{12};
    Bmin = PlotScale{13};
    Bmax = PlotScale{14};    

    fig = figure('Name',[fname '-AllComponents'],'Position',[300,100,1350,750]);

    subplot(2,4,2);
    imagesc(x_axis,y_axis,100*C1);
    title({'Contrast of left peak (%)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([C1min,C1max]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,4,6);
    imagesc(x_axis,y_axis,100*C2);
    title({'Contrast of right peak (%)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([C2min,C2max]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,4,3);
    imagesc(x_axis,y_axis,FW1);
    title({'Width of left peak (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FW1min,FW1max]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,4,7);
    imagesc(x_axis,y_axis,FW2);
    title({'Width of right peak (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FW2min,FW2max]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,4,4);
    imagesc(x_axis,y_axis,FD);
    title({'Splitting (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FDmin,FDmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,4,8);
    if B0 == 0
        title({'Magnetic field (mT)';''});
    else
        title({'Magnetic field (mT)';['B0 = ' num2str(B0) ' mT']});
    end
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bmin,Bmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,4,1);
    imagesc(x_axis,y_axis,squeeze(ESRMatrix(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,1)));
    title({'PL (a.u.)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,4,5);
    imagesc(x_axis,y_axis,FM);
    title({'Middle frequency (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FMmin,FMmax]);
    c = colorbar;
    c.FontSize = 10.5;
    
elseif NumComp == 0.5 && FitMethod == 1

    C = FitTot(:,:,1);
    FM = FitTot(:,:,2);
    FW = FitTot(:,:,3);
    
    Cmin = PlotScale{1};
    Cmax = PlotScale{2};
    FMmin = PlotScale{3};
    FMmax = PlotScale{4};
    FWmin = PlotScale{5};
    FWmax = PlotScale{6};    

    fig = figure('Name',[fname '-AllComponents'],'Position',[200,75,1050,650]);

    subplot(2,2,3);
    imagesc(x_axis,y_axis,100*C);
    title({'Contrast (%)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Cmin,Cmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,4);
    imagesc(x_axis,y_axis,FW);
    title({'Width (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FWmin,FWmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,1);
    imagesc(x_axis,y_axis,squeeze(ESRMatrix(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,1)));
    title({'PL (a.u.)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,2);
    imagesc(x_axis,y_axis,FM);
    title({'Middle frequency (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FMmin,FMmax]);
    c = colorbar;
    c.FontSize = 10.5;
    
elseif NumComp == 1 && FitMethod == 4
    
    FD = FitTot(:,:,3);
    FM = FitTot(:,:,4);
    B = Bxyz;        
    
    FMmin = PlotScale{5};
    FMmax = PlotScale{6};
    FDmin = PlotScale{7};
    FDmax = PlotScale{8};
    Bmin = PlotScale{13};
    Bmax = PlotScale{14};    

    fig = figure('Name',[fname '-AllComponents'],'Position',[300,100,1350,750]);

    subplot(2,2,2);
    imagesc(x_axis,y_axis,FD);
    title({'Splitting (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FDmin,FDmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,4);
    imagesc(x_axis,y_axis,B);
    
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bmin,Bmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,1);
    imagesc(x_axis,y_axis,squeeze(ESRMatrix(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,1)));
    title({'PL (a.u.)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,3);
    imagesc(x_axis,y_axis,FM);
    title({'Middle frequency (MHz)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FMmin,FMmax]);
    c = colorbar;
    c.FontSize = 10.5;  

end
end


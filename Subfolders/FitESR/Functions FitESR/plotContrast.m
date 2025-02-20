function fig = plotContrast(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName)

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
 
    ct11min = 0.001;
    ct11max = 0.013;
    ct12min = 0.001;
    ct12max = 0.015;
    ct21min = 0.002;
    ct21max = 0.007;
    ct22min = 0.003;
    ct22max = 0.009;
    ct31min = 0.002;
    ct31max = 0.014;
    ct32min = 0.004;
    ct32max = 0.016;
    ct41min = 0.002;
    ct41max = 0.014;
    ct42min = 0.002;
    ct42max = 0.014;
    
    ctmin = 0.002;
    ctmax = 0.014;
    
    choix = 1;

	if choix == 0
        ct11min = ctmin;
        ct11max = ctmax;
        ct12min = ctmin;
        ct12max = ctmax;
        ct21min = ctmin;
        ct21max = ctmax;
        ct22min = ctmin;
        ct22max = ctmax;
        ct31min = ctmin;
        ct31max = ctmax;
        ct32min = ctmin;
        ct32max = ctmax;
        ct41min = ctmin;
        ct41max = ctmax;
        ct42min = ctmin;
        ct42max = ctmax;
    end

%     poslum = [0.15 0.55 0.28 0.4];

    fig = figure('Name',[fname '-Contrast map'],'Position',[400,100,900,550]);
    
%     suptitle2(strrep(SaveName,'_','-'))
    
%     subplot('position',poslum); 
%     imagesc(x_axis,y_axis,squeeze(ESRMatrix(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,1)));
%     title({'PL (a.u.)'});
%     axis('image');
%     ax = gca;
%     ax.XAxisLocation = 'bottom';
%     ax.TickDir = 'out';
%     xlabel(xlabel_str);
%     ylabel(ylabel_str);
%     c = colorbar;
%     c.FontSize = 10.5;    

    subplot(2,4,1); 
    imagesc(FitTot(20:366,15:244,1));
    title({'contraste c11'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct11min,ct11max]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,4,5);
    imagesc(FitTot(20:366,15:244,2));
    title({'contraste c12'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct12min,ct12max]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,4,2); 
    imagesc(FitTot(5:340,15:244,3));
    title({'contraste c21'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct21min,ct21max]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,4,6);  
    imagesc(FitTot(5:340,15:244,4));
    title({'contraste c22'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct22min,ct22max]);
    c = colorbar;
    c.FontSize = 10.5;
    

    subplot(2,4,3); 
    imagesc(FitTot(35:355,15:244,5));
    title({'contraste c31'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct31min,ct31max]);
    c = colorbar;
    c.FontSize = 10.5;
    

    subplot(2,4,7); 
    imagesc(FitTot(30:355,15:244,6));
    title({'contraste c32'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct32min,ct32max]);
    c = colorbar;
    c.FontSize = 10.5;
    

    subplot(2,4,4); 
    imagesc(FitTot(40:350,15:244,7));
    title({'contraste c41'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct41min,ct41max]);
    c = colorbar;
    c.FontSize = 10.5;

    

    subplot(2,4,8);
    imagesc(FitTot(40:350,14:244,8));
    title({'contraste c42'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([ct42min,ct42max]);
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


function fig = plotField(FitTot, Bxyz, B0, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName)

if NumComp ~= 0.5
B0_x = roundn(mean(mean(B0(:,:,1))),-2);
B0_y = roundn(mean(mean(B0(:,:,2))),-2);
B0_z = roundn(mean(mean(B0(:,:,3))),-2);
end

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

    Bx_exp = Bxyz(:,:,1);
    By_exp = Bxyz(:,:,2);
    Bz_exp = Bxyz(:,:,3);
   
    Bn_exp = sqrt(Bx_exp(:,:).^2 + By_exp(:,:).^2 + Bz_exp(:,:).^2);
    
    Bxmin = PlotScale{1};
    Bxmax = PlotScale{2};
    Bymin = PlotScale{3};
    Bymax = PlotScale{4};
    Bzmin = PlotScale{5};
    Bzmax = PlotScale{6};
    Bnmin = PlotScale{7};
    Bnmax = PlotScale{8};

    posx = [0.05 0.07 0.28 0.4];
    posy = [0.38 0.07 0.28 0.4];
    posz = [0.71 0.07 0.28 0.4];
    poslum = [0.15 0.55 0.28 0.4];
    posn = [0.57 0.55 0.28 0.4]; 

    fig = figure('Name',[fname '-Magnetic field map'],'Position',[400,100,900,550]);
    
    suptitle2(strrep(SaveName,'_','-'))
    
    subplot('position',poslum); 
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

    subplot('position',posx); 
    imagesc(x_axis,y_axis,Bx_exp(:,:));
    if B0_x == 0
        title({'Bx (mT)'});
    else
        title({['Bx (mT), Bx0 = ' num2str(B0_x) ' mT']});
    end
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bxmin,Bxmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot('position',posy); 
    imagesc(x_axis,y_axis,By_exp(:,:));
    if B0_y == 0
        title({'By (mT)'});
    else
        title({['By (mT), By0 = ' num2str(B0_y) ' mT']});
    end
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bymin,Bymax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot('position',posz); 
    imagesc(x_axis,y_axis,Bz_exp(:,:));
    if B0_z == 0
        title({'Bz (mT)'});
    else
        title({['Bz (mT), Bz0 = ' num2str(B0_z) ' mT']});
    end
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bzmin,Bzmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot('position',posn);  
    imagesc(x_axis,y_axis,Bn_exp(:,:));
    title({'||B|| (mT)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bnmin,Bnmax]);
    c = colorbar;
    c.FontSize = 10.5;
    
elseif FitMethod == 7 || FitMethod == 8
    
    FM = FitTot(:,:,4);
    FMmin = PlotScale{5};
    FMmax = PlotScale{6};
    
    fig = figure('Name',[fname '-FastFitMethod'],'Position',[300,100,1350,750]);
    
    subplot(1,2,1)    
    imagesc(x_axis,y_axis,squeeze(ESRMatrix(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,1)));
    title({'PL (a.u.)';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    c = colorbar;
    c.FontSize = 10.5;
    
    subplot(1,2,2)
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
    
elseif NumComp == 2    
    
    Bx_exp = Bxyz(:,:,1);
    By_exp = Bxyz(:,:,2);
   
    Bn_exp = sqrt(Bx_exp(:,:).^2 + By_exp(:,:).^2);
    
    Bxmin = PlotScale{13};
    Bxmax = PlotScale{14};
    Bymin = PlotScale{15};
    Bymax = PlotScale{16};
    Bnmin = PlotScale{17};
    Bnmax = PlotScale{18};
    
    C1 = FitTot(:,:,1);
    C2 = FitTot(:,:,2);
    C3 = FitTot(:,:,3);
    C4 = FitTot(:,:,4);
    FD1 = FitTot(:,:,5);
    FD2 = FitTot(:,:,6);
    
    C1min = PlotScale{1};
    C1max = PlotScale{2};
    C2min = PlotScale{3};
    C2max = PlotScale{4};
    C3min = PlotScale{5};
    C3max = PlotScale{6};    
    C4min = PlotScale{7};
    C4max = PlotScale{8};  
    FD1min = PlotScale{9};
    FD1max = PlotScale{10}; 
    FD2min = PlotScale{11};
    FD2max = PlotScale{12};
    
    fig1 = figure('WindowStyle','normal','Name',[fname '-Fit results'],'Position',[100,250,900,550]);
    
    suptitle2(strrep(SaveName,'_','-'))
        
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
    imagesc(x_axis,y_axis,Bx_exp(:,:));
    if B0_x == 0
        title({'Bx (mT)'});
    else
        title({['Bx (mT), Bx0 = ' num2str(B0_x) ' mT']});
    end
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bxmin,Bxmax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,4); 
    imagesc(x_axis,y_axis,By_exp(:,:));
    if B0_y == 0
        title({'By (mT)'});
    else
        title({['By (mT), By0 = ' num2str(B0_y) ' mT']});
    end
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bymin,Bymax]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,2,2);  
    imagesc(x_axis,y_axis,Bn_exp(:,:));
    title({'||B|| (mT)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([Bnmin,Bnmax]);
    c = colorbar;
    c.FontSize = 10.5;    
    
    fig2 = figure('WindowStyle','normal','Name',[fname '-Fit results'],'Position',[1100,100,1350,825]);
    suptitle2(strrep(SaveName,'_','-'))
    
    subplot(2,3,1);
    imagesc(x_axis,y_axis,100*C1);
    title({'Contrast of peak 1 (%)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([C1min,C1max]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,3,2);
    imagesc(x_axis,y_axis,100*C2);
    title({'Contrast of peak 2 (%)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([C2min,C2max]);
    c = colorbar;
    c.FontSize = 10.5;    
    
    subplot(2,3,4);
    imagesc(x_axis,y_axis,100*C3);
    title({'Contrast of peak 3 (%)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([C3min,C3max]);
    c = colorbar;
    c.FontSize = 10.5;

    subplot(2,3,5);
    imagesc(x_axis,y_axis,100*C4);
    title({'Contrast of peak 4 (%)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([C4min,C4max]);
    c = colorbar;
    c.FontSize = 10.5;     
    
    subplot(2,3,3);
    imagesc(x_axis,y_axis,FD1);
    title({'Splitting 1 (MHz)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FD1min,FD1max]);
    c = colorbar;
    c.FontSize = 10.5;    

    subplot(2,3,6);
    imagesc(x_axis,y_axis,FD2);
    title({'Splitting 2 (MHz)'});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([FD2min,FD2max]);
    c = colorbar;
    c.FontSize = 10.5; 
    
    fig = {fig1,fig2};
    
elseif NumComp == 1 

    C1 = FitTot(:,:,1);
    C2 = FitTot(:,:,2);
    FD = FitTot(:,:,3);
    FM = FitTot(:,:,4);
    FW1 = FitTot(:,:,5);
    FW2 = FitTot(:,:,6);
    B = Bxyz;        
    B0 = roundn(mean(mean(B0(:,:,1))),-2);
    
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
    imagesc(x_axis,y_axis,B);
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
    B0 = roundn(mean(mean(B0(:,:,1))),-2);
    
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


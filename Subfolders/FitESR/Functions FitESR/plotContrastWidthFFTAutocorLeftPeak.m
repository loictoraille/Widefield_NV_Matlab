function fig = plotContrastWidthFFTAutocorLeftPeak(FitTot, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName)

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

    C1 = FitTot(:,:,1);
    C2 = FitTot(:,:,2);
    FD = FitTot(:,:,3);
    FM = FitTot(:,:,4);
    FW1 = FitTot(:,:,5);
    FW2 = FitTot(:,:,6);

    C1_renorm = C1 - mean(C1)
    FW1_renorm = FW1 - mean(FW1)

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


    subplot(2,4,1);
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


    subplot(2,4,5);
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



    subplot(2,4,2);
    FFT_contrastleft = fft2(C1_renorm);
    AbsFFTcontrastleft = log(1 + abs(fftshift(FFT_contrastleft)));
    imagesc(AbsFFTcontrastleft);
    title({'FFT Contrast left peak';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('Kx (pixels-1)');
    ylabel('Ky (pixels-1)');
    caxis([min(AbsFFTcontrastleft,[],'all'),max(AbsFFTcontrastleft,[],'all')]);
    c = colorbar;
    c.FontSize = 10.5;

    [rows, column] = size(FFT_contrastleft);
    for i=1:rows
        for j=1:column
            if AbsFFTcontrastleft(i,j)>0.3
                FFT_contrastleft(i,j)=0;
                AbsFFTcontrastleft(i,j)=0;
            else
            end
        end
    end

    subplot(2,4,3);
    FFTinv_contrastleft = ifft2(FFT_contrastleft);
    imagesc(FFTinv_contrastleft);
    title({'Contrast left peak after filtering';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels');
    ylabel('y (pixels)');
    caxis([min(FFTinv_contrastleft,[],'all'),max(FFTinv_contrastleft,[],'all')]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,4,7);
    imagesc(AbsFFTcontrastleft);
    title({'FFT contrast left peak after filtering';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('Kx (pixels-1');
    ylabel('Ky (pixels-1)');
    caxis([min(AbsFFTcontrastleft,[],'all'),max(AbsFFTcontrastleft,[],'all')]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,4,6);
    FFT_Widthleft = fft2(FW1_renorm);
    AbsFFTwidthleft = log(1 + abs(fftshift(FFT_Widthleft)));
    imagesc(AbsFFTwidthleft);
    title({'FFT Width left peak';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('Kx (pixels-1)');
    ylabel('Ky (pixels-1)');
    caxis([min(AbsFFTwidthleft,[],'all'),max(AbsFFTwidthleft,[],'all')]);
    c = colorbar;
    c.FontSize = 10.5;



    subplot(2,4,4);
    Autocor_contrastleft = xcorr2(C1_renorm);
    imagesc(Autocor_contrastleft);
    title({'Autocorrelation Contrast left peak';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([min(Autocor_contrastleft,[],'all'),max(Autocor_contrastleft,[],'all')]);
    c = colorbar;
    c.FontSize = 10.5;


    subplot(2,4,8);
    Autocor_Widthleft = xcorr2(FW1_renorm);
    imagesc(Autocor_Widthleft);
    title({'Autocorrelation Width left peak';''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    caxis([min(Autocor_Widthleft,[],'all'),max(Autocor_Widthleft,[],'all')]);
    c = colorbar;
    c.FontSize = 10.5;


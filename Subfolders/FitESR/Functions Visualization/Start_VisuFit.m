


if CalibDist == 1
    [x_axis, y_axis] = xyAxes_um(wcrop,hcrop,size_pix);
else
    [x_axis, y_axis] = xyAxes(wcrop,hcrop);
end    

axes(Ax1)
imagesc(x_axis,y_axis,squeeze(ESRMatrix(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,5)));
Ax1.Toolbar.Visible = 'off';
set(Ax1,'Tag','EsrImg')
axis('image');
Ax1.XAxisLocation = 'bottom';
Ax1.TickDir = 'out';
if CalibDist == 1
xlabel('x (\mum)');
ylabel('y (\mum)');
else
xlabel('x (pixels)');
ylabel('y (pixels)');  
end
c = colorbar;
c.FontSize = 10.5; 

axes(Ax2)
ix = floor(wcrop/2); iy = floor(hcrop/2);
[spectre,~] = extractEsrThr(ESRMatrix, ix+x_start-1, iy+y_start-1, BinThr);
spectre = PerformTreatmentOperations(spectre, v_MHz, Smoothing_Factor, Detrending_Factor, ClearFFT,RemPositive);
lum_value = GetRenormValue(spectre);
jx = squeeze(FitTot(iy,ix,:));
if mean(spectre)>10
    plot(v_MHz,spectre./lum_value,'Color','Blue')
    hold on
else
    plot(v_MHz,spectre,'Color','Blue')
    hold on
end

if FitParameters.FitMethod == 7 || FitParameters.FitMethod ==  8
    MiddleFreq = jx(4);
    line(Ax2, [MiddleFreq MiddleFreq], get(Ax2, 'YLim'), 'Color', 'red', 'LineWidth', 2);    
else
    Ffit = DefJacFw(v_MHz, VarWidths, NumComp, IsPair);    
    Fout = Ffit(jx);
    plot(v_MHz,Fout./lum_value,'Color','Red')
end

hold off
set(Ax2,'Tag','SpectreFit')
xlim([v_MHz(1) v_MHz(end)])
Ax2.XAxisLocation = 'bottom';
Ax2.TickDir = 'out';
xlabel('\nu (MHz)');
ylabel('Renormalized Luminescence (au)','VerticalAlignment','bottom','HorizontalAlignment','center');

ix = ix +x_start-1;
iy = iy +y_start-1;

axes(Ax4)
clear tmp
tmp = squeeze(ESRMatrix(y_start:end-y_stoptoend-1,ix,:)); % to define the right size

for iyit= 1:length(ESRMatrix(y_start:end-y_stoptoend-1,ix,1))
    tmp(iyit,:) = squeeze(ESRMatrix(iyit,ix,:))'/mean(squeeze(ESRMatrix(iyit,ix,:))) ;
end

imsc4 = imagesc(1:length(ESRMatrix(y_start:end-y_stoptoend-1,1,1)), v_MHz,tmp(:,:)');
Ax4.Toolbar.Visible = 'off';
Ax4.XAxisLocation = 'bottom';
Ax4.TickDir = 'out';
ylabel('\nu (MHz)');
xlabel('y (pixels)');
view([-90 -90])
caxis([colorbarmin,colorbarmax]);
colormap default

set(Ax4,'Tag','EsrImgyNU')
set(imsc4,'Tag','ImEsrImgyNU')


axes(Ax3)
clear tmp
tmp = squeeze(ESRMatrix(iy,x_start:end-x_stoptoend-1,:)); % to define the right size

for ixit= 1:length(ESRMatrix(iy,x_start:end-x_stoptoend-1,1))
    tmp(ixit,:) = squeeze(ESRMatrix(iy,ixit,:))'/mean(squeeze(ESRMatrix(iy,ixit,:))) ;
end

imsc3 = imagesc(1:length(ESRMatrix(1,x_start:end-x_stoptoend-1,1)), v_MHz,tmp(:,:)');
Ax3.Toolbar.Visible = 'off';
Ax3.XAxisLocation = 'bottom';
Ax3.TickDir = 'out';
ylabel('\nu (MHz)');
xlabel('x (pixels)');
caxis([colorbarmin,colorbarmax]);
colormap default

set(Ax3,'Tag','EsrImgxNU')
set(imsc3,'Tag','ImEsrImgxNU')



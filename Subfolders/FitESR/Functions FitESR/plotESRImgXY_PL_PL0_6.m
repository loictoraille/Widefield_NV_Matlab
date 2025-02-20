function plotESRImgXY_PL_PL0_6(EsrImgM, fname, iv, CropOn, Cropping_Coord, CalibDist, size_pix)
%Plot the PL/PL0 image at a given frequency

[h, w, ~] = size(EsrImgM);

if CropOn == 1
    [x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);
else
    [x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,0);
end

if CalibDist == 1
    [x_axis, y_axis] = xyAxes_um(wcrop,hcrop,size_pix);
else
    [x_axis, y_axis] = xyAxes(wcrop,hcrop);
end    

img_name = [fname '-PL image'];

fig = figure('Name',img_name,'Position',[500,100,500,625]);

subplot(2,3,1)
imagesc(x_axis,y_axis,squeeze(EsrImgM(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,1)));  
title({'PL/PL0' ; ''});
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
if CalibDist == 1
xlabel('x (\mum)');
ylabel('y (\mum)');
else
xlabel('x (pixels)');
ylabel('y (pixels)');  
end
c = colorbar;
c.FontSize = 10.5; 

subplot(2,3,2)
imagesc(x_axis,y_axis,squeeze(EsrImgM(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,2)));  
title({'PL/PL0' ; ''});
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
if CalibDist == 1
xlabel('x (\mum)');
ylabel('y (\mum)');
else
xlabel('x (pixels)');
ylabel('y (pixels)');  
end
c = colorbar;
c.FontSize = 10.5; 

subplot(2,3,3)
imagesc(x_axis,y_axis,squeeze(EsrImgM(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,3)));  
title({'PL/PL0' ; ''});
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
if CalibDist == 1
xlabel('x (\mum)');
ylabel('y (\mum)');
else
xlabel('x (pixels)');
ylabel('y (pixels)');  
end
c = colorbar;
c.FontSize = 10.5; 

subplot(2,3,4)
imagesc(x_axis,y_axis,squeeze(EsrImgM(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,4)));  
title({'PL/PL0' ; ''});
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
if CalibDist == 1
xlabel('x (\mum)');
ylabel('y (\mum)');
else
xlabel('x (pixels)');
ylabel('y (pixels)');  
end
c = colorbar;
c.FontSize = 10.5; 

subplot(2,3,5)
imagesc(x_axis,y_axis,squeeze(EsrImgM(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,5)));  
title({'PL/PL0' ; ''});
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
if CalibDist == 1
xlabel('x (\mum)');
ylabel('y (\mum)');
else
xlabel('x (pixels)');
ylabel('y (pixels)');  
end
c = colorbar;
c.FontSize = 10.5; 

subplot(2,3,6)
imagesc(x_axis,y_axis,squeeze(EsrImgM(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,6)));  
title({'PL/PL0' ; ''});
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
if CalibDist == 1
xlabel('x (\mum)');
ylabel('y (\mum)');
else
xlabel('x (pixels)');
ylabel('y (pixels)');  
end
c = colorbar;
c.FontSize = 10.5; 

end

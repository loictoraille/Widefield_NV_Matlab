function plotESRImgXY(EsrImgM, fname, iv, CropOn, Cropping_Coord, CalibDist, size_pix, titleFIG)
%Plot the photoluminescence image at a given frequency

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

imagesc(x_axis,y_axis,squeeze(EsrImgM(y_start:end-y_stoptoend-1,x_start:end-x_stoptoend-1,iv)));  
title({titleFIG ; ''});
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


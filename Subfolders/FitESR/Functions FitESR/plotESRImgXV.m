function plotESRImgXV(ESRMatrix, fname, ix, v_MHz, CropOn, Cropping_Coord, CalibDist, size_pix) 
    
[h, w, ~] = size(ESRMatrix);

if CropOn == 1
    [~, y_start, ~, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);
else
    [~, y_start, ~, y_stoptoend, wcrop, hcrop] = Cropping(w,h,0);
end

if CalibDist == 1
    [~, y_axis] = xyAxes_um(wcrop,hcrop,size_pix);
    [x_axis, ~] = xyAxes_um(w,h,size_pix);   % only y is cropped for this representation
else
    [~, y_axis] = xyAxes(wcrop,hcrop);
    [x_axis, ~] = xyAxes(w,h);   % only y is cropped for this representation
end

tmp = squeeze(ESRMatrix(y_start:end-y_stoptoend-1,ix,:)); % to define the right size

for iy=y_start:h-y_stoptoend-1
    tmp(iy-y_start+1,:) = squeeze(ESRMatrix(iy,ix,:))'/mean(squeeze(ESRMatrix(iy,ix,:))) ;
end

fig = figure('Name',[fname '-ESR as a function of y for a chosen x'],'Position',[280,70,550,700]);

imagesc(v_MHz,y_axis,tmp(:,:)); 
if CalibDist == 1
title({['ESR along y for a chosen x = ' num2str(round(x_axis(ix))) '/' num2str(round(x_axis(end))) ' \mum'];''});
else    
title({['ESR along y for a chosen x = ' num2str(round(x_axis(ix))) '/' num2str(round(x_axis(end))) ' pixels'];''});
end
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel('\nu (MHz)');
if CalibDist == 1
ylabel('y (\mum)');
else
ylabel('y (pixels)');
end
caxis([0.99,1.05]);
colormap(default)

end



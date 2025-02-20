function Current_plotB(Bx,By,Bz,fignum,scale,figname)
%CURRENT_PLOTB Summary of this function goes here
%   Detailed explanation goes here
f = figure(fignum);
set(f, 'NumberTitle', 'off', 'Name',figname);
clims = [-0.1 0.1];
subplot(3,1,1)
if scale == 1
    imagesc(Bx,clims)
else
    imagesc(Bx)
end
axis('image')
axis off
title('Bx (mT)')
colorbar

subplot(3,1,2)
if scale == 1
    imagesc(By,clims)
else
    imagesc(By)
end
axis('image')
axis off
title('By (mT)')
colorbar

subplot(3,1,3)
if scale == 1
    imagesc(Bz,clims)
else
    imagesc(Bz)
end
axis('image')
title('Bz (mT)')
axis off
colorbar
colormap(fignum,jet)
end


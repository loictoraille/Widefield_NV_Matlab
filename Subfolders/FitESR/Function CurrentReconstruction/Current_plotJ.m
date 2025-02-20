function Current_plotJ(Jx,Jy,J,fignum,scale,figname)
%CURRENT_PLOTJ Summary of this function goes here
%   Detailed explanation goes here
f = figure(fignum);
set(f, 'NumberTitle', 'off', 'Name',figname);
clims = [-100 100];
subplot(3,1,1)
if scale == 1
    imagesc(Jx,clims)
else
    imagesc(Jx)
end
axis('image')
title('Jx')
axis off
colorbar

subplot(3,1,2)
if scale == 1
    imagesc(Jy,clims)
else
    imagesc(Jy)
end
axis('image')
title('Jy')
axis off
colorbar

subplot(3,1,3)
if scale == 1
    clims = [0 100];
    imagesc(J,clims)
else
    imagesc(J)
end
axis('image')
title('|J|')
axis off
colorbar
colormap(fignum,jet)
end


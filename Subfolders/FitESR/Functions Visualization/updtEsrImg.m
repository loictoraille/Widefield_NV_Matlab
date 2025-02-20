function updtEsrImg(ESRMatrix, v_MHz, ix, iy, x_start, y_start, x_stoptoend, y_stoptoend)

ix = ix +x_start-1;
iy = iy +y_start-1;

ax=findobj('Tag','EsrImgyNU');
im=findobj('Tag','ImEsrImgyNU');
axes(ax)

tmp = squeeze(ESRMatrix(y_start:end-y_stoptoend-1,ix,:)); % to define the right size

for iyit= 1:length(ESRMatrix(y_start:end-y_stoptoend-1,ix,1))
    tmp(iyit,:) = squeeze(ESRMatrix(iyit+y_start-1,ix,:))'/mean(squeeze(ESRMatrix(iyit+y_start-1,ix,:))) ;
end

set(im,'Cdata',tmp(:,:)');

set(ax,'Tag','EsrImgyNU')

ax=findobj('Tag','EsrImgxNU');
im=findobj('Tag','ImEsrImgxNU');
axes(ax)

clear tmp
tmp = squeeze(ESRMatrix(iy,x_start:end-x_stoptoend-1,:)); % to define the right size

for ixit= 1:length(ESRMatrix(iy,x_start:end-x_stoptoend-1,1))
    tmp(ixit,:) = squeeze(ESRMatrix(iy,ixit+x_start-1,:))/mean(squeeze(ESRMatrix(iy,ixit+x_start-1,:))) ;
end

set(im,'Cdata',tmp(:,:)');

set(ax,'Tag','EsrImgxNU')
end


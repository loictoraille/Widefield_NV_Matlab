
function [B_1dim_out,B0_1dim] = Renormalize1_1dim(B_1dim_in,size_square,y0,x0)           
% x0 et y0 sont inversés par rapport à l'appel de la fonction pour être
% dans le même ordre dans le réglage que l'ordre d'apparition sur les
% figures matlab

[h,w,~] = size(B_1dim_in);

xmin = x0 - floor(size_square/2);
xmax = x0 + ceil(size_square/2);
ymin = y0 - floor(size_square/2);
ymax = y0 + ceil(size_square/2);

B0_1dim = ones(h,w)*mean(mean(B_1dim_in(ymin:ymax,xmin:xmax)));

B_1dim_out = B_1dim_in - B0_1dim;

end

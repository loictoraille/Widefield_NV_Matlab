function [B_out, B0_x, B0_y, B0_z] = Renormalize(Renormalize_Parameters, B)
% first number = renormalize mode, second = side of square for renorm, then 
% (optional) is the center pixel for renorm used in renorm mode 1

% Mode 1: uses the values taken near a point defined by the user
% Mode 3: defines planes using the four corners of the image

[h, w, ~] = size(B);
size_square = Renormalize_Parameters(2);

if Renormalize_Parameters(1) == 3
    if length(size(B)) == 2
        [B_out(:,:,1),B0_x] = Renormalize3_1dim(B(:,:,1),size_square,h,w);
        B0_y = zeros(h,w);
        B0_z = zeros(h,w);
    else
        [B_out(:,:,1),B0_x] = Renormalize3_1dim(B(:,:,1),size_square,h,w);
        [B_out(:,:,2),B0_y] = Renormalize3_1dim(B(:,:,2),size_square,h,w);
        [B_out(:,:,3),B0_z] = Renormalize3_1dim(B(:,:,3),size_square,h,w);
    end
elseif Renormalize_Parameters(1) == 1    
    y0 = Renormalize_Parameters(3); x0 = Renormalize_Parameters(4);
    if length(size(B)) == 2
        [B_out(:,:,1),B0_x] = Renormalize1_1dim(B(:,:,1),size_square,x0,y0);
        B0_y = zeros(h,w);
        B0_z = zeros(h,w);        
    else
        [B_out(:,:,1),B0_x] = Renormalize1_1dim(B(:,:,1),size_square,x0,y0);
        [B_out(:,:,2),B0_y] = Renormalize1_1dim(B(:,:,2),size_square,x0,y0);
        [B_out(:,:,3),B0_z] = Renormalize1_1dim(B(:,:,3),size_square,x0,y0);
    end
else
    B_out = B;
    B0_x = zeros(h,w);
    B0_y = zeros(h,w);
    B0_z = zeros(h,w);
end

end


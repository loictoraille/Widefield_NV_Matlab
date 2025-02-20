function [B_1dim_out,B0_1dim] = Renormalize3_1dim(B_1dim_in,size_square,h,w)

B0_1dim = zeros(h,w);

xamin=1;xamax=size_square;yamin=1;yamax=size_square;
xbmin=w-size_square+1;xbmax=w;ybmin=1;ybmax=size_square;
xcmin=1;xcmax=size_square;ycmin=h-size_square+1;ycmax=h;
xdmin=w-size_square+1;xdmax=w;ydmin=h-size_square+1;ydmax=h;

B_1dim_ared = B_1dim_in(yamin:yamax,xamin:xamax);
B_1dim_a0 = mean(mean(B_1dim_ared));
B_1dim_bred = B_1dim_in(ybmin:ybmax,xbmin:xbmax);
B_1dim_b0 = mean(mean(B_1dim_bred));
B_1dim_cred = B_1dim_in(ycmin:ycmax,xcmin:xcmax);
B_1dim_c0 = mean(mean(B_1dim_cred));
B_1dim_dred = B_1dim_in(ydmin:ydmax,xdmin:xdmax);
B_1dim_d0 = mean(mean(B_1dim_dred));
        
B_1dim_it1_x = (B_1dim_b0-B_1dim_a0)/(w-1); B_1dim_it2_x = (B_1dim_d0-B_1dim_c0)/(w-1);
B_1dim_it1_y = (B_1dim_c0-B_1dim_a0)/(h-1);

B_1dim_itit = (B_1dim_it2_x-B_1dim_it1_x)/(h-1);

for i=1:w
    B0_1dim(1,i) = B_1dim_a0 + (i-1)*B_1dim_it1_x;
end

for j=2:h
    for i=1:w
        B0_1dim(j,i) = B0_1dim(1,i) + (j-1)*(B_1dim_it1_y + (i-1)*B_1dim_itit);
    end
end

B_1dim_out(:,:,1) = B_1dim_in - B0_1dim;

end
function [filtered_b] = FourierFilter(input_b,x_cut,y_cut)
%FOURIERFILTER Summary of this function goes here
%   Detailed explanation goes here
[h,w] = size(input_b);
filtered_b = input_b;

filtered_b(1:x_cut,:) = 0;
filtered_b((h-x_cut):end,:) = 0;
filtered_b(:,1:y_cut) = 0;
filtered_b(:,(w-y_cut):end) = 0;
end


function Center = GetGaussianCenter(C0)
    [x, y] = meshgrid(1:size(C0, 2), 1:size(C0, 1));
    center_x = sum(sum(x .* C0)) / sum(sum(C0));
    center_y = sum(sum(y .* C0)) / sum(sum(C0));
    Center = [center_x, center_y];
end
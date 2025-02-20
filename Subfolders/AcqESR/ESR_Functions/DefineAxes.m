function [x_axis,y_axis,x_label,y_label] = DefineAxes(AOIParameters)

h = AOIParameters.AOI.Height;
w = AOIParameters.AOI.Width;
size_pix = AOIParameters.PixelCalib_nm/1000; % in µm

if strcmp(AOIParameters.CalibUnit_str,'microns')
    x_axis = size_pix*(1:w);
    y_axis = size_pix*(1:h);
    x_label = 'X (\mum)';
    y_label = 'Y (\mum)';
else
    x_axis = 1:w;
    y_axis = 1:h;
    x_label = 'X (pixels)';
    y_label = 'Y (pixels)';  
end

end
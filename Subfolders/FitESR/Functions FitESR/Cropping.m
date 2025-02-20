function [x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord)
%uses the cropping_coord defined in the same order as the plotESRImgXY representation
%can be use to define a square around a point, or a full zone

if Cropping_Coord(1) == 0
    x_start = 1;y_start = 1;x_stoptoend = -1;y_stoptoend = -1;wcrop = w;hcrop = h;
else
    if length(Cropping_Coord) == 4
        xmid = Cropping_Coord(2);        
        ymid = Cropping_Coord(3);       
        width_crop = Cropping_Coord(4);
        
        x_start = xmid - floor(width_crop/2);
        xcropmax = xmid + ceil(width_crop/2);
        y_start = ymid - floor(width_crop/2);
        ycropmax = ymid + ceil(width_crop/2);
    else 
        x_start = Cropping_Coord(2);
        y_start = Cropping_Coord(3);
        xcropmax = Cropping_Coord(4);
        ycropmax = Cropping_Coord(5);
    end
    x_stoptoend = w - xcropmax;
    y_stoptoend = h - ycropmax;
    wcrop = xcropmax - x_start;
    hcrop = ycropmax - y_start;
end

end
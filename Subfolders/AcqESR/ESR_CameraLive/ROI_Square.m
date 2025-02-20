%%Define a Square ROI by clicking a point

function ROI_Square(object,eventdata)
global ObjCamera CameraType handleImage
h=guidata(gcbo);%handles of the graphical objects

if ~h.acqcont.Value
    FuncROISquare_define(h);
end

end
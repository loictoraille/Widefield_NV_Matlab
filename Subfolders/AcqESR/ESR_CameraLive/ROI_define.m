%%Define a ROI by selecting a rectangle

function ROI_define(object,eventdata)
global ObjCamera CameraType handleImage
h=guidata(gcbo);%handles of the graphical objects

if ~h.acqcont.Value
    FuncROI_define(h);
end

end
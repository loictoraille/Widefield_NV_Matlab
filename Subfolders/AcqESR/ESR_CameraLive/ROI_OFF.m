%%Suppress the ROI, to use full sensor size

function ROI_OFF(hobject,eventdata)
global ObjCamera CameraType
h=guidata(gcbo);%handle of all objects
set(h.roioff,'ForegroundColor',[0,0,1]);%Change button color to blue in the GUI

if ~h.acqcont.Value
    FuncROI_OFF(h);
end

end
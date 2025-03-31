function ROI_BACK(hobject,eventdata)
global ObjCamera CameraType
h=guidata(gcbo);%handle of all objects
set(h.roiback,'ForegroundColor',[0,0,1]);%Change button color to blue in the GUI

if ~h.acqcont.Value
    FuncROI_BACK(h);
end

end
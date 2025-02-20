function ROI_BACK(hobject,eventdata)
global ObjCamera CameraType
h=guidata(gcbo);%handle of all objects
set(h.roiback,'ForegroundColor',[0,1,0]);%Change button color to green in the GUI

if ~h.acqcont.Value
    FuncROI_BACK(h);
end

end
function FindExposure(object,eventdata)
global ObjCamera CameraType
%Function to optimize the Camera Exposure.
%Criteria : Max of intensity = 90% of saturation.
h=guidata(gcbo);%handle of all objects

if ~h.acqcont.Value
    FuncFindExposure(h);
    FuncAcqContinue(h);
end

end

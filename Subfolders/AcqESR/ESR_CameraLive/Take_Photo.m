
function Take_Photo(object,eventdata)
global ObjCamera CameraType
h=guidata(gcbo);%handle of all objects

if ~h.acqcont.Value
    FuncTake_Photo(h);
end

end
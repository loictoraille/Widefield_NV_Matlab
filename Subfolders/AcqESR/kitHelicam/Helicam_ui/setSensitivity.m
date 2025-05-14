function setSensitivity(hObject, ~, heliHandles_local) % Slider callback
global ObjCamera;

val = get(hObject, 'Value');
ObjCamera.sensitivity = val;
set(heliHandles_local.editSensitivity, 'String', sprintf('%.2f', val)); % Update edit box

end
function setSensitivity(hObject, ~) % Slider callback
global ObjCamera;

val = get(hObject, 'Value');
ObjCamera.sensitivity = val;
set(findobj('tag','editSensitivity'), 'String', num2str(val)); % Update edit box

end
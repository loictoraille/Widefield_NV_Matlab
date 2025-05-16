function setModulationFrequency(hObject, ~) % Slider callback
global ObjCamera;

val = get(hObject, 'Value');
ObjCamera.refFrequency = 1000*val;

set(findobj('tag','editModFreq'), 'String', num2str(ObjCamera.refFrequency/1000)); % Update edit box

end
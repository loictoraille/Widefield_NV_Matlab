function setModulationFrequency(hObject, ~, heliHandles_local) % Slider callback
global ObjCamera;

val = get(hObject, 'Value');
ObjCamera.refFrequency = round(val); % Often frequencies are integers

set(heliHandles_local.editModFreq, 'String', num2str(ObjCamera.refFrequency)); % Update edit box

end
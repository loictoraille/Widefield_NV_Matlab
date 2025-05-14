function setCoupling(hObject, eventdata) % Buttongroup callback
global ObjCamera;

selectedString = get(eventdata.NewValue, 'String'); % Get string of selected radio button
ObjCamera.coupling = selectedString;

end
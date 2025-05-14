function setNbFrames(hObject, ~) % eventdata is ~ as it's not used
global ObjCamera;

val = str2double(get(hObject, 'String'));
if isnan(val) || val < 4
    val = 4;
    set(hObject, 'String', num2str(val)); % Update UI
end

ObjCamera.NbFrames = round(val); % Ensure integer

end
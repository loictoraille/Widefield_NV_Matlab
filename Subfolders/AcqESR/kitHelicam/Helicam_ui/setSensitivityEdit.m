function setSensitivityEdit(hObject, ~) % Edit box callback
global ObjCamera;

val = str2double(get(hObject, 'String'));

if isnan(val) || val < 0
    val = 0;
elseif val > 1
    val = 1;
end

% set(hObject, 'String', num2str(val)); % Update edit box (sanitized)

ObjCamera.sensitivity = val;

set(findobj('tag','sldSensitivity'), 'Value', val); % Update slider

end
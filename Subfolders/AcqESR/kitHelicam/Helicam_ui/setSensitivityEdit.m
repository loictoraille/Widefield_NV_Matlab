function setSensitivityEdit(hObject, ~, heliHandles_local) % Edit box callback
global ObjCamera;

val = str2double(get(hObject, 'String'));

if isnan(val) || val < 0
    val = 0;
elseif val > 1
    val = 1;
end

set(hObject, 'String', sprintf('%.2f', val)); % Update edit box (sanitized)

ObjCamera.sensitivity = val;

set(heliHandles_local.sldSensitivity, 'Value', val); % Update slider

end
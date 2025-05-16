function setNPeriods(hObject, ~)
global ObjCamera;

val = str2double(get(hObject, 'String'));
if isnan(val) || val < 4
    val = 4;
    set(hObject, 'String', num2str(val)); % Update UI
end

ObjCamera.NPeriods = round(val); % Ensure integer
hObject.String = num2str(ObjCamera.NPeriods);

end
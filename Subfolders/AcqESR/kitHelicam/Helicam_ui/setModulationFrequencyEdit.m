function setModulationFrequencyEdit(hObject, ~, heliHandles_local) % Edit box callback
global ObjCamera;

val = str2double(get(hObject, 'String'));
modFreqMin = get(heliHandles_local.sldModFreq, 'Min');
modFreqMax = get(heliHandles_local.sldModFreq, 'Max');

if isnan(val) || val < modFreqMin
    val = modFreqMin;
elseif val > modFreqMax
    val = modFreqMax;
end
val = round(val); % Often frequencies are integers
set(hObject, 'String', num2str(val)); % Update edit box (sanitized)

ObjCamera.refFrequency = val;
set(heliHandles_local.sldModFreq, 'Value', val); % Update slider

end
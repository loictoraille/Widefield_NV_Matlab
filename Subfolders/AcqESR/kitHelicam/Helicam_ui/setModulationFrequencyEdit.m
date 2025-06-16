function setModulationFrequencyEdit(hObject, ~) % Edit box callback
global ObjCamera;

val = str2double(get(hObject, 'String'));
modFreqMin = get(findobj('tag','sldModFreq'), 'Min');
modFreqMax = get(findobj('tag','sldModFreq'), 'Max');

if isnan(val) || val < modFreqMin
    val = modFreqMin;
elseif val > modFreqMax
    val = modFreqMax;
end

% set(hObject, 'String', num2str(val)); % Update edit box (sanitized)

ObjCamera.refFrequency = val*1000;
set(findobj('tag','sldModFreq'), 'Value', val); % Update slider

end

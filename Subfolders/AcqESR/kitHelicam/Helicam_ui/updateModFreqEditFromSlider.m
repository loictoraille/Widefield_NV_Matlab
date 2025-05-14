function updateModFreqEditFromSlider(eventData, heliHandles_local) % Listener callback

newValue = round(eventData.AffectedObject.Value); % Frequencies often integers
set(heliHandles_local.editModFreq, 'String', num2str(newValue));

end
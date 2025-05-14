function updateSensitivityEditFromSlider(eventData, heliHandles_local) % Listener callback

newValue = eventdata.AffectedObject.Value;

set(heliHandles_local.editSensitivity, 'String', sprintf('%.2f', newValue));

end
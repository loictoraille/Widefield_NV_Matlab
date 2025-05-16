function updateSensitivityEditFromSlider(~,eventData) % Listener callback

newValue = eventData.AffectedObject.Value;

set(findobj('tag','editSensitivity'), 'String', num2str(newValue)); % Update edit box

end
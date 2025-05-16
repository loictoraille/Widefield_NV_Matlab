function updateModFreqEditFromSlider(~,eventData) % Listener callback

newValue = eventData.AffectedObject.Value; 
set(findobj('tag','editModFreq'), 'String', num2str(newValue)); % Update edit box

end
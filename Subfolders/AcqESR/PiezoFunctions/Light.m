function Light(~,~)

panel = guidata(gcbo);

h=findobj('tag','light');

if h.Value == 1
    LightOn(panel);
else
    LightOff(panel);
end

end
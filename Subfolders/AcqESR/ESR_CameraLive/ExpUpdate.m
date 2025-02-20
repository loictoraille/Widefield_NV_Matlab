%%Callback function for the addlistener of the Exposure Time slider, to update on the
%%fly the value of the slider, printed above the slider. 

function ExpUpdate(source,callbackdata)
h=findobj('tag','sldexp');%Find handle of exposure time slider
h2=findobj('tag','exptext');%Find handle of text box
set(h2,'String',['Exposure = ', num2str(h.Value),' ms']);%update text box
end
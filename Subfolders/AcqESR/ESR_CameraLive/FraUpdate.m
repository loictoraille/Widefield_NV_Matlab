%%Callback function for the addlistener of the Frame Rate slider, to update on the
%%fly the value of the slider, printed above the slider. 

function FraUpdate(source,callbackdata)
h=findobj('tag','sldframe');%Find handle of frame rate slider
h2=findobj('tag','fratext');%Find handle of text box
set(h2,'String',['Frame Rate = ', num2str(h.Value),' Hz']);%update text box
end
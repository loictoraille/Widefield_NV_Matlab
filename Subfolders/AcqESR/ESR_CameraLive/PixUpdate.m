%%Callback function for the addlistener of the Pixel Clock slider, to update on the
%%fly the value of the slider, printed above the slider. 

function PixUpdate(source,callbackdata)
h=findobj('tag','sldpix');%Find handle of pixel clock slider
h2=findobj('tag','pixtext');%Find handle of text box
set(h2,'String',['Pixel Clock = ', num2str(h.Value),' MHz']);%update text box
end
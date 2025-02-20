function Input_PixelClock(source,callbackdata)

h=findobj('tag','sldpix');%Find handle of exposure time slider
h2=findobj('tag','pixtext');%Find handle of text box
h3=findobj('tag','Input_PixelClock');
h.Value=str2double(h3.String);

SetPixelClock(h.Value);
UpdateCameraRanges;%Update ranges


end
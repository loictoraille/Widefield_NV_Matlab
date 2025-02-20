function Input_Exposure(source,callbackdata)

h=findobj('tag','sldexp');%Find handle of exposure time slider
h2=findobj('tag','exptext');%Find handle of text box
h3=findobj('tag','Input_Exp');
h.Value=str2double(h3.String);

SetExp(h.Value);
UpdateCameraRanges;%Update ranges


end
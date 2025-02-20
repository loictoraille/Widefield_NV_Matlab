function Input_FrameRate(source,callbackdata)

h=findobj('tag','sldframe');%Find handle of exposure time slider
h2=findobj('tag','fratext');%Find handle of text box
h3=findobj('tag','Input_FrameRate');
h.Value=str2double(h3.String);

SetFrameRate(h.Value);
UpdateCameraRanges;%Update ranges


end
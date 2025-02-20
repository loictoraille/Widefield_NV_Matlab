%%Callback function of Pixel Clock slider, executed when slider released. Modifies the
%%camera pixel clock + updates ranges of all 3 parameters
%%(ExposureTime/FrameRate/PixelClock)

function SldPix(source,callbackdata)
global ObjCamera CameraType
if exist('ObjCamera','var') && ~isempty(ObjCamera) %Tests if camera opened
h=findobj('tag','sldpix');%Find relevant handle 
SetPixelClock(h.Value);
UpdateCameraRanges;%Update ranges
end
end
%%Callback function of Exposure Time slider, executed when slider released. Modifies the
%%camera exposure time + updates ranges of all 3 parameters
%%(ExposureTime/FrameRate/PixelClock)

function SldExp(source,callbackdata)
global ObjCamera CameraType
if exist('ObjCamera','var') && ~isempty(ObjCamera) %Tests if camera opened
h=findobj('tag','sldexp');%Find relevant handle 
SetExp(h.Value);
UpdateCameraRanges;%Update ranges
end
end

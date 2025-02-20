%%Callback function of Frame Rate slider, executed when slider released. Modifies the
%%camera frame rate + updates ranges of all 3 parameters
%%(ExposureTime/FrameRate/PixelClock)

function SldFra(source,callbackdata)
global ObjCamera CameraType
if exist('ObjCamera','var') && ~isempty(ObjCamera) %Tests if camera opened
h=findobj('tag','sldframe');%Find relevant handle 
SetFrameRate(h.Value);
UpdateCameraRanges;%Update ranges
end
end

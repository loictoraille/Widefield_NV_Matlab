%Update ExposureTime/FrameRate/PixelClock Ranges. When one of the
%parameters is changed, the max/min values of the other parameters can
%change. This function is used to update the min/max values of the sliders
%by querying the min/max value from the camera.

function UpdateCameraRanges()
global ObjCamera CameraType
h=guidata(gcbo);%Handles of the GUI

FuncCameraRanges(h);

guidata(gcbo,h);

end
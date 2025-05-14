
function FuncROI_OFF(h)
global ObjCamera CameraType handleImage

SetAOIMAX();

set(h.roioff,'ForegroundColor',[0,0,0]);%Change button color to black
set(h.roioff,'Value',0);

UpdateImageWithROIScript;

FuncCameraRanges(h);%Update Ranges of the camera parameters/slider (they change with ROI)

end

function FuncROI_BACK(h)
global ObjCamera CameraType handleImage

SetROI_BACK();

set(h.roiback,'ForegroundColor',[0,0,0]);%Change button color to black
set(h.roiback,'Value',0);

UpdateImageWithROI;

FuncCameraRanges(h);%Update Ranges of the camera parameters/slider (they change with ROI)

end
function SetSquareFunction(h,ROISquareSize,CenterX,CenterY)
global ObjCamera CameraType handleImage

ROISquareSize = CheckCamConstraints(ROISquareSize,CameraType);
[NewX,NewY] = CheckBordersAndDefine(CenterX,CenterY,ROISquareSize,CameraType);

SetAOI(NewX,NewY,ROISquareSize,ROISquareSize);

UpdateImageWithROI;

FuncCameraRanges(h);%Update Ranges of the camera parameters/slider (they change with ROI)
end
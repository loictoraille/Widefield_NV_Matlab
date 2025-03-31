function ImageMatrix=TakeCameraImageDouble(ImageSize,AOI)
global ObjCamera CameraType

ImageMatrix=TakeCameraImage(ImageSize,AOI);

ImageMatrix = double(ImageMatrix);

end

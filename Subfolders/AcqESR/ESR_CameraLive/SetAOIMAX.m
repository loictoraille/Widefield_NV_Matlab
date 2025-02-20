
function SetAOIMAX()

global ObjCamera CameraType

[AOIXmin,AOIYmin,AOIWidthMax,AOIHeightMax] = HardWrittenAOIEdges(CameraType);

SetAOI(AOIXmin,AOIYmin,AOIWidthMax,AOIHeightMax);

end
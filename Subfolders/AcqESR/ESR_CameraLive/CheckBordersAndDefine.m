function [NewX,NewY] = CheckBordersAndDefine(CenterX,CenterY,ROISquareSize,CameraType)

[AOIXmin,AOIYmin,AOIWidthMax,AOIHeightMax] = HardWrittenAOIEdges(CameraType);

NewX = CenterX - floor(ROISquareSize/2);
NewY = CenterY - floor(ROISquareSize/2);

if strcmp(CameraType,'Peak')
    NewX =  NewX-mod(NewX,-4);
end

NewX = max(NewX,AOIXmin);
NewX = min(NewX,AOIWidthMax - ROISquareSize);

NewY = max(NewY,AOIYmin);
NewY = min(NewY,AOIHeightMax - ROISquareSize);


end
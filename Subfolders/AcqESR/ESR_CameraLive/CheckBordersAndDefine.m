function [NewX,NewY] = CheckBordersAndDefine(CenterX,CenterY,ROISquareSize,CameraType)

[AOIXmin,AOIYmin,AOIWidthMax,AOIHeightMax] = HardWrittenAOIEdges(CameraType);

NewX = CenterX - floor(ROISquareSize/2);
NewY = CenterY - floor(ROISquareSize/2);

if strcmp(CameraType,'Peak')
    NewX =  NewX-mod(NewX,-4);
end

if strcmpi(CameraType,'Thorlabs')
    % NewX multiple of 16 and newY multiple of 2 imposed by the camera
    NewX =  NewX-mod(NewX,-16);
    NewY =  NewY-mod(NewY,-2);
end


NewX = max(NewX,AOIXmin);
NewX = min(NewX,AOIWidthMax - ROISquareSize);

NewY = max(NewY,AOIYmin);
NewY = min(NewY,AOIHeightMax - ROISquareSize);


end

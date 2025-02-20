function [AOIXmin,AOIYmin,AOIWidthMax,AOIHeightMax] = HardWrittenAOIEdges(CameraType)

if strcmp(CameraType,'Andor')
    AOIXmin = 1;
    AOIYmin = 1;
    AOIWidthMax = 2048;
    AOIHeightMax = 2048;
elseif strcmp(CameraType,'uEye')
    AOIXmin = 0;
    AOIYmin = 0;
    AOIWidthMax = 1280;
    AOIHeightMax = 1024;
elseif strcmp(CameraType,'Peak')
    AOIXmin = 0;
    AOIYmin = 0;
    AOIWidthMax = 1936;
    AOIHeightMax = 1216;    
end

end
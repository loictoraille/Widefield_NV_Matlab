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
elseif strcmp(CameraType,'heliCam')
    AOIXmin = 0;
    AOIYmin = 0;
    AOIWidthMax = 512;
    AOIHeightMax = 542;
elseif strcmpi(CameraType,'Thorlabs')
    AOIXmin = 0;
    AOIYmin = 0;
    AOIWidthMax = 1280;
    AOIHeightMax = 1024;
end

end


function ROISquareSize = CheckCamConstraints(ROISquareSize,CameraType)

[~,~,AOIWidthMax,AOIHeightMax] = HardWrittenAOIEdges(CameraType);

if strcmp(CameraType,'uEye')  
    if ROISquareSize < 16
        disp('Minimum Width with uEye Camera is 16 pixel')
    end
    ROISquareSize = max(16,ROISquareSize-mod(ROISquareSize,-4));
elseif strcmp(CameraType,'Andor')
elseif strcmp(CameraType,'heliCam') % sames as the Andor, they will hardwritten 
elseif strcmp(CameraType,'Peak')
    if ROISquareSize < 256
        disp('Minimum Width with Peak Camera is 256 pixel')
    end
    ROISquareSize = max(256,ROISquareSize-mod(ROISquareSize,-2));
end    
ROISquareSize = min(ROISquareSize,min(AOIWidthMax,AOIHeightMax));

end

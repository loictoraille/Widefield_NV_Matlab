
function PixRange = GetPixelClockRange()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
%     [rc, PixelReadoutRateCount] = AT_GetEnumCount(ObjCamera,'PixelReadoutRate');
%     AT_CheckWarning(rc);
% 
%     [rc,PixelMin] = AT_GetEnumStringByIndex(ObjCamera,'PixelReadoutRate',0,256);
%     AT_CheckWarning(rc);
%     
%     [rc,PixelMax] = AT_GetEnumStringByIndex(ObjCamera,'PixelReadoutRate',PixelReadoutRateCount-1,256);
%     AT_CheckWarning(rc);
%     
%     PixRange.Minimum = str2double(PixelMin(1:end-4));
%     PixRange.Maximum = str2double(PixelMax(1:end-4));
    
    PixRange.Minimum = 100;
    PixRange.Maximum = 270;
    
    % the other pixel clocks are not supported for this camera, apparently

elseif strcmp(CameraType,'uEye')
    [~,PixRange]=ObjCamera.Timing.PixelClock.GetRange();%Query Ranges
    
elseif strcmp(CameraType,'Peak')
    % no such parameter it seems, using 'DeviceClockFrequency'
    PixRange.Minimum = 395000000;
    PixRange.Maximum = 395000000;    
    
end


end
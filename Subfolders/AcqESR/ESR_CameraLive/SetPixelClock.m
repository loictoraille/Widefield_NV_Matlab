
function SetPixelClock(PixelClockIn)
global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    % check if it works
%     [rc, PixelReadoutRateCount] = AT_GetEnumCount(ObjCamera,'PixelReadoutRate');
%     AT_CheckWarning(rc);
%     
%     for i=0:PixelReadoutRateCount-1
%         [rc,PixelReadoutRateStatus] = AT_GetEnumStringByIndex(ObjCamera,'PixelReadoutRate',i,256);
%         AT_CheckWarning(rc);
%         Pix(i+1) = str2double(PixelReadoutRateStatus(1:end-4));
%     end

    % the other pixel clocks are not supported for this camera, apparently
    Pix = [100,270]; % corresponds to mode 1 and mode 3    
    [~,PixPos] = min(abs(Pix-double(PixelClockIn)));
    [rc] = AT_SetEnumIndex(ObjCamera, 'PixelReadoutRate',2*(PixPos-1)+1);    
    AT_CheckWarning(rc);
elseif strcmp(CameraType,'uEye') 
    ObjCamera.Timing.PixelClock.Set(PixelClockIn);
end

end
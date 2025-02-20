function Pix = GetPixelClock()

global ObjCamera CameraType

if strcmp(CameraType,'Andor') 
    [rc, PixelReadoutRateIndex] = AT_GetEnumIndex(ObjCamera,'PixelReadoutRate');
    AT_CheckWarning(rc);
    % donne le numéro et il faut utiliser la fonction d'après pour
    % convertir

    [rc,PixelReadoutRateStatus] = AT_GetEnumStringByIndex(ObjCamera,'PixelReadoutRate',PixelReadoutRateIndex,256);
    AT_CheckWarning(rc);
    % sort 10, 100, 200 et 270 alors que solis a 200 ou 540
    
    Pix = str2double(PixelReadoutRateStatus(1:end-4));
elseif strcmp(CameraType,'uEye')
    [~,Pix]=ObjCamera.Timing.PixelClock.Get();%Query current values  
elseif strcmp(CameraType,'Peak')
    % no such parameter it seems, using 'DeviceClockFrequency'
    Pix = 395000000;
    
end


end
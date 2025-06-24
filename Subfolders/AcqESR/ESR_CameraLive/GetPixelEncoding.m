
function PixelEncoding = GetPixelEncoding()
global ObjCamera CameraType
% the definition is different depending on the camera (bytes per image or bytes per pixel)

if strcmp(CameraType,'Andor')
    
    [rc,pixelIndex] = AT_GetEnumIndex(ObjCamera,'PixelEncoding');
    AT_CheckWarning(rc);

    [rc,pixelStatus] = AT_GetEnumStringByIndex(ObjCamera,'PixelEncoding',pixelIndex,256);
    AT_CheckWarning(rc);

    if contains(pixelStatus,'32')
        PixelEncoding = 32;
    elseif contains(pixelStatus,'16')
        PixelEncoding = 16;
    else
        PixelEncoding = 12;
    end

else % all other cameras seem to work the same or don't care

    PixelEncoding = GetBitsPerPixel();

end

end

function SetROI_BACK()
global ObjCamera CameraType handleImage

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');

% AcqParameters.AOILEVEL = AcqParameters.AOILEVEL -1;

% save([getPath('Param') 'AcqParameters.mat'],'AcqParameters'); 

% SetAOI(AcqParameters.AOI.X(AcqParameters.AOILEVEL),AcqParameters.AOI.Y(AcqParameters.AOILEVEL),AcqParameters.AOI.Width(AcqParameters.AOILEVEL),AcqParameters.AOI.Height(AcqParameters.AOILEVEL));

if AcqParameters.AOILEVEL == 1    
    SetAOIMAX();
else    
    SetAOI(AcqParameters.AOI.X(AcqParameters.AOILEVEL-1),AcqParameters.AOI.Y(AcqParameters.AOILEVEL-1),AcqParameters.AOI.Width(AcqParameters.AOILEVEL-1),AcqParameters.AOI.Height(AcqParameters.AOILEVEL-1));
end

end
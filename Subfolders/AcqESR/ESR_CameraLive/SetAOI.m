
function SetAOI(SetLeft,SetTop,SetWidth,SetHeight)

SendAOItoCAM(SetLeft,SetTop,SetWidth,SetHeight);

AOI = GetAOI();

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');

AcqParameters.AOILEVEL = AcqParameters.AOILEVEL +1;

AcqParameters.AOI.Width(AcqParameters.AOILEVEL) = AOI.Width;
AcqParameters.AOI.Height(AcqParameters.AOILEVEL) = AOI.Height;
AcqParameters.AOI.X(AcqParameters.AOILEVEL) = AOI.X;
AcqParameters.AOI.Y(AcqParameters.AOILEVEL) = AOI.Y;

save([getPath('Param') 'AcqParameters.mat'],'AcqParameters'); 

end
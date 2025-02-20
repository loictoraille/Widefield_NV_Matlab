function InitAOILEVEL()

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');

AcqParameters.AOILEVEL = 0;

save([getPath('Param') 'AcqParameters.mat'],'AcqParameters'); 


end
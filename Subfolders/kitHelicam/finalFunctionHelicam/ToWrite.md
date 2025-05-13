Fonction that have yet to be written in this directory and their parameters :


Variable are passed through ObjCamera when possible.
Default value should be charged in the initalisation script


heliCamGetImage(ObjCamera) -> ImageMatrix
heliCamQuickGetImage(ObjCamera) -> ImageMatrix

variable :
	string TriggerMode;
	bool AcqMode;
	bool removeOffset;
	integer NFramesDiscard;
	integer freqMultiplier;



heliCamStartAcqMode(ObjCamera) -> None
heliCamStopAcq(ObjCamera) -> None

variable :
	bool AcqMode;

SensitivityToExposureTime -> float ?

heliCamGetFrameRate(ObjCamera) -> Fra

heliCamGetExp(ObjCamera) -> exp,expUnit
heliCamSetExp(ObjCamera,Exposure -> None 

heliCamGetTemperature(ObjCamera) -> temperature (float)
heliCamCloseCam(ObjCamera) -> None







function ImageMatrix = heliCamGetQuickImage(ObjCamera)
	%TODO : Setting up a fast mode for acquisition
	disp('heliCamGetQuickImage not written yet, fallback on heliCamGetImage');
	ImageMatrix = heliCamGetImage(ObjCamera);
end

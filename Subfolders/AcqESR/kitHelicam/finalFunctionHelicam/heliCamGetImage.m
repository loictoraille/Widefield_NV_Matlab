function ImageMatrix = heliCamGetImage(ObjCamera)
		% function that return the 2D RMS image of the demodulated
		% image
		[I,Q] = heliCamGetRaw3DIQimage(ObjCamera);	
		ImageMatrix = squeeze(sqrt(mean(I.^2 + Q.^2)))*ObjCamera.lumFactor;

end

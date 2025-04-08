function ImageMatrix = heliCamGetImage(ObjCamera)

		%TODO : Add a checkup on the state of acquisition mode
		%  
		c4dev = ObjCamera.c4dev;

		% launch frame start trigger
		if strcmp(ObjCamera.triggerMode,"TriggerSoftware")
			c4dev.executeCommand("TriggerSoftware");
		else
			ObjCamera.lunchSequency();
		end
		% load measurement data from buffer
		timeOutBuffer = 10000;
		c4buf = c4dev.getBuffer(timeOutBuffer); %time out
		
		% retrieve rawI and rawQ component
		NFrames = c4buf.readInteger("ChunkPartCount")/2;
		frameDimension = c4buf.getPartDimension(1);
		width = frameDimension(1);
		height = frameDimension(2);
		
		rawI = zeros(NFrames,height,width);
		rawQ = zeros(NFrames,height,width);
		
		for i=0:NFrames-1
		
		    rawI(i+1,:,:) = transpose(reshape(double(c4buf.getDataPartUint16(i)),width,height));
		    rawQ(i+1,:,:) = transpose(reshape(double(c4buf.getDataPartUint16(i+NFrames)),width,height));
		
		end
		
		rawI = (mod(rawI, 2^15)) / 2^2;
		rawQ = (mod(rawQ, 2^15)) / 2^2;
		
		% Discard initial frames lacking information
		NFramesDiscard = 3;
		
		I = rawI(NFramesDiscard:NFrames,:,:);
		Q = rawQ(NFramesDiscard:NFrames,:,:);
		
		% (Optionally) remove the offset (simple time average per pixel)
		%
		removeOffset = true;
		
		if removeOffset
		
		    I = I - mean(I, 1);
		    Q = Q - mean(Q, 1);
		
		end
		% release buffer
		c4buf.release();
		% launch frame start trigger
		c4dev.executeCommand("TriggerSoftware");
		
		% load measurement data from buffer
		timeOutBuffer = 10000;
		c4buf = c4dev.getBuffer(timeOutBuffer); %time out
		
		% retrieve rawI and rawQ component
		NFrames = c4buf.readInteger("ChunkPartCount")/2;
		frameDimension = c4buf.getPartDimension(1);
		width = frameDimension(1);
		height = frameDimension(2);
		
		rawI = zeros(NFrames,height,width);
		rawQ = zeros(NFrames,height,width);
		
		for i=0:NFrames-1
		
		    rawI(i+1,:,:) = transpose(reshape(double(c4buf.getDataPartUint16(i)),width,height));
		    rawQ(i+1,:,:) = transpose(reshape(double(c4buf.getDataPartUint16(i+NFrames)),width,height));
		
		end
		
		% release buffer
		c4buf.release();
		
		rawI = (mod(rawI, 2^15)) / 2^2;
		rawQ = (mod(rawQ, 2^15)) / 2^2;
		
		% Discard initial frames lacking information
		NFramesDiscard = 3;
		
		I = rawI(NFramesDiscard:NFrames,:,:);
		Q = rawQ(NFramesDiscard:NFrames,:,:);
		
		% (Optionally) remove the offset (simple time average per pixel)
		removeOffset = true;
		
		if removeOffset
		
		    I = I - mean(I, 1);
		    Q = Q - mean(Q, 1);
		
		end
		
		ImageMatrix = squeeze(sqrt(mean(I.^2 + Q.^2)));


end

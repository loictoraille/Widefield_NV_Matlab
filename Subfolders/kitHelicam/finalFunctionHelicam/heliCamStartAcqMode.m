function heliCamStartAcqMode(ObjCamera)
	% function to change camera mode from configuration
	% to the acquisition mode

	%TODO: Understand the point of this integer in the function
	c4dev.startAcquisition(4); % I do not know why it take an integer
end

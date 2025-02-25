function [c4dev,c4sys,c4if] = init()	
	% establish camera connection	
	% must be call to comunicate with the camera at startup
	c4sys = heliotis.C4HandlerCLR();
	c4sys.reset();
	
	ifNo = selectInterface(c4sys);
	c4if = c4sys.openInterface(ifNo);
	devNo = selectDevice(c4if);
	c4dev = c4if.openDevice(devNo);
end

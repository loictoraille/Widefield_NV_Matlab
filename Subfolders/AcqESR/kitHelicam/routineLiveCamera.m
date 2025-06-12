
if ~NET.isNETSupported
    disp('Supported .NET Framework not found')
    return
end

addpath(genpath("Subfolders"));

NET.addAssembly('C4HdlCLR');

import C4HdlCLR.*

[c4dev,c4sys,c4if] = init();


default_initializeDevice(c4dev); % set of the camera to test settings (should observe beating of I and Q)

startAcqMode(c4dev);


for i = 1:120
	tic;
	[I,Q] = getIQ(c4dev);
	plotIQ(I,Q);
	toc;
	pause(0.5); 
end 






stopAcqMode(c4dev);




% end of use the camera
c4dev.release(); %end of the interface for the camera
c4if.release();  % cut f the network interface, mandatory to avoid conflict

%plotIQ(I,Q)

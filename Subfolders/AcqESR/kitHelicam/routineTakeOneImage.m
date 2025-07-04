
if ~NET.isNETSupported
    disp('Supported .NET Framework not found')
    return
end

NET.addAssembly('C4HdlCLR');

import C4HdlCLR.*

[c4dev,c4sys,c4if] = init();


default_initializeDevice(c4dev); % set of the camera to test settings (should observe beating of I and Q)

startAcqMode(c4dev);

[I,Q] = getIQ(c4dev);

stopAcqMode(c4dev);




% end of use the camera
c4dev.release(); %end of the interface for the camera
c4if.release();  % cut f the network interface, mandatory to avoid conflict

plotIQ(I,Q)

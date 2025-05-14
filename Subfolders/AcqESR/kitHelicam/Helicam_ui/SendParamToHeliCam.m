function SendParamToHeliCam(~, ~)
global ObjCamera;

% This function simply calls your existing function
% and ObjCamera is correctly populated and declared global in heliCamSetParameters if needed there too.

if ~isempty(ObjCamera) % Basic check
    heliCamSetParameters(ObjCamera);
    disp('Parameters sent to HeliCam.');
else
    disp('Error: Global ObjCamera is empty or not initialized.');
end

end
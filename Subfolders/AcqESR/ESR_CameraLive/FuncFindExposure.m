
function FuncFindExposure(h)
global ObjCamera CameraType 
set(h.findexposure,'ForegroundColor',[0,0,1]);%Change button color to blue in the GUI

ExpRange = GetExpRange();
mE = ExpRange.Minimum;
ME = ExpRange.Maximum;
FraRange = GetFrameRateRange();
FRmin = FraRange.Minimum;
FRmax = FraRange.Maximum;
PixRange = GetPixelClockRange();
PCmin = PixRange.Minimum;
PCmax = PixRange.Maximum;
BpP = GetPixelEncoding();

[CurrentExp,~] = GetExp();

Target=double(2^BpP*0.9);
Tolerance=double(2^BpP*0.01);

disp('Find Exposure');
disp([num2str(CurrentExp) '/' num2str(ME)]);

StartVal=MaxExp(CurrentExp);

while StartVal == 2^BpP-1 
    CurrentExp = CurrentExp/10;
    disp([num2str(CurrentExp) '/' num2str(ME)]);
    StartVal = MaxExp(CurrentExp);
end
ExpEstimate = 0.9*2^BpP/StartVal*CurrentExp;

if ExpEstimate > 500 % in ms 
    disp('Find Exposure stopped: not enough signal');
    % if there is not enough lum, blocks the function to prevent overtime
else

    if strcmp(CameraType,'uEye') % check how to write it for andor camera
        imax = 10;
        i=0;
        while ExpEstimate > ME && i<imax
            [~,FrameRate]=ObjCamera.Timing.Framerate.Get();
            [~,PixelClock]=ObjCamera.Timing.PixelClock.Get();
            if PixelClock > 7
                ObjCamera.Timing.PixelClock.Set(max(PixelClock/2,PCmin));
            else
                ObjCamera.Timing.Framerate.Set(FrameRate/2);
            end
            [~,mE,ME,~]=ObjCamera.Timing.Exposure.GetRange();
            i = i+1;
        end
    elseif strcmp(CameraType,'Peak')
        OptimizeAcquisitionSpeed();

    elseif strcmpi(CameraType,'Thorlabs')
        % not sure if I should use OptimizeAcquisitionSpeed as for Peak, unclear for now
        imax = 10;
        i=0;
        while ExpEstimate > ME && i<imax
            FrameRate = ObjCamera.GetMeasuredFrameRate;
            ObjCamera.FrameRateControlValue_fps = FrameRate/2;
            mE = ObjCamera.ExposureTimeRange_us.Minimum;
            ME = ObjCamera.ExposureTimeRange_us.Maximum;
            i = i+1;
        end
    end
    
    Bmin=mE;
    % Bmil=(Bmin+Bmax)/2;
    % BmilVal=MaxExp(Bmil);
    % Bmax=ME;
    Bmax = 2*ExpEstimate; % change to prevent too long acquisition with Zyla cam
    Bmil=ExpEstimate;
    BmilVal=MaxExp(Bmil);
    
    
    
    imax = 10;
    i=0;
    while abs(BmilVal-Target)>Tolerance && i<imax
        if Target>BmilVal
            Bmin=Bmil;
        else
            Bmax=Bmil;
        end
        Bmil=(Bmin+Bmax)/2;
        BmilVal=MaxExp(Bmil);
        disp([num2str(Bmil) '/' num2str(ME)]);
        i = i+1;
    end
    Exp=Bmil;
    disp([num2str(Bmil) '/' num2str(ME)]);
    SetExp(Exp);
    FuncCameraRanges(h);
end

set(h.findexposure,'ForegroundColor',[0,0,0]);%Change button color to black
set(h.findexposure,'Value',0);

%% 
function M=MaxExp(Exp)
    SetExp(Exp);    
    [ImageMatrix,ISize,AOI] = PrepareCamera();
    ImageMatrix=TakeCameraImage(ISize,AOI);
    EndAcqCamera();
%     S=size(ImageMatrix);        
%     M=double(max(max(ImageMatrix(round(S(1)/2)-20:round(S(1)/2)+20,round(S(2)/2)-20:round(S(2)/2)+20))));
    M=double(max(max(ImageMatrix)));
end

end
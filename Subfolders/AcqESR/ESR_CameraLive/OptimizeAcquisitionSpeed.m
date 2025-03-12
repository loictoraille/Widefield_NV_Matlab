function OptimizeAcquisitionSpeed()
% Sets the maximum frame rate and pixel clock possible for the chosen
% exposure time

% first pixel clock, then if pixel clock is max increases frame rate

global ObjCamera CameraType

if strcmp(CameraType,'Andor')
%     disp('Max Speed not coded yet for Andor Camera')
elseif strcmp(CameraType,'uEye')
    ExpRange = GetExpRange();
    Expmin = ExpRange.Minimum;
    Expmax = ExpRange.Maximum;
    [Exp,~] = GetExp();
    FraRange = GetFrameRateRange();
    FRmin = FraRange.Minimum;
    FRmax = FraRange.Maximum;
    FrameRateStart = GetFrameRate();
    PixRange = GetPixelClockRange();
    PCmin = PixRange.Minimum;
    PCmax = PixRange.Maximum;
    PixelClock = GetPixelClock();

    CurrentExp = Exp;

    Tolerance = Exp/100;

    if Exp ~= Expmax
        
        SetFrameRate(FRmax/2);      % to avoid problems when FrameRate is close to max  
        NewExpRange = GetExpRange();
        NewExpmin = NewExpRange.Minimum;
        NewExpmax = NewExpRange.Maximum;

        if abs(NewExpmax-Expmax) > Tolerance
            SetFrameRate(FrameRateStart);% to prevent big modification of exp
%             SetExp(Exp);
        end

        ind = 0;
        while abs(CurrentExp-Exp) < Tolerance
            PixelClock = min((PixelClock + 2),PCmax);
            SetPixelClock(PixelClock);
            SetExp(Exp);
            [CurrentExp,~] = GetExp();
    %         disp(num2str(CurrentExp));
            if PixelClock == PCmax
                ind = 0;
                break
            end
            ind = 1;
        end

        if ind == 1      
            SetPixelClock(PixelClock-2);
            SetExp(Exp);            
        end
        
        FraRange = GetFrameRateRange();
        FRmin = FraRange.Minimum;
        FRmax = FraRange.Maximum;
        FrameRate = GetFrameRate();      

        ind = 0;    
        if PixelClock == PCmax    
            while abs(CurrentExp-Exp) < Tolerance
                FrameRate = min((FrameRate + 1),FRmax);
                SetFrameRate(FrameRate);
                SetExp(Exp);
                [CurrentExp,~] = GetExp();
        %         disp(num2str(CurrentExp));
                if FrameRate == FRmax
                    break
                end
                ind = 1;
            end
        end

        if ind == 1      
            SetFrameRate(FrameRate-1);
            SetExp(Exp);
        end   
    end

    UpdateCameraRanges();
    
elseif strcmp(CameraType,'Peak')    
    src_mycam = get(ObjCamera, 'Source');    
    bound_frame_rate = propinfo(src_mycam,'AcquisitionFrameRate').ConstraintValue;
    max_fr_rate = bound_frame_rate(2);
    set(src_mycam, 'AcquisitionFrameRate', max_fr_rate);    
elseif strcmp(CameraType,'heliCam')
	#TODO make sure the right value are loaded
	disp("OptimizeAcquisitionSpeed() not define for heliCam")
end

end

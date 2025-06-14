
function FuncAcqContinue(h)
global ObjCamera CameraType handleImage TestWithoutHardware

if ~TestWithoutHardware

set(h.acqcont,'ForegroundColor',[0,0,1]);
set(h.acqcont,'Value',1);

MaxLum = str2double(h.MaxLum.String);

UpdateCalibUnit();

[I,ISize,AOI] = PrepareCamera();

% loop while checking all the buttons to allow user action

while exist('ObjCamera','var') && h.acqcont.Value%test value of stopcam button
	% the "if ladder" check if a parameter is being modified in the gui
	% so the live is being paused
    if h.roidef.Value % check ROI_def
        EndAcqCamera();
        FuncROI_define(h);
        [I,ISize,AOI] = PrepareCamera();
    end
    if h.roisquare.Value % check ROISsquare
        EndAcqCamera();
        FuncROISquare_define(h);  
        pause(0.3);% seems necessary to make it work (shorter or longer depending on computer
        [I,ISize,AOI] = PrepareCamera();
    end
    if all(h.roisquaresize.ForegroundColor == [0,0,1]) % check ROISsquare
        EndAcqCamera();
        UpdateROI_Square_Input(h);
        [I,ISize,AOI] = PrepareCamera();
    end   
    if h.roioff.Value % check ROI_OFF
        EndAcqCamera();
        FuncROI_OFF(h);
        [I,ISize,AOI] = PrepareCamera();
    end  
    if h.roiback.Value % check ROI_BACK
        EndAcqCamera();
        FuncROI_BACK(h);
        [I,ISize,AOI] = PrepareCamera();
    end
    if h.picacq.Value % check Picture
        EndAcqCamera();
        FuncTake_Photo(h);
        [I,ISize,AOI] = PrepareCamera();
    end     
    if h.findexposure.Value % check Find_Exposure
        EndAcqCamera();
        FuncFindExposure(h);
        [I,ISize,AOI] = PrepareCamera();
    end     

    if h.autofocuspiezo.Value % check AutoFocus
        EndAcqCamera();
        FuncAutoFocusPiezo(h);
        [I,ISize,AOI] = PrepareCamera();
    end

    % nothing is being modified
    if exist('ObjCamera','var') && ~h.stopcam.Value;I=TakeCameraImage(ISize,AOI);end 
    if exist('ObjCamera','var') && ~h.stopcam.Value;set(handleImage,'CData',I);end
    if exist('ObjCamera','var') && ~h.stopcam.Value;drawnow;end
    if exist('ObjCamera','var') && ~h.stopcam.Value;title(h.Axes_Camera,['Max pixel value = ' num2str(round(max(max(I))))]);end
        
    if exist('ObjCamera','var') && h.stopcam.Value % check Stop button
        EndAcqCamera();
        h.stopcam.Value=false;
        set(h.acqcont,'ForegroundColor',[0,0,0]);
        set(h.acqcont,'Value',0);
        SaveCameraParam();
        break;
    end
        
end

end

end

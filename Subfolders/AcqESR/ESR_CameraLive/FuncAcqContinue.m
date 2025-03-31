
function FuncAcqContinue(h)
global ObjCamera CameraType handleImage TestWithoutHardware

if ~TestWithoutHardware

set(h.acqcont,'ForegroundColor',[0,0,1]);
set(h.acqcont,'Value',1);

if strcmp(CameraType,'Andor')
    maxLum = 65535;
else
    maxLum = 4095;
end

UpdateCalibUnit();

[I,ISize,AOI] = PrepareCamera();

while exist('ObjCamera','var') && h.acqcont.Value % loop while checking all the buttons to allow user action
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

    if exist('ObjCamera','var') && ~h.stopcam.Value;I=TakeCameraImage(ISize,AOI);end 
    if exist('ObjCamera','var') && ~h.stopcam.Value;set(handleImage,'CData',I);end
    if exist('ObjCamera','var') && ~h.stopcam.Value;drawnow;end
    if exist('ObjCamera','var') && ~h.stopcam.Value;title(['Max pixel value ' num2str(max(max(I(:,3:end-2)))) '/' num2str(maxLum)]);end
        
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
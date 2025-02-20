
function FuncAcqContinue(h)
global ObjCamera CameraType handleImage TestWithoutHardware

if ~TestWithoutHardware

set(h.acqcont,'ForegroundColor',[0,1,0]);
set(h.acqcont,'Value',1);

if strcmp(CameraType,'Andor')
    maxLum = 65535;
else
    maxLum = 4095;
end

UpdateCalibUnit();

[I,ISize,AOI] = PrepareCamera();

while exist('ObjCamera','var') && h.acqcont.Value%test value of stopcam button
    if h.roidef.Value 
        EndAcqCamera();
        FuncROI_define(h);
        [I,ISize,AOI] = PrepareCamera();
    end
    if h.roisquare.Value 
        EndAcqCamera();
        FuncROISquare_define(h);  
        pause(0.3);% seems necessary to make it work (shorter or longer depending on computer
        [I,ISize,AOI] = PrepareCamera();
    end
    if all(h.roisquaresize.ForegroundColor == [0,1,0])
        EndAcqCamera();
        UpdateROI_Square_Input(h);
        [I,ISize,AOI] = PrepareCamera();
    end   
    if h.roioff.Value 
        EndAcqCamera();
        FuncROI_OFF(h);
        [I,ISize,AOI] = PrepareCamera();
    end  
    if h.roiback.Value
        EndAcqCamera();
        FuncROI_BACK(h);
        [I,ISize,AOI] = PrepareCamera();
    end
    if h.picacq.Value 
        EndAcqCamera();
        FuncTake_Photo(h);
        [I,ISize,AOI] = PrepareCamera();
    end     
    if h.findexposure.Value 
        EndAcqCamera();
        FuncFindExposure(h);
        [I,ISize,AOI] = PrepareCamera();
    end     
       
    if exist('ObjCamera','var') && ~h.stopcam.Value;I=TakeCameraImage(ISize,AOI);end 
    if exist('ObjCamera','var') && ~h.stopcam.Value;set(handleImage,'CData',I);end
    if exist('ObjCamera','var') && ~h.stopcam.Value;drawnow;end
    if exist('ObjCamera','var') && ~h.stopcam.Value;title(['Max pixel value ' num2str(max(max(I(:,3:end-2)))) '/' num2str(maxLum)]);end
        
    if exist('ObjCamera','var') && h.stopcam.Value
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
%% PerformAlignPiezo
%% Script d'alignement par piezo et autocorrélation
% Idée : 
% Prendre des images en scan sur X, sur Y et sur Z
% Autocorréler et sélectionner les coordonnées de celle qui est le plus corrélé
% Attention : c'est l'échantillon qui se décale, et on joue sur le laser pour rattraper
% Il faut donc aussi décaler l'image d'autant pour garder toujours le laser au même endroit sur l'image
% Séparer Z c'est mieux ; utiliser de l'autofocus plutôt que de l'autocorrélation sur Z c'est  mieux

IniX = AcqParameters.PiezoX;
IniY = AcqParameters.PiezoY;
IniZ = AcqParameters.PiezoZ;

if LIGHT == 0
    Tension_Light = 0; 
else
    Tension_Light = AcqParameters.PiezoLight;
end

CheckMaxAndWriteNI(IniX, IniY, IniZ, Tension_Light)

if i_scan == 1

    CalibPiezoX = AcqParameters.CalibPiezoX; % µm per 10V % set in the Camera Panel
    CalibPiezoY = AcqParameters.CalibPiezoY; % µm per 10V % set in the Camera Panel
    CalibPiezoZ = AcqParameters.CalibPiezoZ; % µm per 10V % set in the Camera Panel % this one is not used for now
    CalibPixelCam =  AcqParameters.PixelCalib_nm/1000; % µm per pixel % set in the Camera Panel
    
    PiezoRange = AcqParameters.PiezoRange;
    PiezoSteps = AcqParameters.PiezoSteps;

    PiezoRangeZ = PiezoRange/2;
    PiezoStepsZ = PiezoSteps*2+1;
       
    Step = PiezoRange/(PiezoSteps-1);
    StepZ = PiezoRangeZ/(PiezoStepsZ-1);
end

LeftX = max([-10,IniX - PiezoRange/2]);
LeftY = max([-10,IniY - PiezoRange/2]);
LeftZ = max([0,IniZ - PiezoRangeZ/2]);

%% Autofocus z
% uses code "Focus Measure" from https://fr.mathworks.com/matlabcentral/fileexchange/27314-focus-measure
% different options, 'BREN' potentially best?
% Full working list on small example: BREN CONT GDER GLLV GRAE GRAT HELM HISR LAPD LAPE LAPV SFRQ TENG TENV VOLA WAVV WAVR

ind_prog = 0;
for k=1:PiezoStepsZ
    ind_prog = ind_prog + 1;
    if rem(ind_prog,1) == 0
        disp(['Autocorrelation z in progress ' num2str(ind_prog) '/' num2str(PiezoStepsZ)]);
    end
    NewZ = min([10,LeftZ + (k-1)*StepZ]);
    CheckMaxAndWriteNI(IniX, IniY, NewZ, Tension_Light)
    if strcmp(CameraType,'Andor') 
        EndAcqCamera();
        [I,ISize,AOI] = PrepareCamera();
    end
    ImageCurrent = TakeCameraImage(ISize,AOI);
    %figure;imagesc(ImageCurrent);
    FM(k) =  fmeasure(ImageCurrent, 'BREN');
end

[~, maxPos] = max(FM(:));
[indz] = ind2sub(size(FM), maxPos);

Opt_Z = LeftZ + (indz-1)*Step;

disp(['IniZ = ' num2str(IniZ) ' V'])
disp(['NewZ = ' num2str(Opt_Z) ' V'])

CheckMaxAndWriteNI(IniX, IniY, Opt_Z, Tension_Light)

%% Autocorrélation xy

PrevX = IniX;
PrevY = IniY;
ind_prog = 0;
AOI_init = AOI;
for i=1:PiezoSteps
    for j=1:PiezoSteps
        ind_prog = ind_prog + 1;
        if rem(ind_prog,10) == 0
            disp(['Autocorrelation xy in progress ' num2str(ind_prog) '/' num2str(PiezoSteps^2)]);
        end
        NewX = min([10,LeftX + (i-1)*Step]);
        NewY = min([10,LeftY + (j-1)*Step]);
        DeltaX_pix(i,j) = -round((CalibPiezoX*(NewX-PrevX)/10)/CalibPixelCam); % moves the AOI to follow the laser movement
        DeltaY_pix(i,j) = -round((CalibPiezoY*(NewY-PrevY)/10)/CalibPixelCam);
        
        if DeltaX_pix(i,j) ~= 0 || DeltaY_pix(i,j) ~= 0
            if strcmp(CameraType,'Andor')
                EndAcqCamera();
            end
            
            SendAOItoCAM(AOI.X+DeltaX_pix(i,j),AOI.Y+DeltaY_pix(i,j),AOI.Width,AOI.Height);
            
            if strcmp(CameraType,'Andor')
                [I,ISize,AOI] = PrepareCamera();
            end
        end
        CheckMaxAndWriteNI(NewX, NewY, Opt_Z, Tension_Light)
        
        ImageCurrent = TakeCameraImage(ISize,AOI);
        % figure;imagesc(ImageCurrent);
        
        [crop1_out,crop2_out] = Align2Files(Lum_Initial,ImageCurrent,0); % align the two laser spots by autocorr
        Pic1crop = Lum_Initial(crop1_out(1):crop1_out(2),crop1_out(3):crop1_out(4)); % result: crop both images to center laser spot
        Pic2crop = ImageCurrent(crop2_out(1):crop2_out(2),crop2_out(3):crop2_out(4));
        Corr_simple(i,j) = sum(sum(xcorr2_fast_manual(Pic1crop,Pic2crop))); % simple correlation value between the images
        Number_pixels(i,j) = numel(Pic1crop); 

        PrevX = NewX; PrevY = NewY;
    end
end

Corr_renorm = Corr_simple./Number_pixels; % better to renormalize by the number of pixels in the cropped images

[minVal, minPos] = min(Corr_simple(:));
[indx,indy] = ind2sub(size(Corr_simple), minPos);

SendAOItoCAM(AOI_init.X+DeltaX_pix(indx,indy),AOI_init.Y+DeltaY_pix(indx,indy),AOI_init.Width,AOI_init.Height);
ImageCurrent = TakeCameraImage(ISize,AOI);
C = normxcorr2_general(Lum_Initial,ImageCurrent,numel(Lum_Initial)/2);
[ypeak, xpeak] = find(C==max(C(:)));
Yshift = ypeak-AOI_init.Height;
Xshift = xpeak-AOI_init.Width;
disp(['X shift = ' num2str(Xshift) ' pixels'])
disp(['Y shift = ' num2str(Yshift) ' pixels'])
EndAcqCamera();
SetAOI(AOI_init.X+Xshift,AOI_init.Y+Yshift,AOI_init.Width,AOI_init.Height);
[I,ISize,AOI] = PrepareCamera();

Opt_X = LeftX + (indx-1)*Step;
Opt_Y = LeftY + (indy-1)*Step;

%% Résulats finaux et éteignage de la lampe

UpdateInputPiezo(Opt_X,Opt_Y,Opt_Z,AcqParameters.PiezoLight);
CheckMaxAndWriteNI(Opt_X, Opt_Y, Opt_Z, 0)


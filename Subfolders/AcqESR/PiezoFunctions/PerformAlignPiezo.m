%% PerformAlignPiezo
%% Script d'alignement par piezo et autocorrélation
% Idée : 
% Prendre des images en scan sur X, sur Y et sur Z
% Autocorréler et sélectionner les coordonnées de celle qui est le plus corrélé
% Attention : c'est l'échantillon qui se décale, et on joue sur le laser pour rattraper
% Il faut donc aussi décaler l'image d'autant pour garder toujours le laser au même endroit sur l'image
% Séparer Z c'est mieux ; utiliser de l'autofocus plutôt que de l'autocorrélation sur Z c'est  mieux

% In short: autofocus Z, then sweep of a small area with the laser while following with the camera
% The point where the image is most similar to the initial reference image is then selected

%% Initialization

disp('Starting Full Piezo Alignment Procedure');

IniX = AcqParameters.PiezoX;
IniY = AcqParameters.PiezoY;

LightOn(panel); % turning light on for all piezo alignment procedures

if i_scan == 1 % only defines these values during the first scan

    CalibPiezoX = AcqParameters.CalibPiezoX; % µm per 10V % set in the Camera Panel
    CalibPiezoY = AcqParameters.CalibPiezoY; % µm per 10V % set in the Camera Panel
    CalibPixelCam =  AcqParameters.PixelCalib_nm/1000; % µm per pixel % set in the Camera Panel
    
    PiezoRange = AcqParameters.PiezoRange;
    PiezoSteps = AcqParameters.PiezoSteps;
       
    Step = PiezoRange/(PiezoSteps-1);
end

LeftX = max([-10,IniX - PiezoRange/2]);
LeftY = max([-10,IniY - PiezoRange/2]);

%% Autofocus z
FuncIndepAutofocusPiezo(panel);

%% Autocorrélation xy

LightOn(panel); % turning light on for all piezo alignment procedures
Tension4 = LaserOn(panel); % crucial for realignment of the laser on the sample

Opt_Z = AcqParameters.PiezoZ; 
PrevX = IniX;
PrevY = IniY;
ind_prog = 0;
AOI_init = AOI;
for i=1:PiezoSteps
    for j=1:PiezoSteps
        ind_prog = ind_prog + 1;
        if rem(ind_prog,5) == 0 || ind_prog == 1
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
        CheckMaxAndWriteNI(NewX, NewY, Opt_Z, Tension4)
        
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
[indx,indy] = ind2sub(size(Corr_simple), minPos); % found the best laser position, but the precision for the AOI is not as good as with using normxcorr2_general

Opt_X = LeftX + (indx-1)*Step;
Opt_Y = LeftY + (indy-1)*Step;

UpdateInputPiezo(Opt_X,Opt_Y,Opt_Z,AcqParameters.PiezoLight,panel); % stores the right piezo values

% final AOI adjustment, preferentially with laser off
LaserOff(panel); % also sends new values to the NI card

EndAcqCamera();
SendAOItoCAM(AOI_init.X+DeltaX_pix(indx,indy),AOI_init.Y+DeltaY_pix(indx,indy),AOI_init.Width,AOI_init.Height);
[I,ISize,AOI] = PrepareCamera();
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


%% Turning laser back on and light back off

LightOff(panel);
LaserOn(panel);


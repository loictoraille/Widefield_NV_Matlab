%% PerformAlignPiezo
%% Script d'alignement par piezo et autocorrélation
% Idée : 
% Prendre des images en scan sur X, sur Y et sur Z
% Autocorréler et sélectionner les coordonnées de celle qui est le plus corrélé
% Attention : c'est l'échantillon qui se décale, et on joue sur le laser pour rattraper
% Il faut donc aussi décaler l'image d'autant pour garder toujours le laser au même endroit sur l'image
% Ou trouver un moyen de recentrer l'image sur le cercle du laser
% Ou regarder dans une zone plus petite croppée autour du laser > mais c'est pas facile à coder.
% Séparer Z c'est mieux

if i_scan == 1
    
    PiezoRange = AcqParameters.PiezoRange;
    PiezoSteps = AcqParameters.PiezoSteps;
    
    CalibPiezoX = 294; % µm per 10V
    CalibPiezoY = 206; % µm per 10V
    CalibPiezoZ = 300; % µm per 10V
    CalibPixelCam = 0.523; % µm per pixel
    
    Step = PiezoRange/(PiezoSteps-1);
    
    requiredNumberOfOverlapPixels = numel(Lum_Initial)/2;
    Start_Corr_Cen = GetGaussianCenter(normxcorr2_general(Lum_Initial,Lum_Initial,requiredNumberOfOverlapPixels));
    
end

IniX = AcqParameters.PiezoX;
IniY = AcqParameters.PiezoY;
IniZ = AcqParameters.PiezoZ;

LeftX = max([-10,IniX - PiezoRange/2]);
LeftY = max([-10,IniY - PiezoRange/2]);
LeftZ = max([0,IniZ - PiezoRange/2]);


%% 

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
        DeltaX_pix(i,j) = -round((CalibPiezoX*(NewX-PrevX)/10)/CalibPixelCam);
        DeltaY_pix(i,j) = -round((CalibPiezoY*(NewY-PrevY)/10)/CalibPixelCam);
        if DeltaX_pix(i,j) ~= 0 || DeltaY_pix(i,j) ~= 0
            EndAcqCamera();
            SetAOI(AOI.X+DeltaX_pix(i,j),AOI.Y+DeltaY_pix(i,j),AOI.Width,AOI.Height);
            [I,ISize,AOI] = PrepareCamera();
        end
        write(NI_card,[NewX,NewY,IniZ]);
        ImageCurrent = TakeCameraImage(ISize,AOI);
        % figure;imagesc(ImageCurrent);
        Dist_Matxy(i,j) = GetDistCenter(Start_Corr_Cen,Lum_Initial,ImageCurrent,requiredNumberOfOverlapPixels);
        PrevX = NewX; PrevY = NewY;
    end
end

[minVal, minPos] = min(Dist_Matxy(:));
[indx,indy] = ind2sub(size(Dist_Matxy), minPos);

EndAcqCamera();
SetAOI(AOI_init.X+DeltaX_pix(indx,indy),AOI_init.Y+DeltaY_pix(indx,indy),AOI_init.Width,AOI_init.Height);
[I,ISize,AOI] = PrepareCamera();

Opt_X = LeftX + (indx-1)*Step;
Opt_Y = LeftY + (indy-1)*Step;

write(NI_card,[Opt_X Opt_Y IniZ]);

%% 

ind_prog = 0;
for k=1:PiezoSteps
    ind_prog = ind_prog + 1;
    if rem(ind_prog,1) == 0
        disp(['Autocorrelation z in progress ' num2str(ind_prog) '/' num2str(PiezoSteps)]);
    end
    NewZ = min([10,LeftZ + (k-1)*Step]);
    write(NI_card,[Opt_X,Opt_Y,NewZ]);
    ImageCurrent = TakeCameraImage(ISize,AOI);
%     figure;imagesc(ImageCurrent);
    Dist_Matz(k) = GetDistCenter(Start_Corr_Cen,Lum_Initial,ImageCurrent,requiredNumberOfOverlapPixels);
end

[~, minPos] = min(Dist_Matz(:));
[indz] = ind2sub(size(Dist_Matz), minPos);

Opt_Z = LeftZ + (indz-1)*Step;

%% 

UpdateInputPiezo(Opt_X,Opt_Y,Opt_Z);
write(NI_card,[Opt_X,Opt_Y,Opt_Z]);

%% 

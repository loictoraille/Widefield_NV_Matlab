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

NumPoints = 5;
Range = 2;

CalibPiezoX = 294; % µm per 10V
CalibPiezoY = 206; % µm per 10V
CalibPiezoZ = 300; % µm per 10V
CalibPixelCam = 0.523; % µm per pixel

Step = Range/(NumPoints-1);

if exist('Opt_X');IniX = Opt_X;else;IniX = 0;end
if exist('Opt_Y');IniY = Opt_Y;else;IniY = 0;end
if exist('Opt_Z');IniZ = Opt_Z;else;IniZ = 5;end

LeftX = max([-10,IniX - Range/2]);
LeftY = max([-10,IniY - Range/2]);
LeftZ = max([0,IniZ - Range/2]);

requiredNumberOfOverlapPixels = numel(Lum_Start)/2;
Start_Corr_Cen = GetGaussianCenter(normxcorr2_general(Lum_Start,Lum_Start,requiredNumberOfOverlapPixels));

%% 

PrevX = IniX;
PrevY = IniY;
ind_prog = 0;
for i=1:NumPoints
    for j=1:NumPoints
        ind_prog = ind_prog + 1;
        if rem(ind_prog,10) == 0
            disp(['Autocorrelation xy in progress ' num2str(ind_prog) '/' num2str(NumPoints^2)]);
        end
        NewX = min([10,LeftX + (i-1)*Step]);
        NewY = min([10,LeftY + (j-1)*Step]);
        DeltaX_pix = -round((CalibPiezoX*(NewX-PrevX)/10)/CalibPixelCam);
        DeltaY_pix = -round((CalibPiezoY*(NewY-PrevY)/10)/CalibPixelCam);
        if DeltaX_pix ~= 0 || DeltaY_pix ~= 0
            EndAcqCamera();
            SetAOI(AOI.X+DeltaX_pix,AOI.Y+DeltaY_pix,AOI.Width,AOI.Height);
            [I,ISize,AOI] = PrepareCamera();
        end
        write(NI_card,[NewX,NewY,IniZ]);
        ImageCurrent = TakeCameraImage(ISize,AOI);
        % figure;imagesc(ImageCurrent);
        Corr_Matxy(i,j) = sum(sum(normxcorr2_general(Lum_Start,ImageCurrent,requiredNumberOfOverlapPixels)));
        PrevX = NewX; PrevY = NewY;
    end
end

[maxVal, maxPos] = min(abs(Corr_Matxy(:)));
[indx,indy] = ind2sub(size(Corr_Matxy), maxPos);

%% 

Opt_X = LeftX + (indx-1)*Step;
Opt_Y = LeftY + (indy-1)*Step;

write(NI_card,[Opt_X Opt_Y IniZ]);

ind_prog = 0;
for k=1:NumPoints
    ind_prog = ind_prog + 1;
    if rem(ind_prog,1) == 0
        disp(['Autocorrelation z in progress ' num2str(ind_prog) '/' num2str(NumPoints)]);
    end
    NewZ = min(10,[LeftZ + (k-1)*Step]);
    write(NI_card,[Opt_X,Opt_Y,NewZ]);
    ImageCurrent = TakeCameraImage(ISize,AOI);
%     figure;imagesc(ImageCurrent);
    Dist_Matz(k) = GetDistCenter(Start_Corr_Cen,Lum_Start,ImageCurrent,requiredNumberOfOverlapPixels);
end

[~, minPos] = min(Dist_Matz(:));
[indz] = ind2sub(size(Dist_Matz), minPos);

Opt_Z = LeftZ + (indz-1)*Step;

%% 

write(NI_card,[Opt_X,Opt_Y,Opt_Z]);

%% 

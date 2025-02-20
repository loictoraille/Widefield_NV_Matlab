%% PerformAlignPiezoOptimizer
%% Script d'alignement par piezo et optimizer

PiezoRange = AcqParameters.PiezoRange;
PiezoSteps = AcqParameters.PiezoSteps;

PiezoRangeZ = PiezoRange/2;
PiezoStepsZ = PiezoSteps*2+1;

CalibPiezoX = 294; % µm per 10V
CalibPiezoY = 206; % µm per 10V
CalibPiezoZ = 300; % µm per 10V
CalibPixelCam = 0.523; % µm per pixel

Step = PiezoRange/(PiezoSteps-1);
StepZ = PiezoRangeZ/(PiezoStepsZ-1);

IniX = AcqParameters.PiezoX;
IniY = AcqParameters.PiezoY;
IniZ = AcqParameters.PiezoZ;

SetLeft_spot=767;
SetTop_spot=168;
SetWidth_spot=35;
SetHeight_spot=35;

Exposure_Value_spot=14;

SendAOItoCAM(SetLeft_spot,SetTop_spot,SetWidth_spot,SetHeight_spot);
[I,ISize,AOI_spot] = PrepareCamera();
SetExp(Exposure_Value_spot);

ImageCurrent=TakeCameraImage(ISize,AOI_spot);

[Opt_X_pixel, Opt_Y_pixel] = optimize_gaussian_position_2D(ImageCurrent);

Opt_X=10*((SetLeft_spot+Opt_X_pixel)*CalibPixelCam)/CalibPiezoX
Opt_Y=10*((SetTop_spot+Opt_Y_pixel)*CalibPixelCam)/CalibPiezoY

write(NI_card,[Opt_X Opt_Y IniZ]);
pause(0.1);

ind_prog = 0;
for k=1:PiezoStepsZ
    ind_prog = ind_prog + 1;
    if rem(ind_prog,1) == 0
        disp(['Optimizer z in progress ' num2str(ind_prog) '/' num2str(PiezoStepsZ)]);
    end
    NewZ = min(10,[LeftZ + (k-1)*StepZ]);
    write(NI_card,[Opt_X,Opt_Y,NewZ]);
    ImageCurrent = TakeCameraImage(ISize,AOI_spot);
    Intensity_pix_spot(k) = ImageCurrent(Opt_Y_pixel,Opt_X_pixel); % test avec la valeur max de l'image
end

indz= optimize_gaussian_position_1D(1:PiezoStepsZ,Intensity_pix_spot);

Opt_Z=min([10,LeftZ + (indz-1)*StepZ]);

%% 
shift_x=-4;
shift_y=-7;
shift_z=-0.2;

UpdateInputPiezo(Opt_X+shift_x,Opt_Y+shift_y,Opt_Z+shift_z);
write(NI_card,[Opt_X+shift_x,Opt_Y+shift_y,Opt_Z+shift_z]);
pause(0.1);

SetLeft=Opt_X_pixel+(CalibPiezoX*shift_x)/10-150;
SetTop=Opt_Y_pixel+(CalibPiezoY*shift_y)/10-150; %à définir à partir de Opt_X+shift_x et Opt_Y+shift_y
SetWidth=250;
SetHeight=250; 

Exposure_Value=50;
% à la fin tu veux remettre la exposure value du début avant alignement

SendAOItoCAM(SetLeft,SetTop,SetWidth,SetHeight);
[I,ISize,AOI] = PrepareCamera();
SetExp(Exposure_Value);

%% 

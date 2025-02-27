function FuncIndepAutofocusPiezo(panel)
global CameraType
% uses code "Focus Measure" from https://fr.mathworks.com/matlabcentral/fileexchange/27314-focus-measure
% different options, 'BREN' potentially best?
% Full working list on small example: BREN CONT GDER GLLV GRAE GRAT HELM HISR LAPD LAPE LAPV SFRQ TENG TENV VOLA WAVV WAVR

%% Initialization

load([getPath('Param') 'AcqParameters.mat'], 'AcqParameters');

IniX = AcqParameters.PiezoX;
IniY = AcqParameters.PiezoY;
IniZ = AcqParameters.PiezoZ;
IniL = AcqParameters.PiezoLight;

light_state_ini = panel.light.Value;
laser_state_ini = panel.shutterlaser.Value;

PiezoRangeZ = AcqParameters.PiezoRange/2;
PiezoStepsZ = AcqParameters.PiezoSteps*2+1;
StepZ = PiezoRangeZ/(PiezoStepsZ-1);
LeftZ = max([0,IniZ - PiezoRangeZ/2]);

LightOn(panel); % turning light on for all piezo alignment procedures
Tension4 = LaserOff(panel); % the laser spot prevents perfect autofocus, especially if there is a shiny pressure gauge in the image

%% Loop on piezoZ

ind_prog = 0;
for k=1:PiezoStepsZ
    ind_prog = ind_prog + 1;
    if rem(ind_prog,2) == 0 || ind_prog == 1
        disp(['Autocorrelation z in progress ' num2str(ind_prog) '/' num2str(PiezoStepsZ)]);
    end
    NewZ = min([10,LeftZ + (k-1)*StepZ]);
    CheckMaxAndWriteNI(IniX, IniY, NewZ, Tension4)
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

Opt_Z = LeftZ + (indz-1)*StepZ;

disp(['IniZ = ' num2str(IniZ) ' V'])
disp(['NewZ = ' num2str(Opt_Z) ' V'])

%% Send optimal value and go back to initial light and laser state

UpdateInputPiezo(IniX,IniY,Opt_Z,IniL,panel); % stores the right piezo values

if light_state_ini
    LightOn(panel);
else
    LightOff(panel);
end

if laser_state_ini
    LaserOn(panel);
else
    LaserOff(panel);
end

end
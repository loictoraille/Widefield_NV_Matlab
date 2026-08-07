function StartMagneticScan(hobject, eventdata)
% StartMagneticScan
% Callback for the "Start Scan" button in the Magnetic Coils tab.
% Performs a theta and/or phi scan of the applied magnetic field, running
% a full ODMR frequency sweep (with AutoAlignCam/AutoAlignCrop/AF, exactly
% as ScanScript does per i_scan) at each orientation, and exports the
% resulting (frequency x angle) PL matrix.

global M ObjCamera CameraType handleImage MW_Gen TestWithoutHardware RF_Address Lum_Current Ftot ...
    Lum_Initial Lum_WithLightAndLaser Lum_Start_LightOn_LaserOff Lum_Start_LightOff_LaserOn Lum_Start_LightOn_LaserOn

panel = guidata(gcbo);
stop_tag = findobj('tag','stop'); % reuse the MAIN window's stop button

%% Switch to tab1 so the operator sees the live ODMR display

fig = ancestor(hobject,'figure');
tabgroup_h = findobj(fig,'Type','uitabgroup');
tab1_h = findobj(fig,'Type','uitab','Title','ESR - Main Acquisition Tab');
if ~isempty(tabgroup_h) && ~isempty(tab1_h)
    tabgroup_h(1).SelectedTab = tab1_h(1);
end

load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
load([getPath('Param') 'FitParameters.mat'],'FitParameters');
MS = AcqParameters.MagneticScan;

if ~MS.ScanTheta_Enable && ~MS.ScanPhi_Enable
    warndlg('Enable Scan Theta and/or Scan Phi (checkbox) before starting.','No scan selected');
    return;
end

% Crucial: camera continuous-acquisition mode must be off during a scan (mirrors ScanScript)
if panel.acqcont.Value == 1
    set(panel.acqcont,'ForegroundColor',[0,0,0]);
    set(panel.acqcont,'Value',0);
    SaveCameraParam();
end

disp('=== Starting Magnetic Field Scan ===');
disp(['Current Date and Time: ' datestr(datetime('now'))]);

%% Standard ODMR parameters (same ones used by a normal ODMR scan)

LoadParamFromAcqParamScript; % populates CenterF_GHz, Width_MHz, NPoints, MWPower, AccNumber,
                              % RANDOM, RefMWOff, DelEx, BackupNSweeps, SaveMode,
                              % AutoAlignCam, AutoAlignCrop, AF, AF_NumberSweeps, AF_Scan, AF_NumberScan, etc.

DelEx = AcqParameters.DelEx; % DelEx standalone uses the script, so we get it out

Data_Path = AcqParameters.Data_Path;

[~,sizelevel] = size(AcqParameters.AOI.Width);
AOIParameters.AOI.Height    = AcqParameters.AOI.Height(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.AOI.Width     = AcqParameters.AOI.Width(min(sizelevel,AcqParameters.AOILEVEL));
AOIParameters.PixelCalib_nm = AcqParameters.PixelCalib_nm;
AOIParameters.CalibUnit_str = AcqParameters.CalibUnit_str;

%% Remember everything we'll need to restore, BEFORE touching any hardware,
%  and register the cleanup that guarantees restoration even on error/Ctrl+C

ini_light_state = panel.light.Value;
ini_laser_state = panel.shutterlaser.Value;
BxStart = AcqParameters.BxCoil;
ByStart = AcqParameters.ByCoil;
BzStart = AcqParameters.BzCoil;
CoilWasOff = (panel.Bbutton.Value == 0);

set(hobject,'ForegroundColor',[0,0,1],'Value',1,'Enable','off');

cleanupObj = onCleanup(@() CleanupMagneticScan(hobject, stop_tag, panel, TestWithoutHardware, ...
    MWPower, CoilWasOff, BxStart, ByStart, BzStart, ini_light_state, ini_laser_state));

%% Camera / generator setup (once; exposure/pixel clock don't depend on field orientation)

if ~TestWithoutHardware
    WriteSMB(['POW ',num2str(MWPower),' DBm']);
    WriteSMB('OUTP ON');
    OptimizeAcquisitionSpeed();
    [ExposureTime,~] = GetExp();
    FrameRate = GetFrameRate();
    PixelClock = GetPixelClock();
    AOI = GetAOI();
    ISize = [];
    ImageTestMat = [];
    if strcmp(CameraType,'Andor')
        CheckAndorTemp();
    end
else
    AOI.X = 1; AOI.Y = 1; AOI.Width = 59; AOI.Height = 175;
    ISize = [];
    ExposureTime = []; FrameRate = []; PixelClock = [];
    TestMat = load('ImageTestMat.mat');
    ImageTestMat = TestMat.ImageTestMat;
end
SwitchGEN('ON',MWPower);

FStart = CenterF_GHz - Width_MHz/1000/2;
FStep  = Width_MHz/NPoints/1000;
Ftot   = (FStart + (0:1:NPoints-1)*FStep)';

BuildName = NameGen(Data_Path,panel.FileNamePrefix.String);

%% Enable coil output

if CoilWasOff
    panel.Bbutton.Value = 1;
    BButtonCall(panel.Bbutton,[]);
end

%% Bundle shared, unchanging context into one struct

Ctx.Ftot = Ftot; Ctx.NPoints = NPoints; Ctx.AccNumber = AccNumber; Ctx.RANDOM = RANDOM;
Ctx.RefMWOff = RefMWOff; Ctx.TestWithoutHardware = TestWithoutHardware; Ctx.ImageTestMat = ImageTestMat;
Ctx.AOIParameters = AOIParameters; Ctx.ISize = ISize; Ctx.AOI0 = AOI;
Ctx.AutoAlignCam = AutoAlignCam; Ctx.AutoAlignCrop = AutoAlignCrop;
Ctx.AF = AF; Ctx.AF_NumberSweeps = AF_NumberSweeps; Ctx.AF_Scan = AF_Scan; Ctx.AF_NumberScan = AF_NumberScan;
Ctx.DelEx = DelEx; Ctx.BackupNSweeps = BackupNSweeps; Ctx.SaveMode = SaveMode;
Ctx.Data_Path = Data_Path; Ctx.BuildName = BuildName; Ctx.MWPower = MWPower;
Ctx.CenterF_GHz = CenterF_GHz; Ctx.Width_MHz = Width_MHz; Ctx.AcqParameters = AcqParameters;
Ctx.FitParameters = FitParameters; Ctx.ExposureTime = ExposureTime; Ctx.FrameRate = FrameRate; Ctx.PixelClock = PixelClock;

stoppedGlobally = false;

%% Scan Theta

if MS.ScanTheta_Enable
    disp('=== Starting Scan Theta ===');
    ThetaValues = MS.ScanTheta_AngleStart:MS.ScanTheta_AngleStep:MS.ScanTheta_AngleStop;
    [ResultsTheta, ThetaDone, stoppedGlobally, AcqTime_Theta] = RunAngleScan(panel, stop_tag, ...
        ThetaValues, MS.ScanTheta_PhiValue, MS.ScanTheta_MagneticFieldValue, 'theta', Ctx);
    Ctx.AcquisitionTime_minutes = AcqTime_Theta;
    SaveScanResults(Ctx, 'ScanTheta', ThetaDone, ResultsTheta, MS.ScanTheta_PhiValue, MS.ScanTheta_MagneticFieldValue, 'ScanTheta_Axes');
end

%% Scan Phi

if MS.ScanPhi_Enable && ~stoppedGlobally
    disp('=== Starting Scan Phi ===');
    PhiValues = MS.ScanPhi_AngleStart:MS.ScanPhi_AngleStep:MS.ScanPhi_AngleStop;
    [ResultsPhi, PhiDone, stoppedGlobally, AcqTime_Phi] = RunAngleScan(panel, stop_tag, ...
        PhiValues, MS.ScanPhi_ThetaValue, MS.ScanPhi_MagneticFieldValue, 'phi', Ctx);
    Ctx.AcquisitionTime_minutes = AcqTime_Phi;
    SaveScanResults(Ctx, 'ScanPhi', PhiDone, ResultsPhi, MS.ScanPhi_ThetaValue, MS.ScanPhi_MagneticFieldValue, 'ScanPhi_Axes');
end

disp('Magnetic scan finished.');
% Restoration (button, coils, light/laser, generator) happens automatically
% via cleanupObj (onCleanup) when this function returns or errors out.

end

%% ======================================================================

function CleanupMagneticScan(hobject, stop_tag, panel, TestWithoutHardware, MWPower, ...
    CoilWasOff, BxStart, ByStart, BzStart, ini_light_state, ini_laser_state)
% Runs no matter how StartMagneticScan exits (normal return, error, Ctrl+C).

try
    panel.BxCoil.String = num2str(round(BxStart*100)/100);
    panel.ByCoil.String = num2str(round(ByStart*100)/100);
    panel.BzCoil.String = num2str(round(BzStart*100)/100);
    Update_Tension();

    if CoilWasOff
        panel.Bbutton.Value = 0;
        BButtonCall(panel.Bbutton,[]);
    end

    if ini_light_state
        LightOn(panel);
    else
        LightOff(panel);
    end
    if ini_laser_state
        LaserOn(panel);
    else
        LaserOff(panel);
    end

    if ~TestWithoutHardware
        WriteSMB('OUTP OFF');
    end
    SwitchGEN('OFF',MWPower);
catch ME
    disp('Warning: error during magnetic scan cleanup:');
    disp(ME.message);
end

set(hobject,'ForegroundColor',[1,0,0],'Value',0,'Enable','on');
set(stop_tag,'Value',0,'ForegroundColor',[1,0,0]);

end

%% ======================================================================

function [ResultMatrix, AnglesDone, stopped, AcquisitionTime_minutes] = RunAngleScan(panel, stop_tag, AngleValues, FixedOtherAngle_deg, Bnorm, whichScan, Ctx)
% Sweeps AngleValues (theta or phi, the other angle held fixed). At each
% orientation, runs one full ODMR acquisition (equivalent to one i_scan of
% ScanScript, complete with AutoAlignCam/AutoAlignCrop/AF), and updates
% the corresponding coil-tab plot live.

NAngles = numel(AngleValues);
ResultMatrix = NaN(Ctx.NPoints, NAngles);
stopped = false;
k_done = 0;
time_one_angle = 0;

if strcmp(whichScan,'theta')
    axTag = 'ScanTheta_Axes';
else
    axTag = 'ScanPhi_Axes';
end
ax = findobj('tag',axTag);
hImg = ax.Children(1);

startTimeFull = datetime('now');

for k = 1:NAngles
    angle_deg = AngleValues(k);
    if strcmp(whichScan,'theta')
        theta_deg = angle_deg; phi_deg = FixedOtherAngle_deg;
    else
        phi_deg = angle_deg; theta_deg = FixedOtherAngle_deg;
    end
    theta = deg2rad(theta_deg);
    phi   = deg2rad(phi_deg);

    Bx = Bnorm*cos(theta);
    By = Bnorm*sin(theta)*cos(phi);
    Bz = Bnorm*sin(theta)*sin(phi);

    panel.BxCoil.String = num2str(round(Bx*100)/100);
    panel.ByCoil.String = num2str(round(By*100)/100);
    panel.BzCoil.String = num2str(round(Bz*100)/100);
    Update_Tension();

    disp(['--- ' whichScan ' step ' num2str(k) '/' num2str(NAngles) ' (' num2str(angle_deg) ' deg) ---']);
    disp(['Current Date and Time: ' datestr(datetime('now'))]);

    % "Total Remaining" shown before this angle starts, using the previous angles' timing (mirrors ScanScript's top block)
    if NAngles > 1 && k > 1
        rem_time_all = (NAngles-k+1)*time_one_angle;
        panel.AcqTime.String = [newline 'Total Remaining = ' formatDuration(rem_time_all)];
    else
        panel.AcqTime.String = '';
    end

    if ~Ctx.TestWithoutHardware && Ctx.AF_Scan && NAngles > 1 && k == 1
        disp('Initial Autofocus Z (start of angle scan)');
        [~,~,~,~,~] = FuncIndepAutofocusPiezo(panel);
        skipInitialAF = true;
    else
        skipInitialAF = false;
    end

    if ~Ctx.TestWithoutHardware && Ctx.AF_Scan && mod(k,Ctx.AF_NumberScan) == 0
        [~,~,~,~,~] = FuncIndepAutofocusPiezo(panel);
    end

    [Spectrum, stoppedHere, measured_time_angle] = AcquireODMRSpectrum(panel, stop_tag, Ctx, whichScan, k, NAngles, skipInitialAF, time_one_angle);

    if measured_time_angle > time_one_angle
        time_one_angle = measured_time_angle;
    end

    ResultMatrix(:,k) = Spectrum;
    k_done = k;

    set(hImg,'XData',AngleValues(1:k_done),'YData',Ctx.Ftot,'CData',ResultMatrix(:,1:k_done));
    drawnow;

    if stoppedHere
        stopped = true;
        break;
    end
end

AnglesDone   = AngleValues(1:k_done);
ResultMatrix = ResultMatrix(:,1:k_done);

endTimeFull = datetime('now');
elapsedFull = endTimeFull - startTimeFull;
AcquisitionTime_minutes = round(minutes(elapsedFull));

disp(['Full ' whichScan ' scan lasted: ' formatDurationDate(elapsedFull)]);
panel.AcqTime.String = ['Acquisition time = ' formatDuration(seconds(elapsedFull))];

end

%% ======================================================================

function [Spectrum, stopped, measured_time_angle] = AcquireODMRSpectrum(panel, stop_tag, Ctx, whichScan, k, NAngles, skipInitialAF, time_one_angle_prev)
% One full ODMR acquisition at the current field orientation: equivalent
% to one i_scan pass of ScanScript, including reference-image capture
% (which ends with the light off), AutoAlignCam, AutoAlignCrop, and AF,
% then reads back the binned/renormalized spectrum PrintESR just computed
% (panel.l31.YData) instead of re-deriving it.

global M Lum_Current Lum_Initial Lum_WithLightAndLaser Lum_Start_LightOn_LaserOff Lum_Start_LightOff_LaserOn Lum_Start_LightOn_LaserOn

TestWithoutHardware = Ctx.TestWithoutHardware;
NPoints = Ctx.NPoints; AccNumber = Ctx.AccNumber; RANDOM = Ctx.RANDOM; RefMWOff = Ctx.RefMWOff;
Ftot = Ctx.Ftot; ImageTestMat = Ctx.ImageTestMat; AOIParameters = Ctx.AOIParameters;
NPerm = 1;

AOI = Ctx.AOI0;
ROIHeight = AOI.Height; ROIWidth = AOI.Width;
M = zeros(ROIHeight,ROIWidth,NPoints);
stopped = false;

if TestWithoutHardware
    [h_test,w_test] = size(ImageTestMat);
end

%% First Image (reference-image capture, mirrors ScanScript) -- ends with light OFF

if ~TestWithoutHardware
    LightOn(panel); [I,ISize,AOI] = PrepareCamera();
    Lum_WithLightAndLaser = TakeCameraImage(ISize,AOI);
    panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;

    LaserOff(panel); [I,ISize,AOI] = PrepareCamera();
    Lum_Start_LightOn_LaserOff = TakeCameraImage(ISize,AOI);

    LightOff(panel); LaserOn(panel); [I,ISize,AOI] = PrepareCamera();
    Lum_Start_LightOff_LaserOn = TakeCameraImage(ISize,AOI);
else
    ISize = [];
    Lum_WithLightAndLaser      = ImageTestMat(1:h_test-10+1,1:w_test-10+1);
    Lum_Start_LightOn_LaserOff = ImageTestMat(1:h_test-10+1,1:w_test-10+1);
    Lum_Start_LightOff_LaserOn = ImageTestMat(1:h_test-10+1,1:w_test-10+1);
end

Lum_Start_LightOn_LaserOn = Lum_WithLightAndLaser;
Lum_Start = Lum_Start_LightOff_LaserOn;
Lum_Start_Crop = Lum_Start_LightOff_LaserOn;

if isempty(Lum_Initial)
    Lum_Initial = Lum_Start;
end

if panel.DisplayLight.Value
    MaxLum = PrintImage(panel.Axes1,Lum_WithLightAndLaser,AOIParameters,str2double(panel.MaxLum.String),panel.MaxLumAlwaysAuto.Value);
else
    MaxLum = PrintImage(panel.Axes1,Lum_Start,AOIParameters,str2double(panel.MaxLum.String),panel.MaxLumAlwaysAuto.Value);
end
panel.MaxLum.String = num2str(MaxLum);
panel.MaxLumLive.String = num2str(MaxLum);

if ~TestWithoutHardware
    WriteSMB('OUTP ON');
end

y_start = 1; y_end = ROIHeight; x_start = 1; x_end = ROIWidth;

time_one_sweep = 0;
ScanTic = tic;

%% Accumulation (Acc) loop

for Acc = 1:AccNumber

    if RANDOM == 1
        RandomPerm = [];
        for iperm = 1:NPerm
            if iperm ~= NPerm
                lenPerm = floor(length(Ftot)/NPerm);
            else
                lenPerm = length(Ftot)-(NPerm-1)*floor(length(Ftot)/NPerm);
            end
            perm = randperm(lenPerm)+(iperm-1)*lenPerm;
            RandomPerm = [RandomPerm perm];
        end
    end

    if Ctx.AF && Acc == 1 && ~skipInitialAF
        disp('Initial Autofocus Z when autofocus every X sweeps');
        [~,~,~,~,~] = FuncIndepAutofocusPiezo(panel);
    end

    if RefMWOff == 1 && ~TestWithoutHardware
        WriteSMB('OUTP OFF');
        RefMWOff_Image = TakeCameraImageDouble(ISize,AOI);
        WriteSMB('OUTP ON');
    end

    tic;

    for ii = 1:NPoints
        panel.numberSweep.String = sprintf('%s %d/%d | Sweep %d/%d',whichScan,k,NAngles,Acc,AccNumber);
        panel.numberFreq.String = ['Freq number ' num2str(ii) '/' num2str(NPoints)];

        if RefMWOff == 2 && ~TestWithoutHardware
            WriteSMB('OUTP OFF');
            RefMWOff_Image2 = TakeCameraImageDouble(ISize,AOI);
            WriteSMB('OUTP ON');
        end

        if ~TestWithoutHardware
            if RANDOM == 1
                WriteSMB(['FREQ ',num2str(Ftot(RandomPerm(ii),1)),'GHz']);
                pause(0.05/NPerm);
            else
                if mod(Acc,2) == 1
                    WriteSMB(['FREQ ',num2str(Ftot(ii,1)),'GHz']);
                else
                    WriteSMB(['FREQ ',num2str(Ftot(NPoints-ii+1,1)),'GHz']);
                end
                pause(0.01);
            end
            if RefMWOff == 1
                ImageMatrixMW = TakeCameraImageDouble(ISize,AOI);
                ImageMatrix = ImageMatrixMW./RefMWOff_Image;
            elseif RefMWOff == 2
                ImageMatrixMW = TakeCameraImageDouble(ISize,AOI);
                ImageMatrix = ImageMatrixMW./RefMWOff_Image2;
            else
                ImageMatrix = TakeCameraImage(ISize,AOI);
            end
        else
            ImageMatrix = ImageTestMat(1:h_test-10+1,1:w_test-10+1) + 100*rand(h_test-9,w_test-9);
        end

        if ii == 1
            if RefMWOff ~= 0
                Lum_Current = uint32(ImageMatrixMW);
            else
                Lum_Current = ImageMatrix;
            end
        end

        % -- AutoAlignCrop --
        if Ctx.AutoAlignCrop && Acc > 1 && ii == 1
            [crop1_out,crop2_out] = Align2Files(Lum_Start_Crop,Lum_Current,0);
            Yshift = crop1_out(1)-crop2_out(1)-sign(crop1_out(1)-crop2_out(1))*max(0,sign(crop1_out(1)-crop2_out(1))*(size(Lum_Start_Crop,1)-size(Lum_Current,1)));
            Xshift = crop1_out(3)-crop2_out(3)-sign(crop1_out(1)-crop2_out(1))*max(0,sign(crop1_out(1)-crop2_out(1))*(size(Lum_Start_Crop,2)-size(Lum_Current,2)));
            if abs(Xshift) > 10 || abs(Yshift) > 10
                disp(['AutoAlignCrop sweep number' num2str(Acc) ': shift > 10 pixels, cancel']);
            else
                M_int = M; clear M;
                M(:,:,:) = M_int(crop1_out(1):crop1_out(2),crop1_out(3):crop1_out(4),:);
                clear M_int;
                Lum_int = Lum_Start_Crop; clear Lum_Start_Crop;
                Lum_Start_Crop(:,:) = Lum_int(crop1_out(1):crop1_out(2),crop1_out(3):crop1_out(4));
                clear Lum_int;
                y_start = crop2_out(1); y_end = crop2_out(2); x_start = crop2_out(3); x_end = crop2_out(4);
                if Xshift ~= 0 || Yshift ~= 0
                    disp(['AutoAlignCrop sweep number' num2str(Acc) ': xcrop = ' num2str(Xshift) ' pixel, ycrop = ' num2str(Yshift) ' pixel']);
                end
                [ROIHeight,ROIWidth,~] = size(M);
                UpdateStrSizeM(ROIWidth,ROIHeight,Ftot);
            end
        end

        % -- AutoAlignCam --
        if Ctx.AutoAlignCam && Acc > 1 && ii == 1
            if ~TestWithoutHardware
                LightOn(panel); [I,ISize,AOI] = PrepareCamera();
                Image_Align = TakeCameraImage(ISize,AOI);
                Lum_WithLightAndLaser = Image_Align;
                panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;
                Image_ref = Lum_Start_LightOn_LaserOn;
                AOI = GetAOI();
            else
                Image_Align = Lum_Current;
                Image_ref = Lum_Start_LightOn_LaserOn;
                AOI.Width = 59; AOI.Height = 175; AOI.X = 250; AOI.Y = 530;
            end

            C = normxcorr2_general(Image_ref,Image_Align,numel(Image_ref)/2);
            [ypeak, xpeak] = find(C==max(C(:)));
            Yshift = ypeak-AOI.Height;
            Xshift = xpeak-AOI.Width;
            if abs(Xshift) > 15 || abs(Yshift) > 15
                disp(['AutoAlignCam sweep number' num2str(Acc) ': shift > 15 pixels, cancel']);
            else
                if ~TestWithoutHardware
                    if Yshift ~= 0 || Xshift ~= 0
                        EndAcqCamera();
                        SetAOI(AOI.X+Xshift,AOI.Y+Yshift,AOI.Width,AOI.Height);
                        [I,ISize,AOI] = PrepareCamera();
                        Lum_WithLightAndLaser = TakeCameraImage(ISize,AOI);
                        panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;
                        LightOff(panel); [I,ISize,AOI] = PrepareCamera();
                    else
                        LightOff(panel); [I,ISize,AOI] = PrepareCamera();
                    end
                    pause(0.1);
                else
                    AOI.X = AOI.X+Xshift; AOI.Y = AOI.Y+Yshift;
                end
                if Xshift ~= 0 || Yshift ~= 0
                    disp(['AutoAlignCam sweep number' num2str(Acc) ': xshift = ' num2str(Xshift) ' pixel, yshift = ' num2str(Yshift) ' pixel']);
                end
            end
        end

        if ~Ctx.AutoAlignCrop
            y_start = 1; y_end = ROIHeight; x_start = 1; x_end = ROIWidth;
        end

        if RANDOM == 1
            M(:,:,RandomPerm(ii)) = (M(:,:,RandomPerm(ii))*(Acc-1)+double(ImageMatrix(y_start:y_end,x_start:x_end)))/Acc;
        else
            if mod(Acc,2) == 1
                M(:,:,ii) = (M(:,:,ii)*(Acc-1)+double(ImageMatrix(y_start:y_end,x_start:x_end)))/Acc;
            else
                M(:,:,NPoints-ii+1) = (M(:,:,NPoints-ii+1)*(Acc-1)+double(ImageMatrix(y_start:y_end,x_start:x_end)))/Acc;
            end
        end

        drawnow;

        if stop_tag.Value == 1
            stop_tag.ForegroundColor = [0,0,1];
            if ~panel.FinishSweep.Value && ~panel.FinishScan.Value
                stopped = true;
                break;
            end
        end
    end % frequency loop

    if Ctx.AF && mod(Acc,Ctx.AF_NumberSweeps) == 0
        [~,~,~,~,~] = FuncIndepAutofocusPiezo(panel);
    end

    if mod(Acc,Ctx.BackupNSweeps) == 0
        fullNameSave = [Ctx.Data_Path GetNameFromString(Ctx.BuildName) '_' whichScan 'Backup'];
        SaveMagScanMat(fullNameSave, Ctx, whichScan, Acc);
    end

    if panel.stop.Value ~=1 || (panel.stop.Value == 1 && panel.FinishScan.Value == 1)
        if panel.DisplayLight.Value
            if ~Ctx.AutoAlignCam
                LightOn(panel); [I,ISize,AOI] = PrepareCamera();
                Lum_WithLightAndLaser = TakeCameraImage(ISize,AOI);
                panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;
                LightOff(panel); [I,ISize,AOI] = PrepareCamera();
            end
            MaxLum = PrintImage(panel.Axes1,Lum_WithLightAndLaser,AOIParameters,str2double(panel.MaxLum.String),panel.MaxLumAlwaysAuto.Value);
        else
            panel.UserData.Lum_Current = Lum_Current;
            MaxLum = PrintImage(panel.Axes1,Lum_Current,AOIParameters,str2double(panel.MaxLum.String),panel.MaxLumAlwaysAuto.Value);
        end
        panel.MaxLum.String = num2str(MaxLum);
        panel.MaxLumLive.String = num2str(MaxLum);
    end

    guidata(gcbo,panel);
    PrintESR(panel,M); % this also fills panel.l31.YData with the binned, renormalized spectrum

    if stopped
        break;
    end

    if stop_tag.Value == 1 && ~panel.FinishScan.Value
        stopped = true;
        break;
    end

    if Acc == 1
        time_one_sweep = toc;
    end
    rem_time = (AccNumber-Acc)*time_one_sweep;
    if NAngles > 1 && k > 1
        rem_time_all = (NAngles-k+1)*time_one_angle_prev;
        panel.AcqTime.String = ['Remaining time = ' formatDuration(rem_time) newline 'Total Remaining = ' formatDuration(rem_time_all)];
    else
        panel.AcqTime.String = ['Remaining time = ' formatDuration(rem_time)];
    end

end % accumulation loop

if ~TestWithoutHardware
    EndAcqCamera();
end

endacq = toc(ScanTic);
measured_time_angle = endacq;
if NAngles > 1 && k < NAngles
    rem_time_all_final = (NAngles-k)*max(endacq,time_one_angle_prev);
    panel.AcqTime.String = ['Acquisition time = ' formatDuration(endacq) newline 'Total Remaining = ' formatDuration(rem_time_all_final)];
else
    panel.AcqTime.String = ['Acquisition time = ' formatDuration(endacq)];
end

Spectrum = panel.l31.YData(:); % binned & renormalized spectrum, identical to what PrintESR just plotted

end

%% ======================================================================

function SaveMagScanMat(fileName, Ctx, whichScan, Acc)
% Periodic backup save, mirrors ScanScript's BackupNSweeps behavior.

global M Ftot Lum_Current Lum_Initial Lum_WithLightAndLaser Lum_Start_LightOn_LaserOff Lum_Start_LightOff_LaserOn Lum_Start_LightOn_LaserOn CameraType

AcqParameters = Ctx.AcqParameters; %#ok<NASGU>
FitParameters = Ctx.FitParameters; %#ok<NASGU>
CenterF_GHz = Ctx.CenterF_GHz; Width_MHz = Ctx.Width_MHz; NPoints = Ctx.NPoints; %#ok<NASGU>
MWPower = Ctx.MWPower; RANDOM = Ctx.RANDOM; %#ok<NASGU>
ExposureTime = Ctx.ExposureTime; FrameRate = Ctx.FrameRate; PixelClock = Ctx.PixelClock; %#ok<NASGU>

save(fileName,'M','Ftot','CenterF_GHz','Width_MHz','NPoints','Acc','MWPower','ExposureTime','FrameRate','PixelClock', ...
    'RANDOM','AcqParameters','FitParameters','CameraType','Lum_Initial','Lum_Current','Lum_WithLightAndLaser', ...
    'Lum_Start_LightOn_LaserOff','Lum_Start_LightOff_LaserOn','Lum_Start_LightOn_LaserOn','whichScan');

end

%% ======================================================================

function SaveScanResults(Ctx, ScanLabel, AngleValues, ResultMatrix, FixedOtherAngle_deg, Bnorm, axTag)
% Exports the [freq x angle] PL matrix as a single-extension .dat
% (Python-friendly), a .mat with all relevant variables (mirroring
% ScanScript's final "Saving Data" section), and a .png of the plot.
% All three share a filename base, incremented together if it exists.

global M Ftot Lum_Current Lum_Initial Lum_WithLightAndLaser Lum_Start_LightOn_LaserOff Lum_Start_LightOff_LaserOn Lum_Start_LightOn_LaserOn CameraType

if isempty(ResultMatrix)
    disp(['No data acquired for ' ScanLabel ', nothing saved.']);
    return;
end

AcqParameters = Ctx.AcqParameters; %#ok<NASGU>
FitParameters = Ctx.FitParameters; %#ok<NASGU>
CenterF_GHz = Ctx.CenterF_GHz; Width_MHz = Ctx.Width_MHz; NPoints = Ctx.NPoints; %#ok<NASGU>
AccNumber = Ctx.AccNumber; MWPower = Ctx.MWPower; RANDOM = Ctx.RANDOM; %#ok<NASGU>
ExposureTime = Ctx.ExposureTime; FrameRate = Ctx.FrameRate; PixelClock = Ctx.PixelClock; %#ok<NASGU>
AcquisitionTime_minutes = Ctx.AcquisitionTime_minutes; %#ok<NASGU>

AngleValuesDone = AngleValues; %#ok<NASGU>
FixedOtherAngle = FixedOtherAngle_deg; %#ok<NASGU>
BNorm = Bnorm; %#ok<NASGU>

baseName = [Ctx.Data_Path GetNameFromString(Ctx.BuildName) '_' ScanLabel];
baseName = GetUniqueBaseName(baseName);

% -- .dat (Python-friendly) --
FullMatrix = [0, AngleValues; Ftot, ResultMatrix]; %#ok<NASGU>
datName = [baseName '.dat'];
writematrix(FullMatrix, datName, 'Delimiter', ',');
disp(['Magnetic scan results saved as ' datName]);

% -- .mat (full variable set, single clean extension) --
matName = [baseName '.mat'];
save(matName,'M','Ftot','ResultMatrix','AngleValuesDone','FixedOtherAngle','BNorm', ...
    'CenterF_GHz','Width_MHz','NPoints','AccNumber','MWPower','ExposureTime','FrameRate','PixelClock', ...
    'RANDOM','AcqParameters','FitParameters','CameraType','AcquisitionTime_minutes', ...
    'Lum_Initial','Lum_Current','Lum_WithLightAndLaser','Lum_Start_LightOn_LaserOff', ...
    'Lum_Start_LightOff_LaserOn','Lum_Start_LightOn_LaserOn','ScanLabel');
disp(['Magnetic scan .mat file saved as ' matName]);

% -- .png (plot snapshot) --
pngName = [baseName '.png'];
SaveScanPicture(axTag, pngName);
disp(['Magnetic scan picture saved as ' pngName]);

end

%% ======================================================================

function SaveScanPicture(axTag, pngName)
% Recreates the tab's plot cleanly in an off-screen figure and exports it,
% so the saved image contains only the plot, not surrounding UI controls.

axSrc = findobj('tag',axTag);
if isempty(axSrc)
    return;
end

figTemp = figure('Visible','off','Color','w','Units','pixels','Position',[100 100 900 650]);
axTemp = copyobj(axSrc(1), figTemp);
set(axTemp,'Units','normalized','Position',[0.12 0.12 0.8 0.78],'FontSize',11);
colorbar(axTemp);

exportgraphics(figTemp, pngName, 'Resolution', 200);
close(figTemp);

end

%% ======================================================================

function baseUnique = GetUniqueBaseName(baseName)
% Ensures baseName+.dat/.mat/.png don't already exist; if they do,
% increments a numeric suffix until a free triplet of names is found.

baseUnique = baseName;
idx = 1;
while exist([baseUnique '.dat'],'file') || exist([baseUnique '.mat'],'file') || exist([baseUnique '.png'],'file')
    baseUnique = sprintf('%s_%d', baseName, idx);
    idx = idx + 1;
end

end
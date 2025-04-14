%%%Scan script
global M ObjCamera CameraType Ftot TestWithoutHardware NI_card Lum_Current

% Separated from StartScript for ease of reading

%% Initialization

panel=guidata(gcbo);
panel.nameFile.String = ['File: ' nomSave];
panel.AcqTime.String = '';

if panel.acqcont.Value == 1
    set(panel.acqcont,'ForegroundColor',[0,0,0]);
    set(panel.acqcont,'Value',0);
    SaveCameraParam();
end

% List of variables to save
varList = {'M', 'Ftot', 'CenterF_GHz', 'Width_MHz', 'NPoints', 'Acc', 'MWPower', 'T', 'ExposureTime', 'FrameRate', 'PixelClock', ...
           'RANDOM', 'AcqParameters', 'FitParameters', 'CameraType', 'AcquisitionTime_minutes', 'Lum_Initial', 'Lum_Current','Lum_WithLightAndLaser'};
% variables to add when doing AutoAlignPiezo
var_to_add = {'z_out','foc_out', 'Shift_Z', 'fit_z_successful', 'X_piez', 'Y_piez', 'Corr_select_trans', 'Shift_X', 'Shift_Y', 'fit_xy_successful','Lum_Post_AutoCorr'};

% Initialize variables if empty

for i_init = 1:numel(varList)
    if ~exist(varList{i_init},'var')
        eval([varList{i_init} '= [];'])
    end
end

for i_init = 1:numel(var_to_add)
    if ~exist(var_to_add{i_init},'var')
        eval([var_to_add{i_init} '= [];'])
    end
end

if AutoAlignPiezo
    varFull = [varList, var_to_add];
else
    varFull = varList;
end

varFullFast = [varFull, '-v7.3', '-nocompression'];

% Check the value of the compression variable
if strcmp(SaveMode,'fast&heavy') % Save with -v7.3 and -nocompression    
    saveArgs = varFullFast;
elseif strcmp(SaveMode,'h5') % Spot for h5 save once I have the code from Thales?    
    saveArgs = varFull;
else % Save without additional options    
    saveArgs = varFull;
end

if ~TestWithoutHardware    
    FStart=CenterF_GHz-Width_MHz/1000/2;%Calculates start freq.
    FStep=Width_MHz/NPoints/1000;%Calculates freq. step
    Ftot=(FStart+(0:1:NPoints-1)*FStep)';%Total freq. array
    WriteSMB(['POW ',num2str(MWPower),' DBm']);%RF Power%% 
    OptimizeAcquisitionSpeed();% maximize speed by maximizing pixel clock and frame rate
    [ExposureTime,~] = GetExp();
    FrameRate = GetFrameRate();
    PixelClock = GetPixelClock();
    AOI = GetAOI();
    ROIWidth=AOI.Width;
    ROIHeight=AOI.Height;
    if strcmp(CameraType,'Andor')
        tempStatus = CheckAndorTemp();
    end
else % dummy parameters for testing without hardware
    AOI.Width = 59;AOI.Height = 175;AOI.X = 250;AOI.Y = 530;
    ROIWidth=AOI.Width;
    ROIHeight=AOI.Height;
    FStart=CenterF_GHz-Width_MHz/1000/2;%Calculates start freq.
    FStep=Width_MHz/NPoints/1000;%Calculates freq. step
    Ftot=(FStart+(0:1:NPoints-1)*FStep)';%Total freq. array
    TestMat = load('ImageTestMat.mat');
    ImageTestMat = TestMat.ImageTestMat;
    [h_test,w_test] = size(ImageTestMat);
end

M=zeros(ROIHeight,ROIWidth,NPoints);%Matrix used in main program
Pic=zeros(ROIHeight,ROIWidth,NPoints);%Matrix used in main program

UpdateStrSizeM(ROIWidth,ROIHeight,Ftot);

%% PerformAlignPiezo

if ~TestWithoutHardware && AutoAlignPiezo && i_scan > 1 && i_scan < AcqParameters.RepeatScan
    if panel.stop.Value~=1
        PerformAlignPiezo;
    end
end

if ~TestWithoutHardware && AutoAlignPiezo && i_scan == 1
    Lum_Post_AutoCorr = Lum_Initial; X_piez = []; Y_piez = []; Corr_select_trans = []; Shift_X = []; Shift_Y = []; fit_xy_successful = [];
end

%% First Image

if panel.shutterlaser.Value == 0
    LaserOn(panel);% to turn on the laser for the scan part
end

% Taking reference images with light on
if ~TestWithoutHardware
    LightOn(panel);
    [I,ISize,AOI] = PrepareCamera();
    Lum_WithLightAndLaser=TakeCameraImage(ISize,AOI);
    panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;
else
    Lum_WithLightAndLaser = ImageTestMat(1:h_test-10+1,1:w_test-10+1);
end

% Taking reference images with light on and laser off for piezo alignment procedure
if  ~TestWithoutHardware && i_scan == 1 && AutoAlignPiezo
    if AcqParameters.RepeatScan > 1
        disp('Initial Autofocus Z when RepeatScan > 1')
         [Opt_Z, z_out, foc_out, Shift_Z, fit_z_successful] = FuncIndepAutofocusPiezo(panel);
    end

    Lum_Initial=Lum_WithLightAndLaser;
    writematrix(Lum_Initial,[Data_Path nomSave '_Lum_Initial.csv']);
    ax_lum_initial = panel.ax_lum_initial;
    imagesc(ax_lum_initial,Lum_Initial);axis(ax_lum_initial,'image');caxis(ax_lum_initial,[0 maxLum]);
    title(ax_lum_initial, 'Initial reference image for autocorrelation');

    LaserOff(panel);
    if strcmp(CameraType,'Andor')
        [I,ISize,AOI] = PrepareCamera(); % need to prepare AFTER LightOn or LightOff, I don't know why
    end
    Lum_Initial_LaserOff=TakeCameraImage(ISize,AOI);
    LaserOn(panel);
    if strcmp(CameraType,'Andor')
        [I,ISize,AOI] = PrepareCamera(); % need to prepare AFTER LightOn or LightOff, I don't know why
    end
end

if ~TestWithoutHardware
    LightOff(panel);% to turn off the light for the scan part
    [I,ISize,AOI] = PrepareCamera();
end

if ~TestWithoutHardware 
    ImageMatrix = TakeCameraImage(ISize,AOI); % Take Start Camera Image
else
    ImageMatrix = ImageTestMat(1:h_test-10+1,1:w_test-10+1)+100*rand(h_test-9,w_test-9);      
end

Lum_Start = ImageMatrix;Lum_Start_Crop = Lum_Start;

if ~exist('Lum_Initial','var')
    Lum_Initial = Lum_Start;
end

if panel.DisplayLight.Value   
    PrintImage(panel.Axes1,Lum_WithLightAndLaser,AOIParameters);
else
    PrintImage(panel.Axes1,Lum_Start,AOIParameters);
end

panel.UserData.Lum_Current = Lum_Start; % not exactly the same image potentially but simpler for now
guidata(gcbo,panel);


%% Switching MW on and reading the temperature

if ~TestWithoutHardware
    WriteSMB('OUTP ON'); %RF Power ON
end

T=[];
if Read_Temp
    if ~TestWithoutHardware
        T_init=ReadTemp();
    else
        T_init = rand(2,1);
    end
    panel.Temp_txt.String  = sprintf(['Ta=' num2str(roundn(T_init(1),-2)) '\nTb=' num2str(roundn(T_init(2),-2))]); %T(Acc,1) to print Ta; T(Acc,2) to print Tb
end

tic
startTime = datetime('now'); % Capture l'heure de départ

if RANDOM == 1  
    disp('Mode random freq: longer pause after generator instruction to account for longer time to reach frequency target');
end     

NPerm = 1; % découpage de la Width_MHz totale en segments pour éviter des écarts de fréquence trop grands entre les pics, utile quand random

%% Starting the scan loop (not the RF loop)

for Acc=1:(AccNumber+99*ALIGN*AccNumber) %Loop on Accumulation number
    if RANDOM == 1    
        RandomPerm = [];
        for iperm=1:NPerm
            if iperm ~= NPerm
                lenPerm = floor(length(Ftot)/NPerm);
            else
                lenPerm = length(Ftot)-(NPerm-1)*floor(length(Ftot)/NPerm); % si length(Ftot) n'est pas un multiple de NPerm
            end
            perm = randperm(lenPerm)+(iperm-1)*lenPerm;
            RandomPerm = [RandomPerm perm];
        end
    end
    if RefMWOff == 1 && ~TestWithoutHardware
        WriteSMB('OUTP OFF'); %RF Power OFF
        RefMWOff_Image = TakeCameraImageDouble(ISize,AOI);%Take reference image in double value format  
        WriteSMB('OUTP ON'); %RF Power ON
    end

    for ii=1:NPoints % Starting the RF loop
        strInfo1=['Sweep number ' num2str(Acc) '/' num2str(AccNumber)];
        strInfo2=['Freq number ' num2str(ii) '/' num2str(NPoints)];
        panel.numberSweep.String = strInfo1;
        panel.numberFreq.String = strInfo2;%Display info on scan numbers
        
        if RefMWOff == 2 && ~TestWithoutHardware
            WriteSMB('OUTP OFF'); %RF Power OFF
            RefMWOff_Image2 = TakeCameraImageDouble(ISize,AOI);%Take reference image in double value format
            WriteSMB('OUTP ON'); %RF Power ON
        end
    
        if ~TestWithoutHardware
            if RANDOM == 1
                WriteSMB(['FREQ ',num2str(Ftot(RandomPerm(ii),1)),'GHz']); %Change RF freq.
                pause(0.05/NPerm); % plus il y a de permutations, moins la pause a besoin d'être longue
            else
                if mod(Acc,2) == 1 % montant puis descendant une acq sur deux pour éviter l'erreur dû au retour au premier point de la rampe
                    WriteSMB(['FREQ ',num2str(Ftot(ii,1)),'GHz']); %Change RF freq up
                else
                    WriteSMB(['FREQ ',num2str(Ftot(NPoints-ii+1,1)),'GHz']); %Change RF freq down
                end
                pause(0.01);   
            end            
        end
        if ~TestWithoutHardware
            if RefMWOff == 1
                ImageMatrixMW = TakeCameraImageDouble(ISize,AOI);%Take Camera Image in double value format
                ImageMatrix = ImageMatrixMW./RefMWOff_Image; % for each pixel we get the value of the PL with MW divided by the PL without MW
            elseif RefMWOff == 2
                ImageMatrixMW = TakeCameraImageDouble(ISize,AOI);%Take Camera Image in double value format
                ImageMatrix = ImageMatrixMW./RefMWOff_Image2; % for each pixel and each frequency we get the value of the PL with MW divided by the PL without MW
           else
                ImageMatrix = TakeCameraImage(ISize,AOI);%Take Camera Image in uint32 value format
            end
        else %testing various misalignment without hardware
            if Acc == 1
                ImageMatrix = ImageTestMat(1:h_test-10+1,1:w_test-10+1)+100*rand(h_test-9,w_test-9);
                test1 = ImageMatrix;
            elseif Acc == 2
                ImageMatrix = ImageTestMat(5:h_test-10+5,5:w_test-10+5)+100*rand(h_test-9,w_test-9);
                test2 = ImageMatrix;
            else
                ImageMatrix = ImageTestMat(8:h_test-10+8,8:w_test-10+8)+100*rand(h_test-9,w_test-9);
                test3 = ImageMatrix;
            end
        end  
        if ii == 1
            % Lum_Current needs to be an array with uint32 value format
            if RefMWOff ~= 0
                Lum_Current = uint32(ImageMatrixMW);
            else
                Lum_Current = ImageMatrix;
            end
        end
        if AutoAlignCrop && Acc == 1 && ii == 1
            y_start = 1; y_end = ROIHeight; x_start = 1; x_end = ROIWidth;
        end
        if AutoAlignCrop && Acc > 1 && ii == 1         
            [crop1_out,crop2_out] = Align2Files(Lum_Start_Crop,Lum_Current,0);
            Yshift = crop1_out(1)-crop2_out(1)-sign(crop1_out(1)-crop2_out(1))*max(0,sign(crop1_out(1)-crop2_out(1))*(size(Lum_Start_Crop,1)-size(Lum_Current,1)));
            Xshift = crop1_out(3)-crop2_out(3)-sign(crop1_out(1)-crop2_out(1))*max(0,sign(crop1_out(1)-crop2_out(1))*(size(Lum_Start_Crop,2)-size(Lum_Current,2)));
            if abs(Xshift) > 10 || abs(Yshift) > 10
                disp(['AutoAlignCrop sweep n°' num2str(Acc) ': shift > 10 pixels, cancel']);
            else
                M_int = M;clear M;
                M(:,:,:) = M_int(crop1_out(1):crop1_out(2),crop1_out(3):crop1_out(4),:);
                clear M_int;
                Lum_int = Lum_Start_Crop;clear Lum_Start_Crop;
                Lum_Start_Crop(:,:) = Lum_int(crop1_out(1):crop1_out(2),crop1_out(3):crop1_out(4));
                clear Lum_int;
                y_start=crop2_out(1);y_end=crop2_out(2);x_start=crop2_out(3);x_end=crop2_out(4);
                if Xshift ~=0 || Yshift ~=0
                    disp(['AutoAlignCrop sweep n°' num2str(Acc) ': xcrop = ' num2str(Xshift) ' pixel, ycrop = ' num2str(Yshift) ' pixel']);
                end
                [ROIHeight,ROIWidth,~] = size(M);
                UpdateStrSizeM(ROIWidth,ROIHeight,Ftot);
            end
        end
        
        if AutoAlignCam && Acc > 1 && ii == 1
            if ~TestWithoutHardware
                AOI = GetAOI();
            end              
            C = normxcorr2_general(Lum_Start,Lum_Current,numel(Lum_Start)/2);
            [ypeak, xpeak] = find(C==max(C(:)));
            Yshift = ypeak-AOI.Height;
            Xshift = xpeak-AOI.Width;            
            if abs(Xshift) > 10 || abs(Yshift) > 10
                disp(['AutoAlignCam sweep n°' num2str(Acc) ': shift > 10 pixels, cancel']);
            else
                if ~TestWithoutHardware
                    if Yshift ~= 0 || Xshift ~= 0
                        EndAcqCamera();
                        SetAOI(AOI.X+Xshift,AOI.Y+Yshift,AOI.Width,AOI.Height);
                        [I,ISize,AOI] = PrepareCamera();
                    end
                else
                    AOI.X=AOI.X+Xshift; AOI.Y=AOI.Y+Yshift;
                end
                if Xshift ~=0 || Yshift ~=0
                    disp(['AutoAlignCam sweep n°' num2str(Acc) ': xshift = ' num2str(Xshift) ' pixel, yshift = ' num2str(Yshift) ' pixel']);
                end
            end
        end
        
%       If we want to Align Piezo between each sweep
%         if ~TestWithoutHardware && AutoAlignPiezo && Acc > 1 && ii == 1
%             PerformAlignPiezo;
%         end
        
        if ~AutoAlignCrop
            y_start = 1; y_end = ROIHeight; x_start = 1; x_end = ROIWidth;
        end
        Pic(:,:,ii)=double(ImageMatrix);   
        if ALIGN == 1    
            if mod(Acc,2) == 1 % montant puis descendant une acq sur deux  
                M(:,:,ii)=double(ImageMatrix(y_start:y_end,x_start:x_end));   
            else
                M(:,:,NPoints-ii+1)=double(ImageMatrix(y_start:y_end,x_start:x_end));
            end         
        else            
            if RANDOM == 1                
            M(:,:,RandomPerm(ii))=(M(:,:,RandomPerm(ii))*(Acc-1)+double(ImageMatrix(y_start:y_end,x_start:x_end)))/Acc;%Add image to the mean value of M
            else
                if mod(Acc,2) == 1 % montant puis descendant une acq sur deux
                    M(:,:,ii)=(M(:,:,ii)*(Acc-1)+double(ImageMatrix(y_start:y_end,x_start:x_end)))/Acc;%Add image to the mean value of M
                else
                    M(:,:,NPoints-ii+1)=(M(:,:,NPoints-ii+1)*(Acc-1)+double(ImageMatrix(y_start:y_end,x_start:x_end)))/Acc;%Add image to the mean value of M
                end
            end
        end
     
        drawnow; % Update GUI

        if panel.stop.Value==1 % Check STOP button
            panel.stop.ForegroundColor = [0,0,1];
            if ~panel.FinishSweep.Value
                break;
            end
        end
    end % end of RF loop
    
    if Read_Temp
        if ~TestWithoutHardware
            T(Acc,:)=ReadTemp();
        else
            T(Acc,:) = rand(2,1);
        end
        panel.Temp_txt.String  = sprintf(['Ta=' num2str(roundn(T_init(1),-2)) '\nTb=' num2str(roundn(T_init(2),-2))]); %T(Acc,1) to print Ta; T(Acc,2) to print Tb
        
    end
    
    if mod(Acc,BackupNSweeps) == 0     
        fullNameSave = [Data_Path nomSave];
        endacq = toc;
        AcquisitionTime_minutes = round(endacq/60); 
        load([getPath('Param') 'AcqParameters.mat']);load([getPath('Param') 'FitParameters.mat']);    
        if ~TestWithoutHardware
            if DelEx
                Store_Ftot = Ftot;Store_M = M;
                Ftot = Ftot(2:end-1);
                M = M(:,:,2:end-1);
            end                
            save(fullNameSave, varFullFast{:});
            if DelEx
                Ftot = Store_Ftot;
                M = Store_M;
                clear('Store_Ftot','Store_M');
            end
        else
            save(fullNameSave,'M','Ftot','CenterF_GHz','Width_MHz','NPoints','Acc','MWPower','T','RANDOM','AcqParameters');
        end 
    end

    if AF && mod(Acc,AF_NumberSweeps) == 0  
         [Opt_Z, z_out, foc_out, Shift_Z, fit_z_successful] = FuncIndepAutofocusPiezo(panel);
    end
    
    PixX=str2double(panel.PixX.String);%Read x_Pixel from GUI
    PixY=str2double(panel.PixY.String);%Read y_Pixel from GUI
    
    %%Plot Mean Image (to see if image is moving)
    if panel.stop.Value ~=1
        if  panel.DisplayLight.Value
            LightOn(panel);
            [I,ISize,AOI] = PrepareCamera();
            Lum_WithLightAndLaser=TakeCameraImage(ISize,AOI);
            panel.UserData.Lum_WithLightAndLaser = Lum_WithLightAndLaser;
            LightOff(panel);% to turn off the light for the scan part
            [I,ISize,AOI] = PrepareCamera();
            PrintImage(panel.Axes1,Lum_WithLightAndLaser,AOIParameters);
        else
            panel.UserData.Lum_Current = Lum_Current;
            PrintImage(panel.Axes1,Lum_Current,AOIParameters);
        end
    end
    
    guidata(gcbo,panel);
    PrintESR(panel,M);
    
    if panel.stop.Value==1%Check STOP Button
        break;
    end
    
    if Acc==1
        time_one_sweep = toc; 
    end
    
    rem_tim_minutes = round((AccNumber-Acc)*time_one_sweep/60);
    panel.AcqTime.String = ['Remaining time = ' num2str(rem_tim_minutes) ' minutes'];
    
end % end of acquisition

%% Saving Data

endacq = toc;
endTime = datetime('now'); % Capture l'heure de fin
elapsedTime = endTime - startTime; % Calcule la durée écoulée

AcquisitionTime_minutes = round(endacq/60);
[h, m, s] = hms(elapsedTime);
disp(['Scan lasted: ', num2str(floor(h)), 'h ', num2str(floor(m)), 'm ', num2str(round(s)), 's']);

panel.AcqTime.String = ['Acquisition time = ' num2str(AcquisitionTime_minutes) ' minutes'];

if ~TestWithoutHardware
    EndAcqCamera();
    SwitchGEN('OFF');%RF OFF
end

fullNameSave = [Data_Path nomSave];
load([getPath('Param') 'AcqParameters.mat']);load([getPath('Param') 'FitParameters.mat']);    
if ~TestWithoutHardware    
    if DelEx
        Store_Ftot = Ftot;Store_M = M;
        Ftot = Ftot(2:end-1);
        M = M(:,:,2:end-1);
    end
    disp('Saving...');
    save(fullNameSave, saveArgs{:});
    disp(['File saved as ' nomSave]);
    drawnow;%Update GUI
    if DelEx
        Ftot = Store_Ftot;
        M = Store_M;
        clear('Store_Ftot','Store_M');
    end
else
    save(fullNameSave,'M','Ftot','CenterF_GHz','Width_MHz','NPoints','Acc','MWPower','T','RANDOM','AcqParameters');
    disp(['File saved as' nomSave]);
end 

if  i_scan == AcqParameters.RepeatScan
    LightOn(panel); % start light and camera again at the true end of the acquisition

    panel.start.Value=0;panel.start.ForegroundColor = [1,0,0];
    panel.stop.Value=0;panel.stop.ForegroundColor = [1,0,0];

    if ~TestWithoutHardware
        InitCameraAtStart(CameraType);
    end
end


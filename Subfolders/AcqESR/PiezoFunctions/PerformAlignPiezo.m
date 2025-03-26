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

if strcmp(CameraType,'Andor')
    [I,ISize,AOI] = PrepareCamera(); % need to prepare AFTER LightOn or LightOff, I don't know why
end

CalibPiezoX = AcqParameters.CalibPiezoX; % µm per 10V % set in the Camera Panel
CalibPiezoY = AcqParameters.CalibPiezoY; % µm per 10V % set in the Camera Panel
CalibPixelCam =  AcqParameters.PixelCalib_nm/1000; % µm per pixel % set in the Camera Panel

PiezoRange = AcqParameters.PiezoRange;
PiezoSteps = AcqParameters.PiezoSteps;

Step = PiezoRange/(PiezoSteps-1);

LeftX = max([-10,IniX - PiezoRange/2]);
LeftY = max([-10,IniY - PiezoRange/2]);
RightX = min([IniX+PiezoRange/2,10]);
RightY = min([IniY+PiezoRange/2,10]);

%% Autofocus z
 [Opt_Z, z_out, foc_out, Shift_Z, fit_z_successful] = FuncIndepAutofocusPiezo(panel);

%% Autocorrélation xy
% Alignment procedure with laser off then laser spot correlation procedure with laser on

LightOn(panel); % turning light on for all piezo alignment procedures
Tension4 = LaserOff(panel); 

if strcmp(CameraType,'Andor')
    [I,ISize,AOI] = PrepareCamera(); % need to prepare AFTER LightOn or LightOff, I don't know why
end

% figure;imagesc(Lum_Initial);axis('image');caxis([0 65535]); % uncomment to test


% disp(['IniX = ' num2str(IniX)]); % uncomment to test
% disp(['IniY = ' num2str(IniY)]);

AOI_init = AOI;
ind_prog = 0;
for i=1:PiezoSteps
    for j=1:PiezoSteps
        ind_prog = ind_prog + 1;
        if rem(ind_prog,5) == 0 || ind_prog == 1
            disp(['Pre-alignment xy in progress ' num2str(ind_prog) '/' num2str(PiezoSteps^2)]);
        end
        NewX = min([10,LeftX + (i-1)*Step]); X_piez(i) = NewX;
        NewY = min([10,LeftY + (j-1)*Step]); Y_piez(j) = NewY;
        DeltaX_pix(i,j) = -round((CalibPiezoX*(NewX-IniX)/10)/CalibPixelCam); % moves the AOI to follow the laser movement
        DeltaY_pix(i,j) = -round((CalibPiezoY*(NewY-IniY)/10)/CalibPixelCam);

        if strcmp(CameraType,'Andor')
            EndAcqCamera();
        end

        SendAOItoCAM(AOI_init.X+DeltaX_pix(i,j),AOI_init.Y+DeltaY_pix(i,j),AOI_init.Width,AOI_init.Height);

        if strcmp(CameraType,'Andor')
            [I,ISize,AOI] = PrepareCamera();
        end

%         if i == 3 && j == 3
%             disp('test');
%         end

        ImageCurrent = TakeCameraImage(ISize,AOI);
%         figure;imagesc(ImageCurrent);axis('image');caxis([0 65535]); % uncomment to test
        AlignmentXY_List{i,j}=ImageCurrent;
    end
end

Tension4 = LaserOn(panel);
if strcmp(CameraType,'Andor')
    [I,ISize,AOI] = PrepareCamera();
end

ind_prog = 0;
for i=1:PiezoSteps
    for j=1:PiezoSteps
        ind_prog = ind_prog + 1;
        if rem(ind_prog,5) == 0 || ind_prog == 1
            disp(['Autocorrelation xy in progress ' num2str(ind_prog) '/' num2str(PiezoSteps^2)]);
        end

        %         disp(['NewX = ' num2str(NewX)]); % uncomment to test
        %         disp(['NewY = ' num2str(NewY)]);
        %         disp(['i = ' num2str(i)]);
        %         disp(['j = ' num2str(j)]);
        %         disp(DeltaX_pix(i,j));
        %         disp(DeltaY_pix(i,j));

        if strcmp(CameraType,'Andor')
            EndAcqCamera();
        end

        SendAOItoCAM(AOI_init.X+DeltaX_pix(i,j),AOI_init.Y+DeltaY_pix(i,j),AOI_init.Width,AOI_init.Height);

        if strcmp(CameraType,'Andor')
            [I,ISize,AOI] = PrepareCamera();
        end

        CheckMaxAndWriteNI(X_piez(i), Y_piez(j), Opt_Z, Tension4)

%         if i == 3 && j == 3
%             disp('test');
%         end

        ImageCurrent = TakeCameraImage(ISize,AOI);
%         figure;imagesc(ImageCurrent);axis('image');caxis([0 65535]); % uncomment to test
        LaserXYList{i,j}=ImageCurrent; 
    end
end

%% Treatment

for i=1:PiezoSteps
    for j=1:PiezoSteps
        [crop1_out,crop2_out] = Align2Files(Lum_Initial_LaserOff,AlignmentXY_List{i,j},0); % align images without laser by autocorr
        % uses those value to crop align the images with laser
        Pic1crop{i,j} = Lum_Initial(crop1_out(1):crop1_out(2),crop1_out(3):crop1_out(4)); % result: crop both images to center laser spot
        Pic2crop{i,j} = LaserXYList{i,j}(crop2_out(1):crop2_out(2),crop2_out(3):crop2_out(4));
        sizepic = size(Pic2crop{i,j});sizepicx(i,j) = sizepic(2);sizepicy(i,j) = sizepic(1);
        Corr_pic = xcorr2_fast_manual(Pic1crop{i,j},Pic2crop{i,j}); 
        Corr_simple(i,j) = sum(sum(Corr_pic)); % simple correlation value between the images
        [ypeak(i,j), xpeak(i,j)] = find(Corr_pic==max(Corr_pic(:))); % same method as Align2Files
        Number_pixels(i,j) = numel(Pic1crop{i,j});
    end
end

%%  % uncomment to test

% figure('Position',[1000,100,1200,1200]);
% k=0;
% for i=1:PiezoSteps
%     for j=1:PiezoSteps
%         k=k+1;
%         subplot(PiezoSteps,PiezoSteps,k)
%         imagesc(AlignmentXY_List{i,j});axis('image');caxis([0 65535]);
%     end
% end
% 
% figure('Position',[1000,100,1200,1200]);
% k=0;
% for i=1:PiezoSteps
%     for j=1:PiezoSteps
%         k=k+1;
%         subplot(PiezoSteps,PiezoSteps,k)
%         imagesc(LaserXYList{i,j});axis('image');caxis([0 65535]);
%     end
% end
% 
% figure('Position',[1000,100,1200,1200]);
% k=0;
% for i=1:PiezoSteps
%     for j=1:PiezoSteps
%         k=k+1;
%         subplot(PiezoSteps,PiezoSteps,k)
%         imagesc(Pic1crop{i,j});axis('image');caxis([0 65535]);
%     end
% end
% 
% figure('Position',[1000,100,1200,1200]);
% k=0;
% for i=1:PiezoSteps
%     for j=1:PiezoSteps
%         k=k+1;
%         subplot(PiezoSteps,PiezoSteps,k)
%         imagesc(Pic2crop{i,j});axis('image');caxis([0 65535]);
%     end
% end

% Image plotted in Piezo tab is inverted compared to the image listing
% here, to compare, plot this new one and position is consistent with full
% subplot images listings
% figure;imagesc(Y_piez,X_piez,Corr_select);axis('image');caxis([0 maxLum]);

%% Corr_pos version (I like it best for now)

Corr_pos = (abs(xpeak-sizepicx)+abs(ypeak-sizepicy)); % Finding the most correlated images
[~, min_idx_Corr_pos] = min(Corr_pos(:));
[x_best_Corr_pos, y_best_Corr_pos] = ind2sub(size(Corr_pos), min_idx_Corr_pos);

%% Corr_simple version 

Corr_renorm = Corr_simple./Number_pixels; % better to renormalize by the number of pixels in the cropped images

%% Version selected
% arbitrary threshold to ignore Corr_pos when it's not precise enough, generally indicate that the scanned range is too small

if numel(find(Corr_pos == 0)) > numel(Corr_pos)/2
    Corr_select = Corr_renorm;
    disp('Using Corr_renorm to estimate best position, check if range is large enough')
else
    Corr_select = Corr_pos;
end

%% Fit

% Generate 2D grid of X, Y coordinates
[X, Y] = meshgrid(1:size(Corr_select,2), 1:size(Corr_select,1));

% Invert data (since we are finding a minimum)
Z = Corr_select; 
Z_inv = max(Z(:)) - Z;

% Initial guesses for Gaussian parameters
A0 = max(Z_inv(:));  
[~, min_idx] = max(Z_inv(:));  
[y0, x0] = ind2sub(size(Z_inv), min_idx);
sigmaX0 = 1; 
sigmaY0 = 1; 
offset0 = min(Z_inv(:));  % Background level

% Flatten data for fitting
xdata = [X(:), Y(:)];
zdata = Z_inv(:);

% Define the 2D Gaussian function for fitting
gauss2D = @(p, xy) p(1) * exp(-((xy(:,1) - p(2)).^2 / (2 * p(3)^2) + (xy(:,2) - p(4)).^2 / (2 * p(5)^2))) + p(6);

% Initial parameters [A, x0, sigmaX, y0, sigmaY, offset]
p0 = [A0, x0, sigmaX0, y0, sigmaY0, offset0];

% Set optimization options
options = optimset('Display', 'off');

% Fit the 2D Gaussian model
try
    p_fit = lsqcurvefit(@(p, xy) gauss2D(p, xy), p0, xdata, zdata, [], [], options);
    
    % Extract fitted parameters
    A = p_fit(1);
    y_min_pos = p_fit(2);
    sigma_x = p_fit(3);
    x_min_pos = p_fit(4);
    sigma_y = p_fit(5);
    
    % Check for validity
    if isnan(x_min_pos) || isnan(y_min_pos) || x_min_pos < 1 || x_min_pos > size(Corr_select,2) || y_min_pos < 1 || y_min_pos > size(Corr_select,1)
        error('Fit failed: Invalid maximum position.');
    end

    fit_xy_successful = true;
    disp('2D Gaussian fit successful.');
catch
    % If the fit fails, use simple maximum search with smoothing
    disp('2D Gaussian fit failed. Using direct minimum search.');
    
    % Finding min closest to center
    [min_val,~] = min(Corr_select(:));
    [xmin_pos_vec, ymin_pos_vec] = find(Corr_select == min_val);
    center_row = (size(Corr_select,1)+1)/2;
    center_col = (size(Corr_select,2)+1)/2;

    distances = sqrt((xmin_pos_vec - center_row).^2 + (ymin_pos_vec - center_col).^2);
    [~,min_dist_idx] = min(distances);
    x_min_pos = xmin_pos_vec(min_dist_idx);
    y_min_pos = ymin_pos_vec(min_dist_idx);

    fit_xy_successful = false;
end

x_min = interp1(1:length(X_piez),X_piez,x_min_pos);
y_min = interp1(1:length(Y_piez),Y_piez,y_min_pos);

Opt_X = round(x_min*100)/100;
Opt_Y = round(y_min*100)/100;
Shift_X = Opt_X-IniX;
Shift_Y = Opt_Y-IniY;

% Plot results in piezo tab

Corr_select_trans = Corr_select.';

ax_piezo_autocorr = panel.ax_piezo_autocorr;
imagesc(ax_piezo_autocorr,X_piez,Y_piez,Corr_select_trans); axis(ax_piezo_autocorr,'image')
title(ax_piezo_autocorr, 'Last Autocorrelation XY - 2D Gaussian Fit');
xlabel(ax_piezo_autocorr,'Value of the X piezo (V)');
ylabel(ax_piezo_autocorr,'Value of the Y piezo (V)');
c = colorbar(ax_piezo_autocorr);
c.Label.String = 'Difference from the reference image (a.u.)';
hold(ax_piezo_autocorr,'on');
plot(ax_piezo_autocorr,x_min,y_min,'rx','MarkerSize',20,'LineWidth',2);
hold(ax_piezo_autocorr,'off');

disp(['Range tested from ' num2str(LeftX) ' V to ' num2str(RightX) ' V every ' num2str(Step) ' V']);
disp(['IniX = ' num2str(IniX) ' V']);
disp(['NewX = ' num2str(Opt_X) ' V']);
disp(['ShiftX = ' num2str(Shift_X) ' V']);

if Opt_X == LeftX ||  Opt_X == RightX
    disp('Edge of scanned X range reached');
end
disp(' ');

disp(['Range tested from ' num2str(LeftY) ' V to ' num2str(RightY) ' V every ' num2str(Step) ' V']);
disp(['IniY = ' num2str(IniY) ' V']);
disp(['NewY = ' num2str(Opt_Y) ' V']);
disp(['ShiftY = ' num2str(Shift_Y) ' V']);

if Opt_Y == LeftY ||  Opt_Y == RightY
    disp('Edge of scanned Y range reached');
end
disp(' ');

UpdateInputPiezo(Opt_X,Opt_Y,Opt_Z,AcqParameters.PiezoLight,panel); % stores the right piezo values

CheckMaxAndWriteNI(Opt_X, Opt_Y, Opt_Z, Tension4); % send new values to NI card 

% found the best laser position, but the precision for the AOI is not as good as with using normxcorr2_general > now we redo the AOI without laser (better)

LaserOff(panel);

EndAcqCamera();
SendAOItoCAM(AOI_init.X,AOI_init.Y,AOI_init.Width,AOI_init.Height);
[I,ISize,AOI] = PrepareCamera();
ImageCurrent = TakeCameraImage(ISize,AOI);
C = normxcorr2_general(Lum_Initial_LaserOff,ImageCurrent,numel(Lum_Initial)/2);

[ypeak_realign, xpeak_realign] = find(C==max(C(:)));
Yshift = ypeak_realign-AOI_init.Height;
Xshift = xpeak_realign-AOI_init.Width;
disp(['X shift = ' num2str(Xshift) ' pixels'])
disp(['Y shift = ' num2str(Yshift) ' pixels'])

LaserOn(panel);

EndAcqCamera();
SetAOI(AOI_init.X+Xshift,AOI_init.Y+Yshift,AOI_init.Width,AOI_init.Height);
[I,ISize,AOI] = PrepareCamera();
Lum_Post_AutoCorr = TakeCameraImage(ISize,AOI);

ax_lum_post_autocorr = panel.ax_lum_post_autocorr;
imagesc(ax_lum_post_autocorr,Lum_Post_AutoCorr);axis(ax_lum_post_autocorr,'image');caxis(ax_lum_post_autocorr,[0 maxLum]);
title(ax_lum_post_autocorr, 'New image post autocorrelation');


%% Turning light back off

LightOff(panel);

if strcmp(CameraType,'Andor')
    [I,ISize,AOI] = PrepareCamera(); % need to prepare AFTER LightOn or LightOff, I don't know why
end


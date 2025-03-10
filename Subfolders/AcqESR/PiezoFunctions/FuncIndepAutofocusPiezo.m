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

PiezoRangeZ = AcqParameters.PiezoRange*2;
PiezoStepsZ = AcqParameters.PiezoSteps*2+1;
StepZ = PiezoRangeZ/(PiezoStepsZ-1);
LeftZ = max([0,IniZ - PiezoRangeZ/2]);
RightZ = min([IniZ+PiezoRangeZ/2,10]);

LightOn(panel); % turning light on for all piezo alignment procedures
Tension4 = LaserOff(panel); % the laser spot prevents perfect autofocus, especially if there is a shiny pressure gauge in the image

%% Loop on piezoZ

foclist = {'BREN','CONT','GDER','GLLV','GRAE','GRAT','HELM','HISR','LAPD','LAPE','LAPV','SFRQ','TENG','TENV','VOLA','WAVV','WAVR','ACMO','CURV','DCTE','DCTR','GLVA','GLVN','GRAS','HISE','LAPM','SFIL','WAVS'}; % all possible methods
ChoiceFocMethod = 'DCTR';

ind_prog = 0;
disp(['Starting autofocus z using ' ChoiceFocMethod ' method']);
for k=1:PiezoStepsZ
    ind_prog = ind_prog + 1;
    if rem(ind_prog,2) == 0 || ind_prog == 1
        disp(['Autofocus z in progress ' num2str(ind_prog) '/' num2str(PiezoStepsZ)]);
    end
    NewZ = min([10,LeftZ + (k-1)*StepZ]);
    CheckMaxAndWriteNI(IniX, IniY, NewZ, Tension4)
    if strcmp(CameraType,'Andor')
        EndAcqCamera();
        [I,ISize,AOI] = PrepareCamera();
    end
        ImageCurrent = TakeCameraImage(ISize,AOI);
    %     figure;imagesc(ImageCurrent);axis('image'); % uncomment to test

    FM(k) =  fmeasure(ImageCurrent, ChoiceFocMethod); % BREN method, worked at ENS, DCTR method, works at CEA
    Z_piez(k)=NewZ;
%     for ifoc = 1:numel(foclist) % uncomment to test
%         FM_foc(ifoc,k) = fmeasure(ImageCurrent, foclist{ifoc});
%     end
end

% for ifoc = 1:numel(foclist) % uncomment to test
%     figure;plot(Z_piez(:),FM_foc(ifoc,:));
% end

% figure;plot(Z_piez(:),FM); % uncomment to test
% writematrix(FM,['C:\Users\Raman\Documents\Data_NV\' 'FMtest7.txt']); % uncomment to test

% Find Opt_Z with gaussian fit

x = Z_piez.';  % Define x-axis positions
FM = FM.';  % Ensure column vector

try
    % Perform Gaussian fit
    f = fit(x, FM, 'gauss1');

    % Get Gaussian parameters from fit
    A = f.a1;    % Amplitude
    mu = f.b1;   % Mean (peak position)
    sigma = f.c1 / sqrt(2); % Convert MATLAB's width parameter to standard deviation

    % Check if the fit is valid
    if isnan(A) || isnan(mu) || isnan(sigma) || mu < min(x) || mu > max(x)
        error('Gaussian fit failed: Invalid peak position or NaN values.');
    end
    
    % Generate fitted values manually
    x_fit = linspace(min(x), max(x), 100);
    y_fit = A * exp(-((x_fit - mu).^2) / (2 * sigma^2)); % Corrected Gaussian formula

    fit_successful = true;
    disp('Gaussian fit successful.');
catch
    % If the fit fails, estimate peak using a simple moving average
    disp('Gaussian fit failed. Using a simple moving average to estimate peak.');

    windowSize = 5; % Size of moving average window
    y_smooth = movmean(FM, windowSize); % Apply smoothing
    [A, idx] = max(y_smooth); % Find peak position in smoothed data
    mu = x(idx);
    
    % Generate a fallback plot using smoothed data
    fit_successful = false;
end

Opt_Z = round(mu*100)/100;

% Plot results in piezo tab

ax_piezo_autofoc = panel.ax_piezo_autofoc;

plot(ax_piezo_autofoc, x, FM, 'bo', 'MarkerSize', 6, 'DisplayName', 'Data');
hold(ax_piezo_autofoc, 'on');
grid(ax_piezo_autofoc, 'on');
title(ax_piezo_autofoc, 'Last Autofocus Z - Gaussian Fit');
xlabel(ax_piezo_autofoc, 'Value of the Z piezo (V)');  
ylabel(ax_piezo_autofoc, 'Autofocus estimation (a.u.)');  

if fit_successful
    plot(ax_piezo_autofoc, x_fit, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Gaussian Fit');
    plot(ax_piezo_autofoc, mu, A, 'g*', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Estimated Peak');
    hold(ax_piezo_autofoc, 'off');
else
    plot(ax_piezo_autofoc, x, y_smooth, 'm-', 'LineWidth', 2, 'DisplayName', 'Moving Average');
    plot(ax_piezo_autofoc, mu, A, 'k*', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Estimated Peak (Fallback)');
    hold(ax_piezo_autofoc, 'off');
end

legend(ax_piezo_autofoc,'Location','south');
drawnow;

% legend(ax_piezo_autofoc);
% xlabel('Value of the Z piezo (V)');
% ylabel('Autofocus estimation (a.u.)');
% title('Gaussian Fit to Dome-Shaped Data');

% Disp results

disp(['Range tested from ' num2str(LeftZ) ' V to ' num2str(RightZ) ' V every ' num2str(StepZ) ' V'])
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

if strcmp(CameraType,'Andor')
    [I,ISize,AOI] = PrepareCamera(); % need to prepare AFTER LightOn or LightOff, I don't know why
end

end
clearvars;addpath('../Functions FitESR')
% Execute sections of interest one after the other
% should probably better adapt to more than 2 files, or only 2 files

%% Treatment parameters

DataPath = 'U:\cea_homes\donnees-lhps\donnees-lhps\Loïc\Manips\Thermométrie\Premiers tests sur fibre\Traitement\';

%% Choosing the fitted files to load from

[FileNames,PathName] = uigetfile('*.mat','Select the .mat files', 'MultiSelect','on',DataPath);
N = length(FileNames);

%% Loading all relevant data from the files

for K = 1 : N
  Cell_fullname{K} = FileNames{K};
  load([PathName Cell_fullname{K}],'fname','NumComp','IsPair','NumCompFittofield','size_pix','Cropping_Coord',...
      'FitMethod','BinThr','VarWidths','CorrectPermutation','Renormalize_Parameters','ColorRescale',...
      'StdforRescalingTeslas','Smoothing_Factor','Detrending_Factor','ClearFFT','TrackingFit','RemPositive','ESRMatrix',...
      'v_MHz','NumSweep','ExposureTime','FrameRate','PixelClock','MWPower','FitTot','SaveName','x_start', 'y_start',...
      'x_stoptoend', 'y_stoptoend', 'wcrop', 'hcrop','x_um','y_um');
  Cell_fname{K} = fname(1:end-4);
  Cell_NumComp{K} = NumComp;
  Cell_IsPair{K} = IsPair;
  Cell_NumCompFittofield{K} = NumCompFittofield;
  Cell_size_pix{K} = size_pix;
  Cell_Cropping_Coord{K} = Cropping_Coord;
  Cell_FitMethod{K} = FitMethod;
  Cell_BinThr{K} = BinThr;
  Cell_VarWidths{K} = VarWidths;
  Cell_CorrectPermutation{K} = CorrectPermutation;
  Cell_Renormalize_Parameters{K} = Renormalize_Parameters;
  Cell_ColorRescale{K} = ColorRescale;
  Cell_StdforRescalingTeslas{K} = StdforRescalingTeslas;
  Cell_Smoothing_Factor{K} = Smoothing_Factor;
  Cell_Detrending_Factor{K} = Detrending_Factor;
  Cell_ClearFFT{K} = ClearFFT;
  Cell_TrackingFit{K} = TrackingFit;
  Cell_RemPositive{K} = RemPositive;
  Cell_ESRMatrix{K} = ESRMatrix;
  Cell_v_MHz{K} = v_MHz;
  Cell_NumSweep{K} = NumSweep;
  Cell_ExposureTime{K} = ExposureTime;
  Cell_FrameRate{K} = FrameRate;
  Cell_PixelClock{K} = PixelClock;
  Cell_MWPower{K} = MWPower;
  Cell_FitTot{K} = FitTot;
  Cell_SaveName{K} = SaveName;
  Cell_x_start{K} = x_start;
  Cell_y_start{K} = y_start;
  Cell_x_stoptoend{K} = x_stoptoend;
  Cell_y_stoptoend{K} = y_stoptoend;
  Cell_wcrop{K} = wcrop;
  Cell_hcrop{K} = hcrop;
  Cell_x_axis{K} = x_um;
  Cell_y_axis{K} = y_um;
  
  clear('fname','NumComp','IsPair','NumCompFittofield','size_pix','Cropping_Coord',...
      'FitMethod','BinThr','VarWidths','CorrectPermutation','Renormalize_Parameters','ColorRescale',...
      'StdforRescalingTeslas','Smoothing_Factor','Detrending_Factor','ClearFFT','TrackingFit','RemPositive','ESRMatrix',...
      'v_MHz','NumSweep','ExposureTime','FrameRate','PixelClock','MWPower','FitTot','SaveName','x_start', 'y_start',...
      'x_stoptoend', 'y_stoptoend', 'wcrop', 'hcrop','x_um','y_um');
end

%% Update Cell_Cropping_Coord

for K=1:N
    if Cell_Cropping_Coord{K}(1) == 0
        Cell_Cropping_Coord{K} = [0,1,1,Cell_wcrop{K},Cell_hcrop{K}];
    end
end

%% Plot all luminescence images

freq_val = 5;
figAllLum = figure('Name','Luminescence image of all files','Position',FigSizePosition(0.5));

for K = 1:N    
    subplot(1,2,K);
    imagesc(Cell_ESRMatrix{K}(Cell_Cropping_Coord{K}(3):Cell_Cropping_Coord{K}(5),Cell_Cropping_Coord{K}(2):Cell_Cropping_Coord{K}(4),freq_val)); 
    title(Cell_fname{K},'Interpreter','none');
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)');  
    c = colorbar;
    c.FontSize = 10.5;
end

%% Plot an ESR spectrum from the fit results
% Does not modify the data, only displays it
% K is the pressure value
PlotpStart = 0;
CalibDist = 0;
K = 2;
ix = 146; iy = 185;

[spectre, BinOut] = extractEsrThr(Cell_ESRMatrix{K}, ix+Cell_x_start{K}-1, iy+Cell_y_start{K}-1, Cell_BinThr{K});
spectre = PerformTreatmentOperations(spectre, Cell_v_MHz{K}, Cell_Smoothing_Factor{K}, Cell_Detrending_Factor{K}, Cell_ClearFFT{K}, 0);

jx = squeeze(Cell_FitTot{K}(iy,ix,:));
if PlotpStart == 0
    pStart = jx*0;
end
Ffit = DefJacFw(Cell_v_MHz{K}, Cell_VarWidths{K}, Cell_NumComp{K}, Cell_IsPair{K}); % necessary for the plot
PlotFitParam(Cell_v_MHz{K}, spectre, ix, iy, Cell_x_axis{K}, Cell_y_axis{K}, Cell_fname{K}, Ffit(pStart), Ffit(jx), Cell_BinThr{K}, BinOut, CalibDist, Cell_FitMethod{K}, PlotpStart);

% plotESRSp(spectre, ix, iy, Cell_v_MHz{K}, Cell_x_axis{K}, Cell_y_axis{K}, Cell_fname{K}, Cell_BinThr{K}, BinOut, CalibDist); 
% saveas(gcf,[TreatedDataPath '\' fname(1:end-4) '-ESR Spectrum.jpeg'],'jpeg');

%% Realign images, defining a new Cropping_Coord for each file
freq_val = 5;

image1 = Cell_ESRMatrix{1}(Cell_Cropping_Coord{1}(3):Cell_Cropping_Coord{1}(5),Cell_Cropping_Coord{1}(2):Cell_Cropping_Coord{1}(4),freq_val);
image2 = Cell_ESRMatrix{2}(Cell_Cropping_Coord{2}(3):Cell_Cropping_Coord{2}(5),Cell_Cropping_Coord{2}(2):Cell_Cropping_Coord{2}(4),freq_val);

[crop1,crop2] = Align2Files(image1,image2,1);

Cell_Cropping_Coord{1}(2:5) = [crop1(3),crop1(1),crop1(4),crop1(2)];
Cell_Cropping_Coord{2}(2:5) = [crop2(3),crop2(1),crop2(4),crop2(2)];

%% Plot all raw middle frequency maps
Calib_Dist = 1;
PlotScale = [2860,2870]; % [min,max], or 0 for scale adapting to each file

figAllMid = figure('Name','ESR middle frequency of all files','Position',FigSizePosition(0.5));
for K = 1:N    
    FM = Cell_FitTot{K}(:,:,4);
    subplot(1,2,K);
    plotMiddleFreq(FM, Cell_ESRMatrix{K}, PlotScale, Cell_fname{K}, Cell_size_pix{K}, Calib_Dist, Cell_Cropping_Coord{K})
end

%% Add a filter based on contrast and plot corrected frequency maps
SAVE = 1;
Calib_Dist = 1;
PlotScale = [2860,2870]; % [min,max], or 0 for scale adapting to each file
Contrast_Threshold = 4; % in percent

figAllMid = figure('Name','ESR middle frequency of all files','Position',FigSizePosition(0.5));
for K = 1:N    
    FM_filtered = Cell_FitTot{K}(:,:,4);
    Mean_Contrast = (Cell_FitTot{K}(:,:,1)+Cell_FitTot{K}(:,:,1))./2;
    FM_filtered(Mean_Contrast < Contrast_Threshold/100) = NaN;
    Cell_FM_filter{K} = FM_filtered;
    subplot(1,2,K);
    plotMiddleFreq(FM_filtered, Cell_ESRMatrix{K}, PlotScale, Cell_fname{K}, Cell_size_pix{K}, Calib_Dist, Cell_Cropping_Coord{K})
end

if SAVE == 1
    SaveName = ['FM_filtered-' num2str(Contrast_Threshold) '-AllFiles'];
    saveas(figAllMid,[DataPath SaveName '.jpeg'],'jpeg');
    saveas(figAllMid,[DataPath SaveName '.svg'],'svg');
end

%% Determine temperature change, comparing between the two images
rate = - 0.074; % -74 kHz/K, in MHz
Calib_Dist = 1;
temp_scale = [0,125];
SAVE = 1;

Temp_Change = (Cell_FM_filter{2}-Cell_FM_filter{1})/rate;

[h, w] = size(Temp_Change);
if Calib_Dist == 1
    [x_axis, y_axis] = xyAxes_um(w,h,Cell_size_pix{1});
    xlabel_str = 'x (\mum)';
    ylabel_str = 'y (\mum)';
else 
    [x_axis, y_axis] = xyAxes(w,h);
    xlabel_str = 'x (pixels)';
    ylabel_str = 'y (pixels)';
end

figTempChange = figure('Name','Temperature change between the two acquisitions','Position',FigSizePosition(0.5));
imagesc(x_axis,y_axis,Temp_Change,'AlphaData',~isnan(Temp_Change));
title({'Temperature change between the two acquisitions (K)';''});
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel(xlabel_str);
ylabel(ylabel_str);
caxis(temp_scale);
c = colorbar;
c.FontSize = 10.5;

if SAVE == 1
    SaveName = ['Temp_change' '_filtered-' num2str(Contrast_Threshold)];
    saveas(figTempChange,[DataPath SaveName '.jpeg'],'jpeg');
    saveas(figTempChange,[DataPath SaveName '.svg'],'svg');
end
    
%% Save all
% Don't forget to change the name if needed

saveAllName = 'FullResultsThermoTest_2020-03-11';

save([DataPath saveAllName '.mat']);    
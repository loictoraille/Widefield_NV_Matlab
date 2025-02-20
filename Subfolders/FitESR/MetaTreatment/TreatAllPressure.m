clearvars;addpath('../Functions FitESR')
% Execute sections of interest one after the other
% Inspired from TreatAllPressure (old version), go look at it if needed

%% Treatment parameters

DataPath = 'D:\Documents\Boulot\Manips\Soleil\Data traitées - best versions\';

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

%% Load Pressure for all the files chosen
% Use the txt file containing all pressure values, and identify which one
% is the correct one for each set of data using their name

fid = fopen([DataPath 'Pressure.txt'], 'rt');
PrubyComp = textscan(fid, '%s %f', 'HeaderLines', 0, 'CollectOutput', true);
fclose(fid);
Pruby_Names = PrubyComp{1};
Pruby_Values = PrubyComp{2};

for K=1:N
    I = 1;    
    while strcmp(Cell_fname{K},Pruby_Names{I}) == 0
        I=I+1;
    end
    Cell_Pressure{K} = Pruby_Values(I);
    Pressure(K) = Pruby_Values(I);
end 

%% Plot all luminescence images

freq_val = 5;

figAllLum = figure('Name','Luminescence image of all files','Position',[60,50,1420,850]);

for K = 1:N    
    subplot(4,4,K);
    imagesc(Cell_ESRMatrix{K}(Cell_Cropping_Coord{K}(3):Cell_Cropping_Coord{K}(5),Cell_Cropping_Coord{K}(2):Cell_Cropping_Coord{K}(4),freq_val)); 
    title([num2str(Pressure(K)) ' GPa']);
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
CalibDist = 1;
K = 8;
ix = 60; iy = 64;

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

%% Compare luminescence signal with pressure

freq_val = 5;

for K=1:N
    [rowmax,rowmaxpos] = max(Cell_ESRMatrix{K}(Cell_Cropping_Coord{K}(3):Cell_Cropping_Coord{K}(5),Cell_Cropping_Coord{K}(2):Cell_Cropping_Coord{K}(4),freq_val));
    [columnmax,columnmaxpos] = max(rowmax);
    imax = columnmaxpos;
    jmax = rowmaxpos(columnmaxpos);
    Maxlum(K) = mean(mean(Cell_ESRMatrix{K}(jmax-2:jmax+2,imax-2:imax+2,freq_val)));
    Ratio(K) = Maxlum(K)/Cell_ExposureTime{K};
end

figRatio = figure;
plot(Pressure,Ratio,'+')
xlabel('Pressure (GPa)')
ylabel('Maxlum/Exposure Time (a.u.)')


%% Extract only the third component (most contrasted) and plot it

PlotAxis = 1;
PlotColorScale = 1;
Save = 0;
CalibDist = 0;
STDrescale = 5;

for K=1:N
    Cell_thirdsplitting{K} = Cell_FitTot{K}(:,:,11);
    if CalibDist == 1
        [Cell_x_axis{K}, Cell_y_axis{K}] = xyAxes_um(Cell_wcrop{K},Cell_hcrop{K},Cell_size_pix{K});
    else
        [Cell_x_axis{K}, Cell_y_axis{K}] = xyAxes(Cell_wcrop{K},Cell_hcrop{K});
    end    
%     Cell_FDmin{K} = mean(mean(Cell_thirdsplitting{K})) - STDrescale*std(std(Cell_thirdsplitting{K}));
%     Cell_FDmax{K} = mean(mean(Cell_thirdsplitting{K})) + STDrescale*std(std(Cell_thirdsplitting{K}));      
    Cell_FDmin{K} = mean(mean(Cell_thirdsplitting{K})) - 10;
    Cell_FDmax{K} = mean(mean(Cell_thirdsplitting{K})) + 20;  
end

figAllThirdSplitting = figure('Name','Splitting of third component','Position',[60,50,1420,850]);

for K = 1:N
    
    subplot(4,4,K);
    imagesc(Cell_x_axis{K},Cell_y_axis{K},Cell_thirdsplitting{K}(:,:)); 
    title(['P=' num2str(Pressure(K)) ' GPa']);
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    if PlotAxis == 1
        if CalibDist == 1
            xlabel('x (\mum)');
            ylabel('y (\mum)');
        else
            xlabel('x (pixels)');
            ylabel('y (pixels)');      
        end
    else
        ax.Visible = 'Off';
    end
    caxis([Cell_FDmin{K},Cell_FDmax{K}]);
    if PlotColorScale == 1
        c = colorbar;
        c.FontSize = 10.5;
    end
end

if Save ==1     
    nomSaveAllThirdSplitting = 'ThirdSplitting_Allpressureclean';
    saveas(figAllThirdSplitting,[DataPath nomSaveAllThirdSplitting '.jpg'],'jpeg'); 
    saveas(figAllThirdSplitting,[DataPath nomSaveAllThirdSplitting '.svg'],'svg');
end

%% Plot the middle frequency of a given family

PlotAxis = 1;
PlotColorScale = 1;
Save = 0;
CalibDist = 0;
STDrescale = 5;
i = 4;

for K=1:N
    Cell_middlefreq{K} = Cell_FitTot{K}(:,:,12+i);
    if CalibDist == 1
        [Cell_x_axis{K}, Cell_y_axis{K}] = xyAxes_um(Cell_wcrop{K},Cell_hcrop{K},Cell_size_pix{K});
    else
        [Cell_x_axis{K}, Cell_y_axis{K}] = xyAxes(Cell_wcrop{K},Cell_hcrop{K});
    end    
%     Cell_FDmin{K} = mean(mean(Cell_thirdsplitting{K})) - STDrescale*std(std(Cell_thirdsplitting{K}));
%     Cell_FDmax{K} = mean(mean(Cell_thirdsplitting{K})) + STDrescale*std(std(Cell_thirdsplitting{K}));      
    Cell_middlefreqmin{K} = mean(mean(Cell_middlefreq{K})) - 10;
    Cell_middlefreqmax{K} = mean(mean(Cell_middlefreq{K})) + 20;  
end

figAllMiddlefreq = figure('Name','Middle frequency of one family','Position',[60,50,1420,850]);

for K = 1:N
    
    subplot(4,4,K);
    imagesc(Cell_x_axis{K},Cell_y_axis{K},Cell_middlefreq{K}(:,:)); 
    title(['P=' num2str(Pressure(K)) ' GPa']);
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    if PlotAxis == 1
        if CalibDist == 1
            xlabel('x (\mum)');
            ylabel('y (\mum)');
        else
            xlabel('x (pixels)');
            ylabel('y (pixels)');      
        end
    else
        ax.Visible = 'Off';
    end
    caxis([Cell_middlefreqmin{K},Cell_middlefreqmax{K}]);
    if PlotColorScale == 1
        c = colorbar;
        c.FontSize = 10.5;
    end
end

if Save ==1     
    nomSaveAllMiddlefreq = ['Middlefreq_Allpressureclean-' num2str(i)];
    saveas(figAllMiddlefreq,[DataPath nomSaveAllMiddlefreq '.jpg'],'jpeg'); 
    saveas(figAllMiddlefreq,[DataPath nomSaveAllMiddlefreq '.svg'],'svg');
end

%% Remove the additional pressure caused by the splitting, and the ambient splitting
% Basé sur ExtractionChampLT, ou encore sur le chapitre 2 de la thèse LT

Save = 0;

Ref_Zone = [76 38 5]; % center pixel and halfwidth of the zone used as reference

PolyDegree = 1;
Exclude_Threshold = 5;

for K=1:N
    Splitting_ref(K)=squeeze(mean(mean(Cell_FitTot{K}(Ref_Zone(2)-Ref_Zone(3):Ref_Zone(2)+Ref_Zone(3),Ref_Zone(1)-Ref_Zone(3):Ref_Zone(1)+Ref_Zone(3),11))));
end

A=polyfit(Pressure(Exclude_Threshold:end),Splitting_ref(Exclude_Threshold:end).^2,PolyDegree); % fit du carré du splitting, l'ordonnée à l'origine A(end) est le carré du splitting dû à B0

Mx=sqrt(Splitting_ref(:).^2-A(end)); % c'est le splitting dû à la pression

for K=1:N    
    Splitting_withoutpressure{K}(:,:)=(sqrt(Cell_FitTot{K}(:,:,11).^2-Mx(K).^2));
    Splitting_mag{K}(:,:)=(sqrt(Cell_FitTot{K}(:,:,11).^2-Mx(K).^2)-sqrt(A(end)));
end

figExtractBfield = figure;
plot(Pressure,Splitting_ref.^2,'+')
hold on
% fplot(@(x) A(1)*x^2 + A(2)*x + A(3))
fplot(@(x) A(1)*x + A(2))
xlabel('Pressure (GPa)')
ylabel('Splitting^2 in a reference zone (MHz^2)')

if Save ==1     
    nomSaveExtractBfield = 'ExtractBfield';
    saveas(figExtractBfield,[DataPath nomSaveExtractBfield '.jpg'],'jpeg'); 
    saveas(figExtractBfield,[DataPath nomSaveExtractBfield '.svg'],'svg');
end

%% Plot cleaned up splitting

Save = 0;

for K=1:N
    Champ_Fer{K} = Splitting_mag{K}/56;
end

% figAllMagneticSplitting = figure('Name','Magnetic Splitting of third component','Position',[60,50,1420,850]);
% 
% for K = 1:N    
%     subplot(3,3,K);
%     imagesc(Cell_x_axis{K},Cell_y_axis{K},Splitting_mag{K}(:,:)); 
%     title(['P=' num2str(Pressure(K)) ' GPa']);
%     axis('image');
%     ax = gca;
%     ax.XAxisLocation = 'bottom';
%     ax.TickDir = 'out';
%     xlabel('x (pixels)');
%     ylabel('y (pixels)');     
%     caxis([-11,25]);
%     c = colorbar;
%     c.FontSize = 10.5;
% end


% figure('Name','Splitting without pressure','Position',[60,50,1420,850]);
% 
% for K = 1:N    
%     subplot(3,3,K);
%     imagesc(Cell_x_axis{K},Cell_y_axis{K},Splitting_withoutpressure{K}(:,:)); 
%     title(['P=' num2str(Pressure(K)) ' GPa']);
%     axis('image');
%     ax = gca;
%     ax.XAxisLocation = 'bottom';
%     ax.TickDir = 'out';
%     xlabel('x (pixels)');
%     ylabel('y (pixels)');     
% 	caxis([350,390]);
%     c = colorbar;
%     c.FontSize = 10.5;
% end

figAllMagneticField = figure('Name','Magnetic Splitting of third component','Position',[60,50,1420,850]);

for K = 1:N    
    subplot(3,3,K);
    imagesc(Cell_x_axis{K},Cell_y_axis{K},Champ_Fer{K}(:,:)); 
    title(['P=' num2str(Pressure(K)) ' GPa']);
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)');     
    caxis([-0.2,0.5]);
    c = colorbar;
    c.FontSize = 10.5;
end

% if Save ==1     
%     nomSaveAllMagneticSplitting = 'MagneticSplitting_Allpressure';
%     saveas(figAllMagneticSplitting,[DataPath nomSaveAllMagneticSplitting '.jpg'],'jpeg'); 
%     saveas(figAllMagneticSplitting,[DataPath nomSaveAllMagneticSplitting '.svg'],'svg');
% end

if Save ==1     
    nomSaveAllMagneticField = 'MagneticField_Allpressure';
    saveas(figAllMagneticField,[DataPath nomSaveAllMagneticField '.jpg'],'jpeg'); 
    saveas(figAllMagneticField,[DataPath nomSaveAllMagneticField '.svg'],'svg');
end

%% Extract a quantitative value of magnetic field around an area

Save = 0;

FirstArea = [90 90 3];
SecondArea = [36 74 3];


for K=1:N
    ThirdMag1(K) = mean(mean(Champ_Fer{K}(FirstArea(2)-FirstArea(3):FirstArea(2)+FirstArea(3),FirstArea(1)-FirstArea(3):FirstArea(1)+FirstArea(3))));
    ThirdMag2(K) = mean(mean(Champ_Fer{K}(SecondArea(2)-SecondArea(3):SecondArea(2)+SecondArea(3),SecondArea(1)-SecondArea(3):SecondArea(1)+SecondArea(3))));
end

figMagTransition = figure;
plot(Pressure(2:end),ThirdMag1(2:end),'+-')
hold on
plot(Pressure,ThirdMag2,'+-')
xlabel('Pressure X(GPa)')
ylabel('Magnetic field of third component (mT)')
legend('FirstArea','SecondArea')

if Save ==1     
    nomSaveMagTransition = 'MagneticTransition';
    saveas(figMagTransition,[DataPath nomSaveMagTransition '.jpg'],'jpeg'); 
    saveas(figMagTransition,[DataPath nomSaveMagTransition '.svg'],'svg');
end

%% Save all
% Don't forget to change the name if needed

saveAllName = 'FullResultsSoleil_2019-07-23';

save([DataPath saveAllName '.mat']);    




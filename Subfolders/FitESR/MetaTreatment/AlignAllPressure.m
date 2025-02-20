
clearvars; addpath('Functions FitESR');
% Execute sections of interest one after the other

%% Parameters

DataRawPath = 'D:\Documents\Boulot\Manips\Soleil\Data brutes ESR\';
freq_val = 5; % the frequency value at which the alignment is done

%% Choosing the raw files

[FileNames,PathName] = uigetfile('*.mat','Select the .mat files', 'MultiSelect','on',DataRawPath);
N = length(FileNames);

%% Load relevant data

for K=1:N
    load([PathName FileNames{K}],'M')
    [h,w,~] = size(M);
    Cell_M{K} = M;    
    Cell_w{K} = w;
    Cell_h{K} = h;
    clear('M','w','h');
end

%% Plot all luminescence images

figAllLum = figure('Name','Luminescence image of all files','Position',[60,50,1420,850]);

for K = 1:N    
    subplot(4,4,K);
    imagesc(Cell_M{K}(:,:,freq_val)); 
    title(FileNames{K});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)');  
    c = colorbar;
    c.FontSize = 10.5;
end

%% Choose reference image, center, width and height, and give approximate centers of subsequent images

K_Ref = 1;
Center_Ref = [149;108]; Approx_center{1} = Center_Ref;

Approx_center{2} = [135;80];Approx_center{3} = [129;105];Approx_center{4} = [143;150];Approx_center{5} = [138;104];
Approx_center{6} = [108;73];Approx_center{7} = [141;116];Approx_center{8} = [171;115];Approx_center{9} = [152;122];
Approx_center{10} = [148;120];Approx_center{11} = [147;113];Approx_center{12} = [148;129];Approx_center{13} = [148;123];
Approx_center{14} = [178;154];

width_out = 130; % must be even, for simplicity
height_out = 130; % must be even, for simplicity

%% Crop the images around approx center

for K = 1:N
    Cell_newymin{K} = Approx_center{K}(2)-height_out/2;
    Cell_newymax{K} = Approx_center{K}(2)+height_out/2;
    Cell_newxmin{K} = Approx_center{K}(1)-height_out/2;
    Cell_newxmax{K} = Approx_center{K}(1)+height_out/2;
    if Cell_newymin{K} > 0 && Cell_newymax{K} <= Cell_h{K} && Cell_newxmin{K} > 0 && Cell_newxmax{K} <= Cell_w{K}
        Cell_Image{K} = Cell_M{K}(Cell_newymin{K}:Cell_newymax{K},Cell_newxmin{K}:Cell_newxmax{K},freq_val);
    else
        disp(['K = ' num2str(K) ' : newymin = ' num2str(Cell_newymin{K}) ', newxmin = ' num2str(Cell_newxmin{K})...
            ', newymax = ' num2str(Cell_newymax{K}) '/' num2str(Cell_h{K}) ', newxmax = ' num2str(Cell_newxmax{K})...
            '/' num2str(Cell_w{K})]);
    end
end

%% Realign around maximum

Max_Misalign = 15; % The maximum misalignment possible, in pixels
Size_Around_Max = 15;

clear Cell_Diff

[rowmax,rowmaxpos] = max(Cell_Image{1});
[columnmax,columnmaxpos] = max(rowmax);
imax = columnmaxpos;
jmax = rowmaxpos(columnmaxpos);

for K = 1:length(FileNames)-1
    for ishift = -Max_Misalign:Max_Misalign
        for jshift = -Max_Misalign:Max_Misalign
            Mat1 = Cell_Image{1}(jmax-Size_Around_Max:jmax+Size_Around_Max,imax-Size_Around_Max:imax+Size_Around_Max);
            Mat2 = Cell_Image{K+1}(jmax-Size_Around_Max+jshift:jmax+Size_Around_Max+jshift,imax-Size_Around_Max+ishift:imax+Size_Around_Max+ishift);
            Cell_Diff{K}(jshift+Max_Misalign+1,ishift+Max_Misalign+1) = sum(sum(abs(Mat1-Mat2)));
        end
    end
end

for K = 1:length(FileNames)
    if K == 1
        ishift_opt(K) = 0;
        jshift_opt(K) = 0;
        Cell_Cropping_Coord{K} = [1,Cell_newxmin{K},Cell_newymin{K},Cell_newxmax{K},Cell_newymax{K}];
    else
        [rowmin,rowpos] = min(Cell_Diff{K-1});
        [columnmin,columnpos] = min(rowmin);
        ishift_opt(K) = columnpos-Max_Misalign-1;
        jshift_opt(K) = rowpos(columnpos)-Max_Misalign-1;
        disp(['optimal ishift = ' num2str(ishift_opt(K)) ' pixels']);
        disp(['optimal jshift = ' num2str(jshift_opt(K)) ' pixels']);
        
        Cell_Cropping_Coord{K} = [1,max(1,Cell_newxmin{K}+ishift_opt(K)),max(1,Cell_newymin{K}+jshift_opt(K)),...
            min(Cell_newxmax{K}+ishift_opt(K),Cell_w{K}),min(Cell_newymax{K}+jshift_opt(K),Cell_h{K})];
        if Cell_Cropping_Coord{K}(2) == 1 || Cell_Cropping_Coord{K}(3) == 1 || Cell_Cropping_Coord{K}(4) == Cell_w{K} || Cell_Cropping_Coord{K}(5) == Cell_h{K}
            disp(['K = ' num2str(K) ' : limited by image boundaries, resulting image smaller']);
        end
    end
end

%% Create new shifted images and plot them

for K=1:N
    Cell_NewImage{K} = Cell_M{K}(Cell_Cropping_Coord{K}(3):Cell_Cropping_Coord{K}(5),Cell_Cropping_Coord{K}(2):Cell_Cropping_Coord{K}(4),freq_val);
end

figAllLum = figure('Name','New luminescence image of all files','Position',[60,50,1420,850]);

for K = 1:N    
    subplot(4,4,K);
    imagesc(Cell_NewImage{K}(:,:)); 
    title(FileNames{K});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)');  
    c = colorbar;
    c.FontSize = 10.5;
end

%% Adjust manually
close(figLum);close(figLum2);

Cell_Cropping_Coord{1} = [1 84 43 214 173];
Cell_Cropping_Coord{2} = [1 70 15 200 145];
Cell_Cropping_Coord{3} = [1 66 40 196 170];
Cell_Cropping_Coord{4} = [1 74 82 204 212];
Cell_Cropping_Coord{5} = [1 67 34 197 164];
Cell_Cropping_Coord{6} = [1 43 8 173 138];
Cell_Cropping_Coord{7} = [1 74 47 204 177];
Cell_Cropping_Coord{8} = [1 97 44 227 174];
Cell_Cropping_Coord{9} = [1 82 56 212 186];
Cell_Cropping_Coord{10} = [1 78 51 208 181];
Cell_Cropping_Coord{11} = [1 82 48 212 178];
Cell_Cropping_Coord{12} = [1 77 58 207 188];
Cell_Cropping_Coord{13} = [1 78 55 208 185];
Cell_Cropping_Coord{14} = [1 98 77 228 207];
K = 14;

figLum = figure('Name','New luminescence image of one file','Position',[60,50,1420,850]);
imagesc(Cell_NewImage{1}(:,:)); 
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel('x (pixels)');
ylabel('y (pixels)');  
c = colorbar;
c.FontSize = 10.5;

figLum2 = figure('Name','New luminescence image of one file','Position',[60,50,1420,850]);
imagesc(Cell_M{K}(Cell_Cropping_Coord{K}(3):Cell_Cropping_Coord{K}(5),Cell_Cropping_Coord{K}(2):Cell_Cropping_Coord{K}(4),freq_val)); 
axis('image');
ax = gca;
ax.XAxisLocation = 'bottom';
ax.TickDir = 'out';
xlabel('x (pixels)');
ylabel('y (pixels)');  
c = colorbar;
c.FontSize = 10.5;

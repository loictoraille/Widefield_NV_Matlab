clearvars
close all
%% Parameters

DataPath = 'D:\Documents\Boulot\Manips\Soleil\Data brutes ESR\';
Max_Misalign = 15; % The maximum misalignment possible, in pixels
freq_val = 5; % the frequency value at which the alignment is done
Size_Around_Max = 15;
Manual_Crop = 0;
Manual_Frequency = 1;

%% Choose and load

[FileNames,PathName] = uigetfile('*.mat','Load file','MultiSelect','on',DataPath);

for K = 1 : length(FileNames)
    Cell_fname{K} = FileNames{K};
    load([PathName Cell_fname{K}],'M','Ftot','Acc','ExposureTime','FrameRate','MWPower','PixelClock');
    Cell_M{K} = M;
    Cell_Ftot{K} = Ftot;
    Cell_Acc{K} = Acc;
    Cell_ExposureTime{K} = ExposureTime;
    Cell_FrameRate{K} = FrameRate;
    Cell_MWPower{K} = MWPower;
    Cell_PixelClock{K} = PixelClock;
    [h,w,~] = size(M);
    Cell_h{K} = h;
    Cell_w{K} = w;
    clear('M','Acc','h','w')    
end

%% Manually crop
if Manual_Crop == 1

    jcenter = 158;
    icenter = 108;

    wout = 200;
    hout = 220;

    clear Mcrop
    Mcrop = Cell_M{1}(jcenter - hout/2:jcenter + hout/2-1,icenter - wout/2:icenter + wout/2-1,:);
    Cell_M{1} = Mcrop;

end

%% Manually adjust frequencies
if Manual_Frequency == 1
%     newM2 = (Cell_M{2}(:,:,1:end-1)+Cell_M{2}(:,:,2:end))/2;
%     newFtot2 = (Cell_Ftot{2}(1:end-1)+Cell_Ftot{2}(2:end))/2;
    
    newM1 = (Cell_M{1}(:,:,1:end-1)+Cell_M{1}(:,:,2:end))/2;
    newFtot1 = (Cell_Ftot{1}(1:end-1)+Cell_Ftot{1}(2:end))/2;
    
    M1_2223 = newM1;
    M2_2223 = Cell_M{2}(:,:,39:387);
    Cell_M{1} = M1_2223;
    Cell_M{2} = M2_2223;
    clear Ftot
    Ftot = Cell_Ftot{2}(39:387);

%     M2_2123 = Cell_M{2}(:,:,51:end);
%     Cell_M{2} = M2_2123;
%     clear Ftot
%     Ftot = Cell_Ftot{2}(51:end);

%     M1_M123 = Cell_M{1}(:,:,1:337);
%     M2_M123 = newM2(:,:,13:349);
%     M3_M123 = Cell_M{3}(:,:,51:387);
%     Cell_M{1} = M1_M123;
%     Cell_M{2} = M2_M123;
%     Cell_M{3} = M3_M123;
%     clear Ftot
%     Ftot = Cell_Ftot{3}(51:387);
end
%% Plot luminescence images

for K = 1:length(FileNames)
    fig = figure('Name','Comparison of luminescence images','Position',[500,100,500,625]);
    imagesc(squeeze(Cell_M{K}(:,:,freq_val)));  
    title({'Photoluminescence (a.u.)' ; ''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)');  
    c = colorbar;
    c.FontSize = 10.5; 
end
    
%% Realign around maximum

clear Cell_Diff

[rowmax,rowmaxpos] = max(Cell_M{1}(:,:,freq_val));
[columnmax,columnmaxpos] = max(rowmax);
imax = columnmaxpos;
jmax = rowmaxpos(columnmaxpos);

for K = 1:length(FileNames)-1
    for ishift = -Max_Misalign:Max_Misalign
        for jshift = -Max_Misalign:Max_Misalign
            Mat1 = Cell_M{1}(jmax-Size_Around_Max:jmax+Size_Around_Max,imax-Size_Around_Max:imax+Size_Around_Max,freq_val);
            Mat2 = Cell_M{K+1}(jmax-Size_Around_Max+jshift:jmax+Size_Around_Max+jshift,imax-Size_Around_Max+ishift:imax+Size_Around_Max+ishift,freq_val);
            Cell_Diff{K}(jshift+Max_Misalign+1,ishift+Max_Misalign+1) = sum(sum(abs(Mat1-Mat2)));
        end
    end
end

for K = 1:length(FileNames)
    if K == 1
        ishift_opt(K) = 0;
        jshift_opt(K) = 0;
    else
        [rowmin,rowpos] = min(Cell_Diff{K-1});
        [columnmin,columnpos] = min(rowmin);
        ishift_opt(K) = columnpos-Max_Misalign-1;
        jshift_opt(K) = rowpos(columnpos)-Max_Misalign-1;
        disp(['optimal ishift = ' num2str(ishift_opt(K)) ' pixels']);
        disp(['optimal jshift = ' num2str(jshift_opt(K)) ' pixels']);
    end
end

%% Create new M

min_jshift = min(jshift_opt); max_jshift = max(jshift_opt);
min_ishift = min(ishift_opt); max_ishift = max(ishift_opt);

for K = 1:length(FileNames)
    [h,w,v] = size(Cell_M{K});
    NewM = Cell_M{K}(max(1,1+max_jshift):min(h,h+min_jshift),max(1,1+max_ishift):min(w,w+min_ishift),1:v)*0;    
    [newh,neww,~] = size(NewM);
    Cell_NewM{K} = Cell_M{K}(1+jshift_opt(K)-min_jshift:newh+jshift_opt(K)-min_jshift,1+ishift_opt(K)-min_ishift:neww+ishift_opt(K)-min_ishift,:);
end

%% RePlot luminescence images

for K = 1:length(FileNames)
    fig = figure('Name','Comparison of luminescence images','Position',[500,100,500,625]);
    imagesc(squeeze(Cell_NewM{K}(:,:,freq_val)));  
    title({'Photoluminescence (a.u.)' ; ''});
    axis('image');
    ax = gca;
    ax.XAxisLocation = 'bottom';
    ax.TickDir = 'out';
    xlabel('x (pixels)');
    ylabel('y (pixels)');  
    c = colorbar;
    c.FontSize = 10.5; 
end

%% Create new file

FusedM = Cell_NewM{1}*0;
for K = 1:length(FileNames)
    FusedM = FusedM + Cell_NewM{K}/length(FileNames);
    name_number = findstr(Cell_fname{K},'WideField');
    if K == 1
        FusedName = [Cell_fname{K}(1:end-4)];
    else
        FusedName = [FusedName '+' Cell_fname{K}(name_number+10:end-4)];
    end
end

M = FusedM;
Acc = Cell_Acc{1} + Cell_Acc{2};
[h,w,v] = size(FusedM);

FusedName

save([PathName FusedName '.mat'],'M','Ftot','Acc','ExposureTime','FrameRate','MWPower','PixelClock','h','w');


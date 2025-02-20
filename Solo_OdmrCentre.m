clear
%%  Choose file

load("C:\Users\ADM_TORAILLEL\Documents\Loïc 11-02-22\Manips\NV\Stage Boubacar\ODMR_180mW.mat");

%% Parameters

Size_Mask = 10;
Dist_Between= 1;

%% Initialize

if ~exist('ESRMatrix','var')
    ESRMatrix = M;
    clear M;
end

if ~exist('v_MHz','var')
    v_MHz = Ftot;
    clear Ftot;
end

[sizeX sizeY sizeF] = size(ESRMatrix);
matMiddleFreq = zeros([sizeX sizeY]);

%% Analyze

tic();
for x = 1:sizeX
    for y = 1:sizeY
        matMiddleFreq(x,y) = OdmrCentreV2(v_MHz,ESRMatrix(x,y,:));
    end
end
toc();

%% Plot

figure;
imagesc(matMiddleFreq,[2.859 2.869]);
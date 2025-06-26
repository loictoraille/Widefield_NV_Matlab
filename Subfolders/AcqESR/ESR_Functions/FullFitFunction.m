function FullFitFunction(hobject,~)
global M Ftot

panel=guidata(gcbo);

load([getPath('Param') 'FitParameters.mat'],'FitParameters');
ReadFitParameters;

if Smoothing_Factor ~= 0
    FitParameters.SMOOTH = 0; % to prevent double smoothing down the line
    save([getPath('Param') 'FitParameters.mat'],'FitParameters');
end

ESRMatrix = M;
v_MHz = Ftot*1000;
           
hobject=guidata(gcbo);
[h,w,~] = size(M);

Crop = hobject.Crop.Value;
x1 = max(1,str2num(hobject.X1.String));
y1 = max(1,str2num(hobject.Y1.String));
x2 = min(w,str2num(hobject.X2.String));
y2 = min(h,str2num(hobject.Y2.String));

Cropping_Coord = [Crop x1 y1 x2 y2];% First number is on or off, then it's either center + size of square (3 numbers),
% or two opposite corners (4 numbers). The numbers are written in the same order as in the plotESRImgXY representation.

[x_start, y_start, x_stoptoend, y_stoptoend, wcrop, hcrop] = Cropping(w,h,Cropping_Coord);
[x_um, y_um] = xyAxes_um(wcrop,hcrop,size_pix); % they are defined here to add them to the saved file

if AutoBase == 1
    FitMethod = 5;
end

%% Fit
commandwindow;
                
[FitTot, BinMap] = FitCimg(ESRMatrix, v_MHz,  Cropping_Coord, FitParameters);

%% Reconstruct and plot
load([getPath('Param') 'FileInfo.mat']);

SaveName = CreateSaveName(NumComp,Cropping_Coord,BinThr,VarWidths,Smoothing_Factor,Detrending_Factor,ClearFFT,TrackingFit,fname,FitMethod,RemPositive);
B = fittofield(FitTot, NumComp, NumCompFittofield, FitMethod);
[B,~] = DefineCorrectPermutation(B,CorrectPermutation); 
[B_renorm, B0(:,:,1), B0(:,:,2), B0(:,:,3)] = Renormalize(Renormalize_Parameters, B);
PlotScale = PlotParameters(FitTot, B_renorm, ColorRescale, StdforRescalingTeslas, NumComp);

figField = plotField(FitTot, B_renorm, B0, PlotScale, fname, Cropping_Coord, ESRMatrix, size_pix, NumComp, Calib_Dist, FitMethod, SaveName);

%% Save

if exist(TreatedDataPath,'dir') == 0
    mkdir(TreatedDataPath);
end

pStart = LoadPStart([getPath('Param') 'PstartFitBin'],NumComp, VarWidths, IsPair);% to add it in the saved file

SaveName = CreateSaveName(NumComp,Cropping_Coord,BinThr,VarWidths,Smoothing_Factor,Detrending_Factor,ClearFFT,TrackingFit,fname,FitMethod,RemPositive);
save([TreatedDataPath SaveName],'-regexp','^(?!(M|Ftot)$).');% saving except M and Ftot

[~,num_figs] = size(figField);
if num_figs > 1
    for i=1:num_figs
        saveas(figField{i},[TreatedDataPath SaveName(1:end-4) '-FitResults_' num2str(i) '.jpg'],'jpeg');
    end
else
    if FitMethod == 7 || FitMethod == 8
        suffix = 'Middle Frequency Map';
    else
        suffix = 'Magnetic Field Map';
    end
    saveas(figField,[TreatedDataPath SaveName(1:end-4) '-' suffix '.jpg'],'jpeg');
end

if FitParameters.VisuFit
    VisuFitScript;
end

end
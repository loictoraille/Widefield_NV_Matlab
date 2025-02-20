function SaveName = CreateSaveName(NumComp,Cropping_Coord,BinThr,VarWidths,Smoothing_Factor,Detrending_Factor,ClearFFT,TrackingFit,fname,FitMethod,RemPositive)
    
%% NumComp

if NumComp == 1
    numcompname = ['-1comp'];
elseif NumComp == 0.5
    numcompname = ['singlepeak'];
else
    numcompname = '';
end


%% Smoothing

if Smoothing_Factor ~= 0
    smname = ['-Smooth' num2str(Smoothing_Factor)];
else
    smname = '';
end

%% Detrending

if Detrending_Factor ~= 0
    dtname = ['-Detrend' num2str(Detrending_Factor)];
else
    dtname = '';
end      

%% Cropping

if Cropping_Coord(1) == 1
    crname = '-Cropped';
else
    crname = '';
end

%% Type of tracking fit

if TrackingFit ~= 0
    fitname = ['-Tracking' num2str(TrackingFit)];
else
    fitname = '';
end

%% Error correction 

if exist('ErrorCorrection','var') && ErrorCorrection ~= 0 
    corrname = '-Corrected';
else
    corrname = '';
end

%% Binning

if BinThr ~= 0
    binningname = ['-Binning' num2str(BinThr)];
else
    binningname = '';
end

%% ClearFFT

if  ClearFFT{1} ~= 0
    clearFFTname = ['-ClearFFT'];
else
    clearFFTname = '';
end

%% All widths variable or all the same

if  VarWidths == 0
    VarWidthsname = ['-NoVarWidths'];
else
    VarWidthsname = '';
end

%% Fit Method

fitMethodname = ['-fitMethod' num2str(FitMethod)];

%% Remove Positive

if RemPositive == 1
   RemPositivename = '-RemovePositive';
else
   RemPositivename = '';
end    


%% Remove '.mat' part if it exists

if strcmp(fname(end-3:end),'.mat') == 1
    filename = fname(1:end-4);
else
    filename = fname;
end

%% Summing up

SaveName = [filename '-Fit' numcompname crname fitname smname dtname corrname  binningname clearFFTname VarWidthsname fitMethodname RemPositivename '.mat'];


% OUTDATED, use FitParameters.mat instead

size_pix = 0.463; % µm  
%% Fit Parameters
% numPeaks = 4; % si numPeaks est fixé, prend les pics ayant la plus forte intensité, si 0, utilise la valeur seuil > attention pour ESR il vaut mieux donner le nombre
% numPeaks is now an option from interface, can be overwritten with AutoFitParamets if necessary
smooth_order = 3; % degré du polynôme de lissage pour le findpeaks
smooth_window = 11; % taille (en indices) de la fenêtre de fréquence utilisée pour le lissage
minDistBetweenPeaks = 1; % en MHz, c'est la distance minimum entre deux pics trouvés par le findpeaks
height_threshold = 0.1; % selection des pics avec un seuil défini comme une fraction du maximum, ne fonctionne pas si bruit ou pics doubles
type_function = 'lor'; % voigt ou lor (coder autres si nécessaire), attention le résultat obtenu pour le contraste n'est pas bon, il faudrait se pencher mathématiquement dessus
WidthMinToKeep = 50; % en MHz, c'est la longueur utilisée par la baseline auto, pour ne pas exclure les pics larges (tout en excluant quand même les formes très larges)
% ATTENTION les valeurs de contraste peuvent être faussées si la baseline retire une partie
% de l'intensité des pics, à surveiller si on est intéressés par les contrastes
SMOOTH = 0; % lisse le spectre avant le fit, utilise les paramètres de lissage du findpeaks
%% Graphic Parameters
WithPreset = 1; % to plot the fit preset or not

%% FullFit Parameters
Smoothing_Factor = 0; % binning on the frequency values for a given ESR spectrum, can help in case of noise
Detrending_Factor = 0; % removing a general trend in the ESR, the number is the degree of the polynome used
ClearFFT = {0,22,'max'}; % frequency filter in the fourier transform, adapt the freqs (see ClearingFFT) depending on data
RemPositive = 0; % to remove positive peaks that can occur when it is very noisy
VarWidths = 1; % authorizes or not a variable width for each ESR peak, most often 1, can be useful as 0 in cases where
% imposing a general width helps to locate a noisy component

TrackingFit = 0; % type of tracking used for the full fit (see FitCimg)

FitMethod = 5;  %1 TWO Lorentzians per ESR peak spaced by 3MHz (N15 hyperfine Interaction)
                %2 Not Implemented yet, ONE Lorentzian per ESR peak (no hyperfine interaction)
                %3 Not Implemented yet, THREE Lorentzians per ESR peak spaced by 2MHz(N14 hyperfine Interqction)
                %4 Polynomial Fit                 
                %5 New fit method ; only one which uses the automatic baseline removing script. Beware, can take more time.               

%% Construct Bfield parameters
CorrectPermutation = [-2,1,3]; % Use [B,Perm] = DefineCorrectPermutation(B); to define the CorrectPermutation
Renormalize_Parameters = [0,5,42,45]; % first number = renormalize mode, second = side of square for renorm, then 
% (optional) is the center pixel coordinates used in renorm mode 1
ColorRescale = 1; % to modify the colorscale, 0 is natural min max, 1 is mean +- StdforRescalingTeslas*Standard Deviation
StdforRescalingTeslas = 5;
Calib_Dist = 0; % 1 is to plot in µm, 0 to plot in pixels
%%Elements of Tab2 (Open_ESR Fit Parameters) 
load([getPath('Param') 'FitParameters.mat'],'FitParameters');
%% Paths

uicontrol('Parent',tab_fitparam,'Style','text','units','normalized','FontSize',16,'HorizontalAlignment','left','FontWeight','bold','Position',[0.01 0.92 0.1 0.04],'String','DataPath');
uicontrol('Parent',tab_fitparam,'Style','text','tag','DataPath','units','normalized','FontSize',16,'HorizontalAlignment','left','FontWeight','bold','BackgroundColor',[.8 .8 .8],'Position',[0.1 0.91 0.5 0.06],'String',FitParameters.DataPath);
uicontrol('Parent',tab_fitparam,'Style','text','units','normalized','FontSize',16,'HorizontalAlignment','left','FontWeight','bold','Position',[0.01 0.85 0.1 0.04],'String','TreatedDataPath');
uicontrol('Parent',tab_fitparam,'Style','text','tag','TreatedDataPath','units','normalized','FontSize',16,'HorizontalAlignment','left','FontWeight','bold','BackgroundColor',[.8 .8 .8],'Position',[0.1 0.84 0.5 0.06],'String',[FitParameters.TreatedDataPath]);
uicontrol('Parent',tab_fitparam,'Style','pushbutton','tag','ChangeTreatedDataPath','units','normalized','FontSize',16,'Position',[0.606 0.845 0.05 0.03],'String','Change','Tooltip','To change the end folder ; it will create a Fit_Results subfolder inside the selected folder','Callback',@ChangeTreatedDataPath);
uicontrol('Parent',tab_fitparam,'Style','checkbox','tag','TreatedPathAutoChange','FontSize',12,'units','normalized','Position',[0.6 0.875 0.1 0.03],'Value',FitParameters.TreatedPathAutoChange,'String','Auto Change','Tooltip','Desactivate to prevent auto updating of the treated path when changing the data set','Callback',@SwitchAutoPath);


%% Auto Find Peaks

afp_panel = uipanel('Parent',tab_fitparam,'Title','Auto Find Peaks Parameters','FontSize',14,'Position',[0.1 0.05 0.15 0.23]);

uicontrol('Parent',afp_panel,'Style','edit','tag','smooth_order','FontSize',12,'units','normalized','Position',[0.05 0.85 0.2 0.1],'String',num2str(FitParameters.smooth_order),'Tooltip','degré du polynôme de lissage pour le findpeaks','Callback',@UpdateFit);
uicontrol('Parent',afp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.85 0.6 0.1],'String','smooth order');

uicontrol('Parent',afp_panel,'Style','edit','tag','smooth_window','FontSize',12,'units','normalized','Position',[0.05 0.65 0.2 0.1],'String',num2str(FitParameters.smooth_window),'Tooltip','taille (en indices) de la fenêtre de fréquence utilisée pour le lissage','Callback',@UpdateFit);
uicontrol('Parent',afp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.65 0.6 0.1],'String','smooth_window');

uicontrol('Parent',afp_panel,'Style','edit','tag','minDistBetweenPeaks','FontSize',12,'units','normalized','Position',[0.05 0.45 0.2 0.1],'String',num2str(FitParameters.minDistBetweenPeaks),'Tooltip','en MHz, distance minimum entre deux pics trouvés par le findpeaks','Callback',@UpdateFit);
uicontrol('Parent',afp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.45 0.6 0.1],'String','minDistBetweenPeaks');

uicontrol('Parent',afp_panel,'Style','edit','tag','height_threshold','FontSize',12,'units','normalized','Position',[0.05 0.25 0.2 0.1],'String',num2str(FitParameters.height_threshold),'Tooltip','selection des pics avec un seuil défini comme une fraction du maximum, ne fonctionne pas si bruit ou pics doubles','Callback',@UpdateFit);
uicontrol('Parent',afp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.25 0.6 0.1],'String','height_threshold');

% deprecated, new baseline method
% uicontrol('Parent',afp_panel,'Style','edit','tag','WidthMinToKeep','FontSize',12,'units','normalized','Position',[0.05 0.05 0.2 0.1],'String',num2str(FitParameters.WidthMinToKeep),'Tooltip','en MHz, longueur utilisée par la baseline auto, pour ne pas exclure les pics larges (tout en excluant quand même les formes très larges)','Callback',@UpdateFit);
% uicontrol('Parent',afp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.05 0.6 0.1],'String','WidthMinToKeep');

%% Graphic Parameters

gp_panel = uipanel('Parent',tab_fitparam,'Title','Graphic Parameters','FontSize',14,'Position',[0.1 0.7 0.1 0.05]);

uicontrol('Parent',gp_panel,'Style','checkbox','tag','WithPreset','FontSize',12,'units','normalized','Position',[0.05 0.05 1 0.85],'Value',FitParameters.WithPreset,'String','WithPreset','Tooltip','to plot the fit preset (pStart) or not','Callback',@UpdateFit);

%% Single Fit Parameters

sfp_panel = uipanel('Parent',tab_fitparam,'Title','Single Fit Parameters','FontSize',14,'Position',[0.1 0.35 0.15 0.15]);

uicontrol('Parent',sfp_panel,'Style','edit','tag','type_function','FontSize',12,'units','normalized','Position',[0.05 0.65 0.2 0.2],'String',FitParameters.type_function,'Tooltip',['voigt ou lor (coder autres si nécessaire), attention le résultat obtenu pour le ' 10 'contraste n''est pas bon, il faudrait se pencher mathématiquement dessus'],'Callback',@UpdateFit);
uicontrol('Parent',sfp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.65 0.6 0.2],'String','type_function');

uicontrol('Parent',sfp_panel,'Style','edit','tag','Smoothing_Factor','FontSize',12,'units','normalized','Position',[0.05 0.15 0.2 0.2],'String',num2str(FitParameters.Smoothing_Factor),'Tooltip',['binning on the frequency values for a given ESR spectrum, can help in case of noise' 10 'Single fit: smooth will use the parameters of auto find peaks' 10 'FullFit: input value N, smooth will bin on the first n frequencies'],'Callback',@UpdateFit);
uicontrol('Parent',sfp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.15 0.6 0.2],'String','Smoothing_Factor');

%% FullFit Parameters

ffp_panel = uipanel('Parent',tab_fitparam,'Title','Full Fit Parameters','FontSize',14,'Position',[0.1 0.53 0.2 0.15]);

% methods 1 and 4 are currently not implemented in the graphical interface
% uicontrol('Parent',ffp_panel,'Style','edit','tag','FitMethod','FontSize',12,'units','normalized','Position',[0.04 0.80 0.15 0.2],'String',num2str(FitParameters.FitMethod),'Tooltip',['1 = TWO Lorentzians per ESR peak spaced by 3MHz (N15 hyperfine Interaction)' 10 '4 = Polynomial Fit' 10 '5 = New fit method with possible baseline removal, single lorentzian per peak' 10 '7 = Fast barycenter method that only looks for the middle frequency' 10 '8 = Fast correlation method that only looks for the middle frequency (better than barycenter)'],'Callback',@UpdateFit);
uicontrol('Parent',ffp_panel,'Style','edit','tag','FitMethod','FontSize',12,'units','normalized','Position',[0.04 0.80 0.15 0.2],'String',num2str(FitParameters.FitMethod),'Tooltip',['5 = New fit method with possible baseline removal, single lorentzian per peak' 10 '7 = Fast barycenter method that only looks for the middle frequency' 10 '8 = Fast correlation method that only looks for the middle frequency (better than barycenter)'],'Callback',@UpdateFit);
uicontrol('Parent',ffp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.25 0.80 0.3 0.2],'String','FitMethod');

uicontrol('Parent',ffp_panel,'Style','edit','tag','TrackingFit','FontSize',12,'units','normalized','Position',[0.04 0.55 0.15 0.2],'String',num2str(FitParameters.TrackingFit),'Tooltip',['1 = fit using a mean of pStart and 1 vertical previous value' 10 '2 = fit using vertical previous values as starting parameters' 10 '3 = fit using vertical previous values as starting parameters, starting from the bottom' 10 '4 = fit using vertical previous values as starting parameters, starting from both ends'],'Callback',@UpdateFit);
uicontrol('Parent',ffp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.25 0.55 0.3 0.2],'String','TrackingFit');

uicontrol('Parent',ffp_panel,'Style','edit','tag','Detrending_Factor','FontSize',12,'units','normalized','Position',[0.04 0.3 0.15 0.2],'String',num2str(FitParameters.Detrending_Factor),'Tooltip','removing a general trend in the ESR, the number is the degree of the polynome used','Callback',@UpdateFit);
uicontrol('Parent',ffp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.25 0.3 0.3 0.2],'String','Detrending_Factor');

uicontrol('Parent',ffp_panel,'Style','edit','tag','ClearFFT','FontSize',12,'units','normalized','Position',[0.04 0.05 0.15 0.2],'String',strjoin(string(FitParameters.ClearFFT)),'Tooltip','frequency filter in the fourier transform, adapt the freqs (see ClearingFFT) depending on data','Callback',@UpdateFit);
uicontrol('Parent',ffp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.25 0.05 0.3 0.2],'String','ClearFFT');

uicontrol('Parent',ffp_panel,'Style','checkbox','tag','VarWidths','FontSize',12,'units','normalized','Position',[0.65 0.80 0.3 0.2],'Value',FitParameters.VarWidths,'String','VarWidths','Tooltip','authorizes or not a variable width for each ESR peak, most often 1, can be useful as 0 in cases where imposing a general width helps to locate a noisy component','Callback',@UpdateFit);

uicontrol('Parent',ffp_panel,'Style','checkbox','tag','RemPositive','FontSize',12,'units','normalized','Position',[0.65 0.55 0.3 0.2],'Value',FitParameters.RemPositive,'String','RemPositive','Tooltip','to remove positive peaks that can occur when it is very noisy','Callback',@UpdateFit);

%% Construct Bfield Parameters

cbp_panel = uipanel('Parent',tab_fitparam,'Title','Construct Bfield Parameters','FontSize',14,'Position',[0.35 0.15 0.3 0.2]);

uicontrol('Parent',cbp_panel,'Style','edit','tag','NumCompFittofield','FontSize',12,'units','normalized','Position',[0.04 0.80 0.2 0.2],'String',num2str(FitParameters.NumCompFittofield),'Tooltip',['number of components used to reconstruct the magnetic field' 10 'for 8 peaks: 4 is better, 3 if one is noisy'],'Callback',@UpdateFit);
uicontrol('Parent',cbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.80 0.35 0.2],'String','NumCompFittofield');

uicontrol('Parent',cbp_panel,'Style','edit','tag','CorrectPermutation','FontSize',12,'units','normalized','Position',[0.04 0.55 0.2 0.2],'String',strjoin(string(FitParameters.CorrectPermutation)),'Tooltip','To define the B1, B2, B3 permutation','Callback',@UpdateFit);
uicontrol('Parent',cbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.55 0.35 0.2],'String','CorrectPermutation');

uicontrol('Parent',cbp_panel,'Style','edit','tag','Renormalize_Parameters','FontSize',12,'units','normalized','Position',[0.04 0.3 0.2 0.2],'String',strjoin(string(FitParameters.Renormalize_Parameters)),'Tooltip',['first number = renormalize mode' 10 'second number = side of square for renorm' 10 '(optional) third and fourth define the center pixel coordinates used in renorm mode 1'],'Callback',@UpdateFit);
uicontrol('Parent',cbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.3 0.35 0.2],'String','Renormalize_Parameters');

uicontrol('Parent',cbp_panel,'Style','edit','tag','StdforRescalingTeslas','FontSize',12,'units','normalized','Position',[0.04 0.05 0.2 0.2],'String',num2str(FitParameters.StdforRescalingTeslas),'Tooltip','Value used to automatically define the color scale when active','Callback',@UpdateFit);
uicontrol('Parent',cbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.3 0.05 0.35 0.2],'String','StdforRescalingTeslas');

uicontrol('Parent',cbp_panel,'Style','checkbox','tag','ColorRescale','FontSize',12,'units','normalized','Position',[0.75 0.05 0.3 0.2],'Value',FitParameters.ColorRescale,'String','ColorRescale','Tooltip',['0 is natural min max' 10 '1 is mean+- StdforRescalingTeslas*Standard Deviation (with adjustments for certain parameters)'],'Callback',@UpdateFit);

%% Fit Boundaries Parameters

fbp_panel = uipanel('Parent',tab_fitparam,'Title','Fit Boundaries Parameters','FontSize',14,'Position',[0.35 0.45 0.2 0.25]);

uicontrol('Parent',fbp_panel,'Style','checkbox','tag','LowerBound','FontSize',14,'FontWeight','bold','units','normalized','Position',[0.1 0.80 0.3 0.1],'Value',FitParameters.LowerBound,'String','Lower Bound','Tooltip','Usually better to check it','Callback',@UpdateFit);

uicontrol('Parent',fbp_panel,'Style','edit','tag','cmin','FontSize',12,'units','normalized','Position',[0.02 0.65 0.15 0.1],'String',FitParameters.cmin,'Tooltip','in percent','Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.18 0.65 0.25 0.1],'String','Contrast Min');

uicontrol('Parent',fbp_panel,'Style','edit','tag','fmmin','FontSize',12,'units','normalized','Position',[0.02 0.5 0.15 0.1],'String',FitParameters.fmmin,'Tooltip',['smart = based on microwave range used' 10 'input value otherwise'],'Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.18 0.50 0.25 0.1],'String','Middle Freq Min');

uicontrol('Parent',fbp_panel,'Style','edit','tag','fdmin','FontSize',12,'units','normalized','Position',[0.02 0.35 0.15 0.1],'String',FitParameters.fdmin,'Tooltip',['smart = based on microwave sampling used' 10 'input value otherwise'],'Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.18 0.35 0.25 0.1],'String','Splitting Min');

uicontrol('Parent',fbp_panel,'Style','edit','tag','fwmin','FontSize',12,'units','normalized','Position',[0.02 0.2 0.15 0.1],'String',FitParameters.fwmin,'Tooltip','in MHz','Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.18 0.20 0.25 0.1],'String','Width Min');

uicontrol('Parent',fbp_panel,'Style','edit','tag','y0min','FontSize',12,'units','normalized','Position',[0.02 0.05 0.15 0.1],'String',FitParameters.y0min,'Tooltip',['factor applied to min of edges baseline'],'Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.18 0.05 0.25 0.1],'String','Baseline Min');


uicontrol('Parent',fbp_panel,'Style','checkbox','tag','UpperBound','FontSize',14,'FontWeight','bold','units','normalized','Position',[0.6 0.80 0.3 0.1],'Value',FitParameters.UpperBound,'String','Upper Bound','Tooltip','Usually better to check it','Callback',@UpdateFit);

uicontrol('Parent',fbp_panel,'Style','edit','tag','cmax','FontSize',12,'units','normalized','Position',[0.52 0.65 0.15 0.1],'String',FitParameters.cmax,'Tooltip','in percent','Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.68 0.65 0.25 0.1],'String','Contrast Max');

uicontrol('Parent',fbp_panel,'Style','edit','tag','fmmax','FontSize',12,'units','normalized','Position',[0.52 0.5 0.15 0.1],'String',FitParameters.fmmax,'Tooltip',['smart = based on microwave range used' 10 'input value otherwise'],'Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.68 0.50 0.25 0.1],'String','Middle Freq Max');

uicontrol('Parent',fbp_panel,'Style','edit','tag','fdmax','FontSize',12,'units','normalized','Position',[0.52 0.35 0.15 0.1],'String',FitParameters.fdmax,'Tooltip',['smart = based on microwave range used' 10 'input value otherwise'],'Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.68 0.35 0.25 0.1],'String','Splitting Max');

uicontrol('Parent',fbp_panel,'Style','edit','tag','fwmax','FontSize',12,'units','normalized','Position',[0.52 0.2 0.15 0.1],'String',FitParameters.fwmax,'Tooltip','in MHz','Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.68 0.20 0.25 0.1],'String','Width Max');

uicontrol('Parent',fbp_panel,'Style','edit','tag','y0max','FontSize',12,'units','normalized','Position',[0.52 0.05 0.15 0.1],'String',FitParameters.y0max,'Tooltip',['factor applied to max of edges baseline'],'Callback',@UpdateFit);
uicontrol('Parent',fbp_panel,'Style','text','FontSize',12,'units','normalized','HorizontalAlignment','left','Position',[0.68 0.05 0.25 0.1],'String','Baseline Max');

%% Default

uicontrol('Parent',tab_fitparam,'Style','pushbutton','tag','RestoreDefault','units','normalized','FontSize',16,'Position',[0.43 0.1 0.08 0.03],'String','Restore Default','Tooltip','To restore default values stored in Start_and_Test_Files','Callback',@RestoreDefaultFitParameters);

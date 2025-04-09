%%Elements of Tab Additional parameters 

%% Additional Acquisition parameters
cpanel1_add=uipanel('Parent',tab_additional,'Title','Additional Acq Param','FontSize',14,'Position',[0.2 0.8 0.12 0.15]);

uicontrol('Parent',tab_additional,'Style', 'checkbox', 'String', 'RandomFreq','units','normalized','tag','RandomFreq',...
    'Position', [0.21 0.833 0.07 0.025],'FontSize',12,'Value',AcqParameters.RandomFreq,'Callback',@UpdateAcqParam);
uicontrol('Parent',tab_additional,'Style', 'checkbox', 'String', 'AutoAlignCrop','units','normalized','tag','AutoAlignCrop',...
    'Position', [0.21 0.883 0.1 0.025],'FontSize',12,'Value',AcqParameters.AutoAlignCrop,'Callback',@UpdateAutoAlignCrop);

%% Save Mode
% Create the button group
bg_saveMode = uibuttongroup('Parent', tab_additional,'Title','Save Mode','FontSize',14,'units', 'normalized', 'Position', [0.075 0.8 0.12 0.15], 'tag', 'SaveModeChoice','SelectionChangedFcn', @UpdateAcqParam);         

% Create the radio buttons (arranged vertically with closer spacing)
r1_saveMode = uicontrol(bg_saveMode, 'Style', 'radiobutton', 'units', 'normalized','String', 'slow&compressed', 'FontSize', 12, 'tag', 'SaveModeSlow','Position', [0.05 0.6 0.9 0.2], 'TooltipString', 'Default slow save mode');   
r2_saveMode = uicontrol(bg_saveMode, 'Style', 'radiobutton', 'units', 'normalized',  'String', 'fast&heavy', 'FontSize', 12, 'tag', 'SaveModeFast', 'Position', [0.05 0.35 0.9 0.2],'TooltipString',...
    'Fast save mode: 50 times faster, file 3 times bigger');   
r3_saveMode = uicontrol(bg_saveMode, 'Style', 'radiobutton', 'units', 'normalized', 'String', 'h5', 'FontSize', 12, 'tag', 'SaveModeH5', 'Position', [0.05 0.1 0.9 0.2], 'TooltipString', 'Save using HDF5 format');                

if strcmp(AcqParameters.SaveMode,'fast&heavy')
   bg_saveMode.SelectedObject = r2_saveMode;
elseif strcmp(AcqParameters.SaveMode,'h5')
    bg_saveMode.SelectedObject = r3_saveMode;
else 
   bg_saveMode.SelectedObject = r1_saveMode;
end

%% COM Ports
% Create the new panel for COM Ports
cpanel_com = uipanel('Parent', tab_additional, 'Title', 'COM Ports','FontSize', 14, 'Position', [0.075 0.6 0.16 0.16]);

% Lakeshore row
uicontrol('Parent', cpanel_com, 'Style', 'text', 'String', 'Lakeshore',     'units', 'normalized', 'Position', [0.05 0.72 0.3 0.2], 'FontSize', 12, 'HorizontalAlignment', 'left');
edit_Lakeshore = uicontrol('Parent', cpanel_com, 'Style', 'edit', 'String', AcqParameters.COM_Lakeshore, 'units', 'normalized', 'Position', [0.4 0.75 0.3 0.2], 'FontSize', 12, 'Tag', 'comLakeshore','Callback',@UpdateAcqParam,'TooltipString','Can be found in the windows device manager');
uicontrol('Parent', cpanel_com, 'Style', 'pushbutton', 'String', 'Test', 'units', 'normalized', 'Position', [0.75 0.75 0.2 0.2], 'FontSize', 12,'Callback', @(src, event) testCOMPort('Lakeshore'));

% Betsa row
uicontrol('Parent', cpanel_com, 'Style', 'text', 'String', 'BetsaLight','units', 'normalized', 'Position', [0.05 0.47 0.3 0.2], 'FontSize', 12, 'HorizontalAlignment', 'left');
edit_Betsa = uicontrol('Parent', cpanel_com, 'Style', 'edit', 'String', AcqParameters.COM_Betsa, 'units', 'normalized', 'Position', [0.4 0.5 0.3 0.2], 'FontSize', 12,'Tag', 'comBetsa','Callback',@UpdateAcqParam,'TooltipString','Can be found in the windows device manager');
uicontrol('Parent', cpanel_com, 'Style', 'pushbutton', 'String', 'Test', 'units', 'normalized', 'Position', [0.75 0.5 0.2 0.2], 'FontSize', 12, 'Callback', @(src, event) testCOMPort('Betsa'));



%% Setup Type
% Helps defining setup differences, such as what is connected on the NI card, if there is a laser shutter, etc

uicontrol('Parent', tab_additional, 'Style', 'text', 'String', 'Setup Type','units', 'normalized', 'Position', [0.075 0.3975 0.05 0.025], 'FontSize', 12, 'HorizontalAlignment', 'left');
edit_SetupType = uicontrol('Parent', tab_additional, 'Style', 'edit', 'String', AcqParameters.SetupType, 'units', 'normalized', 'Position', [0.13 0.4 0.05 0.025], 'FontSize', 12,'Tag','SetupType','Callback',@UpdateAcqParam,'TooltipString','CEA, ENS1, ENS2: helps defining setup differences, such as what is connected on the NI card, if there is a laser shutter, etc');

%% AutoFocus method
% Autofocus method used by the piezo z align 

uicontrol('Parent', tab_additional, 'Style', 'text', 'String', 'Autofocus z method','units', 'normalized', 'Position', [0.05 0.3475 0.08 0.025], 'FontSize', 12, 'HorizontalAlignment', 'left');
edit_SetupType = uicontrol('Parent', tab_additional, 'Style', 'edit', 'String', AcqParameters.AF_Method, 'units', 'normalized', 'Position', [0.13 0.35 0.05 0.025], 'FontSize', 12,'Tag','AF_Method','Callback',@UpdateAcqParam,'Tooltip',['Fulllist {BREN,CONT,GDER,GLLV,GRAE,GRAT,HELM,HISR,LAPD,LAPE,LAPV,SFRQ,TENG,TENV,' 10 'VOLA,WAVV,WAVR,ACMO,CURV,DCTE,DCTR,GLVA,GLVN,GRAS,HISE,LAPM,SFIL,WAVS}' 10 'CEA: DCTR works best but is slow, ENS: BREN works fast']);


%% File Name Prefix Panel

if strcmp(AcqParameters.FileNamePrefixChoice, 'Date+Base')
    IniFileNamePrefix = [date '-ESR-WideField'];
else
    IniFileNamePrefix = AcqParameters.FileNameUserPrefix;
end

% Main panel, centré dans l'onglet
cpanel_filename = uipanel('Parent', tab_additional, 'Title', 'File Name Prefix', 'FontSize', 14, ...
    'Position', [0.35 0.45 0.3 0.2]);  % Ajustement de la taille et position au centre

% Ligne affichant "Prefix = " et la valeur associée
uicontrol('Parent', cpanel_filename, 'Style', 'text', 'String', 'Prefix = ', ...
    'units', 'normalized', 'FontSize', 12, 'HorizontalAlignment', 'right',  ...
    'Position', [0.05 0.77 0.17 0.15]);

uicontrol('Parent', cpanel_filename, 'Style', 'text', 'String',IniFileNamePrefix, ...
    'units', 'normalized', 'FontSize', 12, 'HorizontalAlignment', 'left', 'FontWeight', 'bold', ...
    'Position', [0.23 0.77 0.75 0.15], 'Tag', 'FileNamePrefix');

% Sous-panel avec uibuttongroup
bg_prefixChoice = uibuttongroup('Parent', cpanel_filename, 'Title', '', ...
    'units', 'normalized', 'Position', [0.05 0.37 0.25 0.35], 'SelectionChangedFcn', @UpdatePrefixName, 'Tag','FileNamePrefixChoice');

r1_prefixChoice = uicontrol(bg_prefixChoice, 'Style', 'radiobutton', 'String', 'Date+Base', ...
    'units', 'normalized', 'FontSize', 12, 'Position', [0.05 0.5 0.9 0.5], 'Tag', 'PrefixChoiceDate');

r2_prefixChoice = uicontrol(bg_prefixChoice, 'Style', 'radiobutton', 'String', 'UserDefined', ...
    'units', 'normalized', 'FontSize', 12, 'Position', [0.05 0 0.9 0.5], 'Tag', 'PrefixChoiceUser');

% Sélection initiale
if strcmp(AcqParameters.FileNamePrefixChoice, 'Date+Base')
    bg_prefixChoice.SelectedObject = r1_prefixChoice;
else
    bg_prefixChoice.SelectedObject = r2_prefixChoice;
end

% Ligne pour l'édition du préfixe utilisateur
uicontrol('Parent', cpanel_filename, 'Style', 'text', 'String', 'User Prefix = ', ...
    'units', 'normalized', 'FontSize', 12, 'HorizontalAlignment', 'left', ...
    'Position', [0.05 0.1 0.17 0.15]);

uicontrol('Parent', cpanel_filename, 'Style', 'edit', 'String', AcqParameters.FileNameUserPrefix, ...
    'units', 'normalized', 'FontSize', 12, 'Tag', 'FileNameUserPrefix', 'HorizontalAlignment', 'left', ...
    'Position', [0.23 0.08 0.75 0.2], 'Callback', @UpdatePrefixName);

% Update FileName
nomSave = NameGen(AcqParameters.Data_Path,IniFileNamePrefix,AcqParameters.Save);
tag_FileName = findobj('tag','nameFile');
set(tag_FileName,'String',['File: ' nomSave]);

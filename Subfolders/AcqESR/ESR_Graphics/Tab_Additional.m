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



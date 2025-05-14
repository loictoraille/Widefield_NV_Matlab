% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Elements of Heliotis Control Tab (tab_helicam)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Prerequisite: Ensure tab_helicam and global ObjCamera exist and is initialized ---
global ObjCamera

% Initialize ObjCamera if it hasn't been (ensure fields exist)
if isempty(ObjCamera) || ~isstruct(ObjCamera) % Or ~isobject if it's an object
    disp('Initializing global ObjCamera for Heliotis Tab testing...');
    ObjCamera = struct(); % Or your class constructor
end
if ~isfield(ObjCamera, 'NbFrames'), ObjCamera.NbFrames = 100; end
if ~isfield(ObjCamera, 'NPeriods'), ObjCamera.NPeriods = 10; end
if ~isfield(ObjCamera, 'sensitivity'), ObjCamera.sensitivity = 0.5; end
if ~isfield(ObjCamera, 'coupling'), ObjCamera.coupling = 'AC'; end % Default
if ~isfield(ObjCamera, 'refFrequency'), ObjCamera.refFrequency = 10000; end % Example frequency in Hz

% --- UI Element Definitions ---
% Store handles to UI elements of this tab if needed for dynamic updates between them
heliHandles = struct(); % To store handles of controls in this tab

labelFontSize = 10;
editFontSize = 10;
uiHeight = 0.06; % Normalized height for rows
vSpacing = 0.03; % Vertical spacing between rows
currentY = 1 - uiHeight - vSpacing*2; % Start from top with a bit more margin

% --- 1. Frame Number ---
uicontrol('Parent', tab_helicam, 'Style', 'text', 'String', 'Frame Number:', ...
    'units', 'normalized', 'Position', [0.05 currentY 0.28 uiHeight*0.8], ...
    'HorizontalAlignment', 'left', 'FontSize', labelFontSize);
heliHandles.NbFrames = uicontrol('Parent', tab_helicam, 'Style', 'edit', 'tag', 'NbFrames', ...
    'units', 'normalized', 'Position', [0.35 currentY 0.15 uiHeight*0.8], ...
    'String', num2str(ObjCamera.NbFrames), 'Callback', @setNbFrames, ...
    'FontSize', editFontSize);
currentY = currentY - uiHeight - vSpacing;

% --- 2. Integration Period Numbers ---
uicontrol('Parent', tab_helicam, 'Style', 'text', 'String', 'Integration Periods:', ...
    'units', 'normalized', 'Position', [0.05 currentY 0.28 uiHeight*0.8], ...
    'HorizontalAlignment', 'left', 'FontSize', labelFontSize);
heliHandles.NPeriods = uicontrol('Parent', tab_helicam, 'Style', 'edit', 'tag', 'NPeriods', ...
    'units', 'normalized', 'Position', [0.35 currentY 0.15 uiHeight*0.8], ...
    'String', num2str(ObjCamera.NPeriods), 'Callback', @setNPeriods, ...
    'FontSize', editFontSize);
currentY = currentY - uiHeight - vSpacing;

% --- 3. Sensitivity ---
uicontrol('Parent', tab_helicam, 'Style', 'text', 'String', 'Sensitivity (0-1):', ...
    'units', 'normalized', 'Position', [0.05 currentY+uiHeight*0.2 0.28 uiHeight*0.8], ...
    'HorizontalAlignment', 'left', 'FontSize', labelFontSize);
heliHandles.sldSensitivity = uicontrol('Parent', tab_helicam, 'Style', 'slider', ...
    'Min', 0, 'Max', 1, 'Value', ObjCamera.sensitivity, 'tag', 'sensitivity', ...
    'units', 'normalized', 'Position', [0.35 currentY 0.3 uiHeight*0.8], ...
    'Callback', @(src, evt) setSensitivity(src, evt, heliHandles)); % Pass heliHandles
heliHandles.editSensitivity = uicontrol('Parent', tab_helicam, 'Style', 'edit', ...
    'units', 'normalized', 'Position', [0.67 currentY 0.1 uiHeight*0.8], ...
    'String', sprintf('%.2f', ObjCamera.sensitivity), 'tag', 'editSensitivityVal', ...
    'Callback', @(src, evt) setSensitivityEdit(src, evt, heliHandles), 'FontSize', editFontSize);
% Listener to update edit box from slider value changes (live update)
addlistener(heliHandles.sldSensitivity, 'Value', 'PostSet', @(src, evt) updateSensitivityEditFromSlider(evt, heliHandles));
currentY = currentY - uiHeight - vSpacing;

% --- 4. Coupling Mode ---
heliHandles.bgCoupling = uibuttongroup('Parent', tab_helicam, 'units','normalized', ...
    'Position',[0.05 currentY-vSpacing 0.4 0.12],'tag','coupling',...
    'SelectionChangedFcn', @setCoupling, 'Title', 'Coupling Mode'); % No handles needed if only ObjCamera is updated
heliHandles.rAC = uicontrol(heliHandles.bgCoupling,'Style','radiobutton','units','normalized',...
    'String','AC','FontSize',labelFontSize,'Position',[0.1 0.1 0.35 0.5]);
heliHandles.rDC = uicontrol(heliHandles.bgCoupling,'Style','radiobutton','units','normalized',...
    'String','DC','FontSize',labelFontSize,'Position',[0.55 0.1 0.35 0.5]);

if strcmpi(ObjCamera.coupling,'AC')
   heliHandles.bgCoupling.SelectedObject = heliHandles.rAC;
else
   heliHandles.bgCoupling.SelectedObject = heliHandles.rDC;
end
currentY = currentY - 0.12 - vSpacing*2; % Adjust Y after buttongroup

% --- 5. Modulation Frequency ---
% Define Min/Max for your modulation frequency
modFreqMin = 1000;    % Hz
modFreqMax = 100000; % Hz
if ~isfield(ObjCamera, 'refFrequency') || ObjCamera.refFrequency < modFreqMin, ObjCamera.refFrequency = modFreqMin; end
if ObjCamera.refFrequency > modFreqMax, ObjCamera.refFrequency = modFreqMax; end

uicontrol('Parent', tab_helicam, 'Style', 'text', 'String', ['Modulation Freq (' num2str(modFreqMin) '-' num2str(modFreqMax) ' Hz):'], ...
    'units', 'normalized', 'Position', [0.05 currentY+uiHeight*0.2 0.28 uiHeight*0.8], ...
    'HorizontalAlignment', 'left', 'FontSize', labelFontSize);
heliHandles.sldModFreq = uicontrol('Parent', tab_helicam, 'Style', 'slider', ...
    'Min', modFreqMin, 'Max', modFreqMax, 'Value', ObjCamera.refFrequency, ...
    'tag', 'modulationFrequency', 'units', 'normalized', ...
    'Position', [0.35 currentY 0.3 uiHeight*0.8], ...
    'Callback', @(src, evt) setModulationFrequency(src, evt, heliHandles));
heliHandles.editModFreq = uicontrol('Parent', tab_helicam, 'Style', 'edit', ...
    'units', 'normalized', 'Position', [0.67 currentY 0.1 uiHeight*0.8], ...
    'String', num2str(ObjCamera.refFrequency), 'tag', 'editModFreqVal',...
    'Callback', @(src, evt) setModulationFrequencyEdit(src, evt, heliHandles), 'FontSize', editFontSize);
% Listener to update edit box from slider value changes (live update)
addlistener(heliHandles.sldModFreq, 'Value', 'PostSet', @(src, evt) updateModFreqEditFromSlider(evt, heliHandles));
currentY = currentY - uiHeight - vSpacing;

% --- 6. SEND Button ---
currentY = currentY - uiHeight*0.5 - vSpacing; % Extra space before button
uicontrol('Parent', tab_helicam, 'Style', 'pushbutton', 'String', 'SEND', ...
    'tag', 'sendToHeliotis', 'units', 'normalized', ...
    'Position', [0.05 currentY 0.2 uiHeight*1.2], 'FontSize', labelFontSize+2, ...
    'FontWeight', 'bold', 'Callback', @SendParamToHeliCam);

% Optional: If you need to access heliHandles from outside this script,
% you could store it, for example, in the tab's UserData or app data.
% set(tab_helicam, 'UserData', heliHandles);


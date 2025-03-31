% --- Création du panneau principal dans l'onglet ---
panel_temp = uipanel('Parent', tab_readtemp, 'Title', 'Continuous Temperature Reading','FontSize', 14, 'Position', [0.1 0.89 0.8 0.1]); 

% --- Zone de texte "every" ---
uicontrol('Parent', panel_temp, 'Style', 'text', 'String', 'Every', 'units', 'normalized', 'Position', [0.26 0.38 0.04 0.3], 'FontSize', 12,'HorizontalAlignment', 'right');

% --- Case éditable pour l'intervalle en minutes ---
edit_interval = uicontrol('Parent', panel_temp, 'Style', 'edit', 'units', 'normalized', 'Position', [0.31 0.37 0.03 0.35], 'FontSize', 12, 'Tag', 'tr_periodminute', 'String', num2str(AcqParameters.TR_Period_Minute), 'Callback', @UpdateTempPeriod);

% --- Zone de texte "minutes" ---
uicontrol('Parent', panel_temp, 'Style', 'text', 'String', 'minutes', 'units', 'normalized', 'Position', [0.35 0.38 0.05 0.3], 'FontSize', 12, 'HorizontalAlignment', 'left');

% --- Bouton "Start" ---
uicontrol('Parent', panel_temp, 'Style', 'pushbutton', 'String', 'Start', 'units', 'normalized', 'Position', [0.15 0.2 0.05 0.7],'tag','startCTR', 'FontSize', 16,'Callback', @StartContinuousTempReading,'Tooltip','Starts new acquisition without saving and without resetting');

% --- Bouton "Stop&Save" ---
uicontrol('Parent', panel_temp, 'Style', 'pushbutton', 'String', 'Stop&Save','units', 'normalized', 'Position', [0.45 0.2 0.1 0.7],'tag', 'stopsaveCTR', 'FontSize', 16,'Callback', @StopSaveContinuousTempReading,'Tooltip','Stop and save temperature reading');

% --- Bouton "Stop" ---
uicontrol('Parent', panel_temp, 'Style', 'pushbutton', 'String', 'Stop','units', 'normalized', 'Position', [0.57 0.2 0.1 0.7],'tag', 'stopCTR', 'FontSize', 16,'Callback', @StopContinuousTempReading,'Tooltip','Stop data reading without saving and without resetting');

% --- Bouton "Save" ---
uicontrol('Parent', panel_temp, 'Style', 'pushbutton', 'String', 'Save','units', 'normalized', 'Position', [0.69 0.2 0.1 0.7],'tag', 'saveCTR', 'FontSize', 16,'Callback', @SaveContinuousTempReading);

% --- Bouton "Reset" ---
uicontrol('Parent', panel_temp, 'Style', 'pushbutton', 'String', 'Reset','units', 'normalized', 'Position', [0.81 0.2 0.1 0.7],'tag', 'resetCTR', 'FontSize', 16,'Callback', @ResetContinuousTempReading,'Tooltip','Reset data and axes without saving and without stopping');


% --- Zone de graphique pour tracer Ta et Tb ---
ax_temp = axes('Parent', tab_readtemp, 'Position', [0.1 0.08 0.8 0.75],'tag','ax_temp_tag'); 
hold(ax_temp, 'on');
title(ax_temp, 'Temperature Evolution');
xlabel(ax_temp, 'Time (min)');
ylabel(ax_temp, 'Temperature (K)');
grid(ax_temp, 'on');

% --- Checkbox pour le capteur A ---
uicontrol('Parent',tab_readtemp,'Style', 'checkbox', 'String', 'Sensor A','units','normalized','tag','SensorA',...
    'Position', [0.93 0.75 0.05 0.025],'FontSize',10,'Value',AcqParameters.SensorTempA,'Callback',@UpdateAcqParam);

% --- Case éditable pour le capteur A ---
uicontrol('Parent', tab_readtemp, 'Style', 'edit', 'units', 'normalized', 'Position', [0.915 0.72 0.07 0.025], 'FontSize',...
    12, 'Tag', 'SensorA_Name', 'String', AcqParameters.SensorTempA_Name, 'Callback', @UpdateAcqParam);

% --- Checkbox pour le capteur B ---
uicontrol('Parent',tab_readtemp,'Style', 'checkbox', 'String', 'Sensor B','units','normalized','tag','SensorB',...
    'Position', [0.93 0.6 0.05 0.025],'FontSize',10,'Value',AcqParameters.SensorTempB,'Callback',@UpdateAcqParam);

% --- Case éditable pour le capteur B ---
uicontrol('Parent', tab_readtemp, 'Style', 'edit', 'units', 'normalized', 'Position', [0.915 0.57 0.07 0.025], 'FontSize',...
    12, 'Tag', 'SensorB_Name', 'String', AcqParameters.SensorTempB_Name, 'Callback', @UpdateAcqParam);


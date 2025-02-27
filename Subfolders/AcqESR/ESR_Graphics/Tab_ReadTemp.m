% --- Création du panneau principal dans l'onglet ---
panel_temp = uipanel('Parent', tab_readtemp, 'Title', 'Continuous Temperature Reading','FontSize', 14, 'Position', [0.1 0.89 0.8 0.1]); 

% --- Zone de texte "every" ---
uicontrol('Parent', panel_temp, 'Style', 'text', 'String', 'Every', 'units', 'normalized', 'Position', [0.46 0.38 0.04 0.3], 'FontSize', 12,'HorizontalAlignment', 'right');

% --- Case éditable pour l'intervalle en minutes ---
edit_interval = uicontrol('Parent', panel_temp, 'Style', 'edit', 'units', 'normalized','Tooltipstring','Need to stop and start again to update the period', 'Position', [0.51 0.37 0.03 0.35], 'FontSize', 12, 'Tag', 'tr_periodminute', 'String', num2str(AcqParameters.TR_Period_Minute), 'Callback', @UpdateAcqParam);

% --- Zone de texte "minutes" ---
uicontrol('Parent', panel_temp, 'Style', 'text', 'String', 'minutes', 'units', 'normalized', 'Position', [0.55 0.38 0.05 0.3], 'FontSize', 12, 'HorizontalAlignment', 'left');

% --- Bouton "Start" ---
uicontrol('Parent', panel_temp, 'Style', 'pushbutton', 'String', 'Start', 'units', 'normalized', 'Position', [0.65 0.2 0.05 0.7],'tag','startCTR', 'FontSize', 16,'Callback', @StartContinuousTempReading);

% --- Bouton "Stop&Save" ---
uicontrol('Parent', panel_temp, 'Style', 'pushbutton', 'String', 'Stop&Save','units', 'normalized', 'Position', [0.75 0.2 0.12 0.7],'tag', 'saveCTR', 'FontSize', 16,'Callback', @StopContinuousTempReading);


% --- Zone de graphique pour tracer Ta et Tb ---
ax_temp = axes('Parent', tab_readtemp, 'Position', [0.1 0.08 0.8 0.75]); 
hold(ax_temp, 'on');
title(ax_temp, 'Temperature Evolution');
xlabel(ax_temp, 'Time (min)');
ylabel(ax_temp, 'Temperature (K)');
grid(ax_temp, 'on');
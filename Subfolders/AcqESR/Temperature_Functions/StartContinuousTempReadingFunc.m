function StartContinuousTempReadingFunc()

panel = guidata(gcbo);

ax_temp = panel.ax_temp_tag;
btnStart = panel.startCTR;

% Récupérer la période
period_min = str2double(panel.tr_periodminute.String);
period_sec = period_min * 60;

% Vérifier si un timer existe déjà dans UserData et l'arrêter
if isfield(btnStart.UserData, 'timer') && isvalid(btnStart.UserData.timer)
    stop(btnStart.UserData.timer);
    delete(btnStart.UserData.timer);
    btnStart.UserData = rmfield(btnStart.UserData, 'timer');
end

disp(['Start of continuous temperature reading every ' num2str(period_sec) ' seconds']);

% Initialiser les données stockées dans l'axe ou récupérer les données déjà présentes
if isprop(ax_temp,'UserData') && ~isempty(ax_temp.UserData)
    data = ax_temp.UserData;
else
    data = struct('time', [], 'Ta', [], 'Tb', []);
end

% Démarrer la première acquisition immédiatement
T = ReadTemp();
Ta = T(1); Tb = T(2);

data.time = [data.time, now];
data.Ta = [data.Ta, Ta];
data.Tb = [data.Tb, Tb];

ax_temp.UserData = data;
UpdateTemperaturePlot(ax_temp);

% Créer et configurer le timer
t = timer('Period', period_sec, 'ExecutionMode', 'fixedRate','TimerFcn', @(~,~) TimerReadAndPlot(ax_temp), 'StartDelay', period_sec);

% Stocker le timer dans UserData du bouton
btnStart.UserData.timer = t;

% Démarrer le timer
start(t);

end
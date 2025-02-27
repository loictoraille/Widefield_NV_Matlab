function StartContinuousTempReading(src, ~)

    set(src,'ForegroundColor',[0 1 0]);
    set(src,'Value',1);

    % Récupérer l'objet du bouton Start (gcbo)
    btnStart = src;

    % Trouver l'axe du graphique à partir de son parent
    panel = btnStart.Parent;
    ax_temp = findobj(panel.Parent, 'Type', 'axes');
    

    % Récupérer la période depuis AcqParameters
    load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
    period_min = AcqParameters.TR_Period_Minute;
    period_sec = period_min * 60;

    % Vérifier si un timer existe déjà dans UserData et l'arrêter
    if isfield(btnStart.UserData, 'timer') && isvalid(btnStart.UserData.timer)
        stop(btnStart.UserData.timer);
        delete(btnStart.UserData.timer);

        % Appeler la fonction de sauvegarde
        btnStopSave=findobj('tag','saveCTR');
        SaveTemperatureData(btnStopSave, []);

        disp('End of continuous temperature reading');
    end

    disp(['Start of continuous temperature reading every ' num2str(period_sec) ' seconds']);

    % Initialiser les données stockées dans l'axe
    data = struct('time', [], 'Ta', [], 'Tb', []);

    % Démarrer la première acquisition immédiatement
    T = ReadTemp();
    Ta = T(1); Tb = T(2);
    data.time = now;
    data.Ta = Ta;
    data.Tb = Tb;

    ax_temp.UserData = data;
    UpdateTemperaturePlot(ax_temp, Ta, Tb);
    legend(ax_temp, {'Diode (Ta)', 'Thermocouple (Tb)'});

    % Créer et configurer le timer
    t = timer('Period', period_sec, 'ExecutionMode', 'fixedRate','TimerFcn', @(~,~) TimerReadAndPlot(ax_temp), 'StartDelay', period_sec);

    % Stocker le timer dans UserData du bouton
    btnStart.UserData.timer = t;

    % Démarrer le timer
    start(t);
end

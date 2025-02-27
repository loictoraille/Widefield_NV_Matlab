function StopContinuousTempReading(src, ~)

    set(src,'ForegroundColor',[0 1 0]);

    tag_start=findobj('tag','startCTR');
    set(tag_start,'ForegroundColor',[0 0 0]);

    % Récupérer l'objet du bouton Stop
    btnStopSave = src;

    % Récupérer le bouton Start (même parent)
    panel = btnStopSave.Parent;
    btnStart = findobj(panel, 'Style', 'pushbutton', 'String', 'Start');

    % Vérifier si le timer existe et l'arrêter
    if isfield(btnStart.UserData, 'timer') && isvalid(btnStart.UserData.timer)
        stop(btnStart.UserData.timer);
        delete(btnStart.UserData.timer);
        btnStart.UserData = rmfield(btnStart.UserData, 'timer');
    end

    disp('End of continuous temperature reading');

    % Appeler la fonction de sauvegarde
    SaveTemperatureData(btnStopSave, []);

    set(src,'ForegroundColor',[0 0 0]);

end

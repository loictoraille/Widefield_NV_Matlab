function StopContinuousTempReadingFunc()

    btnStart=findobj('tag','startCTR');
    set(btnStart,'ForegroundColor',[0 0 0]);

    % Vérifier si le timer existe et l'arrêter
    if isfield(btnStart.UserData, 'timer') && isvalid(btnStart.UserData.timer)
        stop(btnStart.UserData.timer);
        delete(btnStart.UserData.timer);
        btnStart.UserData = rmfield(btnStart.UserData, 'timer');
    end

    disp('End of continuous temperature reading');

end

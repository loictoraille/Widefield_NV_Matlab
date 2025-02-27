function SaveTemperatureData(src, ~)

    set(src,'ForegroundColor',[0 1 0]);

    load([getPath('Param') 'AcqParameters.mat'],'AcqParameters');
    Data_Path = AcqParameters.Data_Path;

    % Récupérer l'objet du bouton Save
    btnStopSave = src;

    % Trouver l'axe du graphique
    panel = btnStopSave.Parent;
    ax_temp = findobj(panel.Parent, 'Type', 'axes');

    % Récupérer les données stockées
    data = ax_temp.UserData;

    % Vérifier si des données existent
    if isfield(data,'time') && isempty(data.time)
%         disp('No data to save!', 'Error');
        set(src,'ForegroundColor',[0 0 0]);
        return;
    end

    % Convertir le temps en durée depuis le début (en minutes)
    time_min = (data.time - data.time(1)) * 24 * 60;

    % Générer un nom de fichier avec date et numéro
%     timestamp = datestr(now, 'yyyymmdd_HHMMSS'); % Format YYYYMMDD_HHMMSS
    timestamp = datestr(now, 'yyyymmdd'); % Format YYYYMMDD_HHMMSS
    base_filename = fullfile(Data_Path, ['Temperature_', timestamp]);

        % Trouver un numéro disponible
    num = 1;
    while exist([base_filename, '_', num2str(num), '.png'], 'file')
        num = num + 1;
    end
    img_filepath = [base_filename, '_', num2str(num), '.png'];

    % Sauvegarde de l'image du graphique
    exportgraphics(ax_temp,img_filepath);
    disp(['Graph saved to ', img_filepath]);

    % Sauvegarde des données en ASCII
    data_filepath = strrep(img_filepath, '.png', '.txt'); % Même nom mais en .txt
    header =  "Time (min)\tTa (K)\tTb (K)\n";
    data_matrix  = [time_min(:),data.Ta(:),data.Tb(:)];

    fid = fopen(data_filepath, 'w');
    fprintf(fid, header);
    fclose(fid);

    writematrix(data_matrix, data_filepath, 'Delimiter', '\t', 'WriteMode', 'append')
    disp(['Data saved to ', data_filepath]);

    set(src,'ForegroundColor',[0 0 0]);

end

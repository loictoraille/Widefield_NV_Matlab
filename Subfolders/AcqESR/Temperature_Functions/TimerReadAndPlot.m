function TimerReadAndPlot(ax_temp)
    % Lire la température
    T = ReadTemp();
    Ta = T(1); Tb = T(2);

    % Récupérer les données stockées dans l'axe
    data = ax_temp.UserData;

    % Ajouter les nouvelles données
    data.time = [data.time, now];
    data.Ta = [data.Ta, Ta];
    data.Tb = [data.Tb, Tb];

    % Stocker les nouvelles données dans UserData
    ax_temp.UserData = data;

    % Mettre à jour le graphique
    UpdateTemperaturePlot(ax_temp);
end

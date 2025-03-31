function UpdateTemperaturePlot(ax_temp)
    % Récupérer les données stockées
    data = ax_temp.UserData;

    % Initialize legend variables
    legend_entries = {}; % Stores the names of the plotted data
    plot_handles = [];   % Stores the handles of the plotted curves

    % Tracer les courbes
    cla(ax_temp);
    hold(ax_temp, 'on');
    if panel.SensorA.Value == 1 
        hA = plot(ax_temp, data.time, data.Ta, '-o', 'LineWidth', 2, 'Color', 'b');
        plot_handles = [plot_handles, hA];
        legend_entries{end+1} = panel.SensorA_Name.String; % Add legend text
    end
    if panel.SensorB.Value == 1 
        hB = plot(ax_temp, data.time, data.Tb, '-o', 'LineWidth', 2, 'Color', 'r');
        plot_handles = [plot_handles, hB];
        legend_entries{end+1} = panel.SensorB_Name.String; % Add legend text
    end
    hold(ax_temp, 'off');

    % Update the legend only if there are plotted curves
    if ~isempty(plot_handles)
        legend(ax_temp, plot_handles, legend_entries, 'Location', 'best');
    else
        legend(ax_temp, 'off'); % Hide legend if no data is plotted
    end

    % Mise à jour des axes
    datetick(ax_temp, 'x', 'HH:MM:SS');
    xlabel(ax_temp, 'Time');
    ylabel(ax_temp, 'Temperature (K)');
    grid(ax_temp, 'on');

    % Rafraîchir l'affichage
    drawnow;

    ax_temp.UserData = data;

end

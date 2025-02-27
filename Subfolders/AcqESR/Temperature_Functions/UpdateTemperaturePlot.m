function UpdateTemperaturePlot(ax_temp, Ta, Tb)
    % Récupérer les données stockées
    data = ax_temp.UserData;

    % Tracer les courbes
    cla(ax_temp);
    plot(ax_temp, data.time, data.Ta, '-o', 'LineWidth', 2, 'Color', 'b');
    hold(ax_temp, 'on');
    plot(ax_temp, data.time, data.Tb, '-o', 'LineWidth', 2, 'Color', 'r');
    hold(ax_temp, 'off');

    % Mise à jour des axes
    datetick(ax_temp, 'x', 'HH:MM:SS');
    xlabel(ax_temp, 'Time');
    ylabel(ax_temp, 'Temperature (K)');
    legend(ax_temp, {'Diode (Ta)', 'Thermocouple (Tb)'});
    grid(ax_temp, 'on');

    % Rafraîchir l'affichage
    drawnow;

    ax_temp.UserData = data;

end

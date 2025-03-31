function ResetContinuousTempReading(src, ~)

set(src,'ForegroundColor',[0 0 1]);

% Récupérer l'objet du bouton Reset (gcbo)
btnReset = src;

% Trouver l'axe du graphique à partir de son parent
panel = btnReset.Parent;
ax_temp = findobj(panel.Parent, 'Type', 'axes');

data = struct('time', [], 'Ta', [], 'Tb', []);
ax_temp.UserData = data;
UpdateTemperaturePlot(ax_temp);

disp('Resetting continuous temperature reading');

set(src,'ForegroundColor',[0 0 0]);


end
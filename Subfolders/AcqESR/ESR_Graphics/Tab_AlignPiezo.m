% --- Création du nouvel onglet ---
panel_AlignPiezo = uipanel('Parent', tab_alignpiezo, 'Title', 'Autofocus & Autocorrelation');  % Adjust tabgroup to your existing tab group

% --- Zone de graphique pour 'Last Autofocus z' ---
ax_piezo_autofoc = axes('Parent', panel_AlignPiezo, 'tag','ax_piezo_autofoc', 'Position', [0.1 0.55 0.8 0.4]); 
hold(ax_piezo_autofoc, 'on');
title(ax_piezo_autofoc, 'Last Autofocus Z - Gaussian Fit');
xlabel(ax_piezo_autofoc, 'Value of the Z piezo (V)');  
ylabel(ax_piezo_autofoc, 'Autofocus estimation (a.u.)');  
grid(ax_piezo_autofoc, 'on');
legend(ax_piezo_autofoc,'Location','south');

% --- Zone de graphique pour 'Lum_Initial' ---
ax_lum_initial = axes('Parent', panel_AlignPiezo, 'tag','ax_lum_initial', 'Position', [0.03 0.08 0.3 0.4]); 
title(ax_lum_initial, 'Initial reference image for autocorrelation');
% imagesc(Lum_Initial);axis('image');caxis([0 65535]);

% --- Zone de graphique pour 'Last Autocorrelation xy' ---
ax_piezo_autocorr = axes('Parent', panel_AlignPiezo, 'tag','ax_piezo_autocorr', 'Position', [0.36 0.08 0.3 0.4]); 
hold(ax_piezo_autocorr, 'on');
title(ax_piezo_autocorr, 'Last Autocorrelation XY - Minimum estimation');
xlabel(ax_piezo_autocorr, 'Value of the X piezo (V)');  
ylabel(ax_piezo_autocorr, 'Value of the Y piezo (V)');  
grid(ax_piezo_autocorr, 'on');

% --- Zone de graphique pour 'Lum post autocorr' ---
ax_lum_post_autocorr = axes('Parent', panel_AlignPiezo, 'tag','ax_lum_post_autocorr', 'Position', [0.69 0.08 0.3 0.4]); 
title(ax_lum_post_autocorr, 'New image post autocorrelation');
% imagesc(Lum_Post_AutoCorr);axis('image');caxis([0 65535]);

function [x_opt, y_opt] = optimize_gaussian_position_2D(ImageCurrent)
    % Optimise la position x et y d'un point lumineux en ajustant un fit gaussien.

    % Définition des valeurs initiales pour l'ajustement gaussien
    [rows, cols] = size(ImageCurrent);
    [X, Y] = meshgrid(1:cols, 1:rows);
    amplitude_guess = max(ImageCurrent(:));
    x0_guess = mean(X(:));
    y0_guess = mean(Y(:));
    sigma_x_guess = 1;
    sigma_y_guess = 1;
    offset_guess = min(ImageCurrent(:));
    initial_guess = [amplitude_guess, x0_guess, y0_guess, sigma_x_guess, sigma_y_guess, offset_guess];

    % Définition des bornes pour les paramètres de l'ajustement gaussien
    lb = [0, 1, 1, 0, 0, 0]; % Lower bounds
    ub = [inf, cols, rows, inf, inf, inf]; % Upper bounds

    % Ajustement gaussien en utilisant lsqcurvefit
    options = optimoptions(@lsqcurvefit,'Display','off');
    fit_params = lsqcurvefit(@gaussian2D, initial_guess, [X(:), Y(:)], ImageCurrent(:), lb, ub, options);

    % Position optimale x et y
    x_opt = fit_params(2);
    y_opt = fit_params(3);
end
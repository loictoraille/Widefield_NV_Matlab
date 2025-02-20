function max_x = fit_gaussian_and_get_max(x_values, y_values)
    % Initial guess for the Gaussian fit parameters
    initial_guess = [max(y_values), mean(x_values), std(x_values), min(y_values)];

    % Define lower and upper bounds for the fit parameters
    lower_bound = [0, min(x_values), 0, 0];
    upper_bound = [Inf, max(x_values), Inf, Inf];

    % Perform Gaussian fit using lsqcurvefit
    fit_parameters = lsqcurvefit(@gaussian_fit, initial_guess, x_values, y_values, lower_bound, upper_bound);

    % Extract maximum coordinates from the fit parameters
    max_x = fit_parameters(2);
end
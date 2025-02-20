function F = gaussian2D(params, XY)
    % Fonction gaussienne 2D

    A = params(1);
    x0 = params(2);
    y0 = params(3);
    sigma_x = params(4);
    sigma_y = params(5);
    offset = params(6);

    X = XY(:, 1);
    Y = XY(:, 2);

    F = A * exp(-((X - x0).^2 / (2 * sigma_x^2) + (Y - y0).^2 / (2 * sigma_y^2))) + offset;
end
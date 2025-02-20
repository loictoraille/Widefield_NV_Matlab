function y = gaussian_fit(parameters, x)
    % Gaussian function: A * exp(-((x - x0)/sigma)^2) + offset
    A = parameters(1);
    x0 = parameters(2);
    sigma = parameters(3);
    offset = parameters(4);
    
    y = A * exp(-((x - x0) / sigma).^2) + offset;
end
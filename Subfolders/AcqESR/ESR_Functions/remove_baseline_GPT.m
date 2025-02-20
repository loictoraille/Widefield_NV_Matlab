function [baseline, corrected_signal] = remove_baseline_GPT(Spectrum)
    % remove_baseline removes the baseline from a noisy signal using the ALS method
    % Inputs:
    % - signal: the original noisy signal
    % - lambda: smoothing parameter (suggest 10^5 to 10^7)
    % - p: asymmetry parameter (suggest between 0.001 and 0.1)
    % - iter: number of iterations (suggest around 10)
    % Outputs:
    % - corrected_signal: the signal after baseline removal
    % - baseline: the identified baseline
    
    lambda = 10^6;
    p = 0.01;
    iter = 10;

    L = length(Spectrum);
    D = diff(speye(L), 2);
    H = lambda * (D' * D);
    w = ones(L, 1);

    for i = 1:iter
        W = spdiags(w, 0, L, L);
        Z = W + H;
        baseline = Z \ (w .* Spectrum);
        w = p * (Spectrum > baseline) + (1 - p) * (Spectrum < baseline);
    end

    corrected_signal = Spectrum - baseline;
end


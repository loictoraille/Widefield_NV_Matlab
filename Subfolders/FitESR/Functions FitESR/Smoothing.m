function [spectre_sm] = Smoothing(spectre, Smoothing)
% binning on the frequency values for a given ESR spectrum, probably useless

if Smoothing == 0
    [spectre_sm] = spectre;    
else
    for i = 1:length(spectre)
        spectre_sm(i) = mean(spectre(max([1 i-Smoothing]):min([i+Smoothing length(spectre)])));
    end
    spectre_sm = spectre_sm.';
    [spectre_sm] = spectre_sm;
end

end
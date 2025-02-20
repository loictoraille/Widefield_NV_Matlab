function spectre_rmp = RemovePositive(spectre,RemPositive)
% removing the positive parts of the spectrum to help the fit operations

spectre_rmp = spectre;  

if RemPositive == 0  
else
    threshold = mean([spectre_rmp(1:5);spectre_rmp(end-5:end)]);
    for i = 1:length(spectre_rmp)
        if spectre_rmp(i) > threshold
            spectre_rmp(i) = threshold;
        end
    end
end

end
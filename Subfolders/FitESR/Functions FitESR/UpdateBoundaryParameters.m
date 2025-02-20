
function UpdateBoundaryParameters(SPX,SPY,FitParameters)
% Defines the fit boundaries using setup taken from the FitParameters file

% ReadFitParameters;

[full_lower_bound,full_upper_bound,full_lower_bound_auto,full_upper_bound_auto] = CalculateBoundaryParameters(SPX,SPY,FitParameters);

FitParameters.full_lower_bound = full_lower_bound;
FitParameters.full_upper_bound = full_upper_bound;
FitParameters.full_lower_bound_auto = full_lower_bound_auto;
FitParameters.full_upper_bound_auto = full_upper_bound_auto;

save([getPath('Param') 'FitParameters.mat'],'FitParameters');

end
    
    

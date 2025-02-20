function [full_lower_bound_auto,full_upper_bound_auto] = RefreshBoundaryIntensities(full_lower_bound_in,full_upper_bound_in,SPY)

full_lower_bound_auto = full_lower_bound_in;
full_upper_bound_auto = full_upper_bound_in;

NumPeaks = (numel(full_lower_bound_in)-1)/3;

full_lower_bound_auto(end) = max(SPY) - full_upper_bound_in(end)*max(SPY);
full_upper_bound_auto(end) = max(SPY) - full_lower_bound_in(end)*max(SPY);

full_lower_bound_auto(1:NumPeaks) = full_lower_bound_in(1:NumPeaks)*max(SPY);
full_upper_bound_auto(1:NumPeaks) = full_upper_bound_in(1:NumPeaks)*max(SPY);


end
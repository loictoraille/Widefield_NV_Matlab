function [val_min,val_max] = ComputeSmartLimits(data,StdforRescalingTeslas)

[n,~] = size(data);

for i=1:n
    vec = rmoutliers(data(i,:));
    mean_full(i) = mean(vec,'omitnan');
    std_full(i) = std(vec,'omitnan');
end

mean_tot = mean(mean_full);
std_tot = std(std_full);

val_min = mean_tot - StdforRescalingTeslas*std_tot;
val_max = mean_tot + StdforRescalingTeslas*std_tot;

end
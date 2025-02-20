function [full_lower_bound,full_upper_bound,full_lower_bound_auto,full_upper_bound_auto] = CalculateBoundaryParameters(SPX,SPY,FitParameters)

% be careful, if I do only one calculation of bounds at beginning, I cannot set the baseline with absolute value: changes too much with 
% the baseline. Need to set a multiplier and update the value in the fit.

ReadFitParameters;

% % Baseline
% base_edge_1 = mean(SPY(1:5));
% base_edge_2 = mean(SPY(end-5:end));
% y0_mean = mean([base_edge_1,base_edge_2]);
% 
% y0_min = str2double(y0min)*min(base_edge_1,base_edge_2);
% y0_max = str2double(y0max)*max(base_edge_1,base_edge_2);
% 
% InvSPY = -SPY + max(SPY);
% Base = ones(length(SPY),1)*mean([mean(InvSPY(1:5)) mean(InvSPY(end-5:end))]);
% Corrected_Intensity = InvSPY-Base;
% 
% base_edge_1_auto = mean(Corrected_Intensity(1:5));
% base_edge_2_auto = mean(Corrected_Intensity(end-5:end));
% 
% y0_min_auto = str2double(y0min)*min(base_edge_1_auto,base_edge_2_auto);
% y0_max_auto = str2double(y0max)*max(base_edge_1_auto,base_edge_2_auto);

y0_min = str2double(y0min);
y0_max = str2double(y0max);

% Contrasts
c_min = str2double(cmin)/100;
c_max = str2double(cmax)/100;

% Intensities
int_min = c_min;
int_max = c_max;

% Middle frequencies
if strcmp(fmmin,'smart')
    fm_min = min(SPX);
else
    fm_min = str2double(fmmin);
end
if strcmp(fmmax,'smart')
    fm_max = max(SPX);
else
    fm_max = str2double(fmmax);
end

% Splittings
if strcmp(fdmin,'smart')
    fd_min = SPX(2)-SPX(1);
else
    fd_min = str2double(fdmin);
end
if strcmp(fmmax,'smart')
    fd_max = max(SPX)-min(SPX);
else
    fd_max = str2double(fdmax);
end

% Frequency positions
if strcmp(fmmin,'smart') && strcmp(fmmax,'smart') && strcmp(fdmin,'smart') &&strcmp(fdmax,'smart')
    pos_min = SPX(1);
    pos_max = SPX(end);
else
    pos_min = fm_min-fd_max;
    pos_max = fm_max+fd_max;
end

% Widths
fw_min = str2double(fwmin);
fw_max = str2double(fwmax);


% Duplicate taking the number of peaks into account
lb_c = []; lb_fm = []; lb_fd = []; lb_fw = [];ub_c = []; ub_fm = []; ub_fd = []; ub_fw = [];
lba_i = []; lba_p = []; lba_w = []; uba_i = []; uba_p = []; uba_w = [];
for i=1:NumPeaks
    lb_c = [lb_c c_min];
    lb_fw = [lb_fw fw_min];
    lba_i = [lba_i int_min];
    lba_p = [lba_p pos_min];
    lba_w = [lba_w fw_min];
    
    ub_c = [ub_c c_max];
    ub_fw = [ub_fw fw_max];
    uba_i = [uba_i int_max];
    uba_p = [uba_p pos_max];
    uba_w = [uba_w fw_max];
end

for i=1:NumComp    
    lb_fm = [lb_fm fm_min];
    lb_fd = [lb_fd fd_min];
    ub_fm = [ub_fm fm_max];
    ub_fd = [ub_fd fd_max];
end

clear('full_lower_bound','full_upper_bound','full_lower_bound_auto','full_upper_bound_auto');

full_lower_bound = [lb_c lb_fd lb_fm lb_fw y0_min];
full_upper_bound = [ub_c ub_fd ub_fm ub_fw y0_max];
full_lower_bound_auto = [lba_i lba_p lba_w y0_min];
full_upper_bound_auto = [uba_i uba_p uba_w y0_max];

end
function [X, Y, data_idx_all, fdss_post_data_zone, qtm_data_zone] = pre_process_fdss_data(fdss_data, qtm_data, fdss_fs, cutoff_freq, filter_order, theta_type, i_start_all, i_end_all)
    % Define starting and ending portions
    i_zone = i_start_all:i_end_all;

    % Filter raw Data
    fdss_post_data = filter_fdss_data(fdss_data, cutoff_freq, filter_order, fdss_fs);

    % Extract filtered data of the desired zone defined above
    fdss_post_data_zone = fdss_post_data(i_zone,:); 
    
    % Extract output data of the desired zone defined above
    qtm_data_zone = qtm_data(i_zone,:);
    
    % Define data index (for plotting purposes)
    data_idx_all = linspace(i_start_all, i_end_all, i_end_all - i_start_all + 1);

    % Compute Mx, My 
    d1 = 0.19; d2 = 0.08; d3 = 0.19; % distances in meters
    [Mx, My, Mz] = compute_moments(fdss_post_data_zone, d1, d2, d3);
    
%     delta_f = compute_diff_dsensor(fdss_post_data_zone);
    
    % Define X and Y for regression
    if strcmp(theta_type, 'theta_x') == 1
        X = Mx; % For theta_y, X = Mx 
        Y = qtm_data(i_zone,3); % For theta_y, Y = qtm_data(:,2) 
    elseif strcmp(theta_type, 'theta_y') == 1
        X = My;
        Y = qtm_data(i_zone,2);
    elseif strcmp(theta_type, 'theta_z') == 1
        X = Mz;
        Y = qtm_data(i_zone,1);
    end
end
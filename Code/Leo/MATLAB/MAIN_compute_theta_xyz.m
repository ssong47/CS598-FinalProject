%% Load Data 
% Go to proper path
cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB'
addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));
clc; clear; close all;


% Training Data
n_trial = 14;
date = '11_11_2020';
fdss = load(strcat('fcss_processed_leo_test',num2str(n_trial),'_',date,'.mat'));
fdss_data = cell2mat(fdss.fdss_output(2:end,:));

qtm = load(strcat('qtm_processed_leo_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(2:end,:));

% Validation Data
val_n_trial = 24; 
val_date = '11_15_2020';
val_fdss = load(strcat('fcss_processed_leo_test',num2str(val_n_trial),'_',val_date,'.mat'));
val_fdss_data = cell2mat(val_fdss.fdss_output(2:end,:));


val_qtm = load(strcat('qtm_processed_leo_test',num2str(val_n_trial),'_',val_date,'.mat'));
val_qtm_data = cell2mat(val_qtm.qtm_output(2:end,:));

theta_type = 'theta_x';


%% Preprocess Data
% Training Data
[N, D] = size(fdss_data);
i_start = 1;
i_end = N;
fdss_fs = 25;  cutoff_freq = 1;  filter_order = 4;
[X, Y, data_idx, fdss_post_data, qtm_data_zone] = pre_process_fdss_data...
                                (fdss_data, qtm_data, fdss_fs, cutoff_freq, filter_order, theta_type, i_start, i_end);

[theta_x, theta_y, theta_z] = get_theta_xyz(qtm_data_zone); %for plotting purposes


% Validation Data
[val_N, val_D] = size(val_fdss_data);
val_i_start = 1;
val_i_end = val_N;
fdss_fs = 25;  cutoff_freq = 1;  filter_order = 4; 
[val_X, val_Y, val_data_idx, val_fdss_post_data, val_qtm_data_zone] = pre_process_fdss_data...
                                (val_fdss_data, val_qtm_data, fdss_fs, cutoff_freq, filter_order, theta_type, val_i_start, val_i_end);

[val_theta_x, val_theta_y, val_theta_z] = get_theta_xyz(val_qtm_data_zone); %for plotting purposes


%% Checking Preprocessed Data 
% plot_preprocessed_data(data_idx, X, Y)
% plot_preprocessed_data(val_data_idx, val_X, val_Y)



%% Train Data (Perform Regression)
show_other_status = 1;
[Yp, mdl] = perform_regression(X, Y); %mdl is a MATLAB object that contains regression info
mdl_c = mdl.Coefficients.Estimate;
compare_pred_true(Yp, Y, theta_x, theta_y, theta_z, show_other_status)
residuals = mean(abs(Yp - Y));
disp(residuals)

% Validate Regression
val_Yp = mdl_c(1) + mdl_c(2) * val_X;
compare_pred_true(val_Yp, val_Y, val_theta_x, val_theta_y, val_theta_z, show_other_status);

val_residuals = mean(abs(val_Yp - val_Y));
disp(val_residuals);
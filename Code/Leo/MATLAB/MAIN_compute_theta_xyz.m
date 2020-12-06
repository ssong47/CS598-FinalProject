%% Load Data 
% Go to proper path
cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB'
addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));
clc; clear; close all;


save_status = -1;

% Training Data
n_trial = 14;
date = '11_11_2020';
fdss = load(strcat('fcss_processed_leo_test',num2str(n_trial),'_',date,'.mat'));
fdss_data = cell2mat(fdss.fdss_output(2:end,:));

qtm = load(strcat('qtm_processed_leo_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(2:end,:));

% Validation Data
val_n_trial = 35; 
val_date = '11_25_2020';
val_fdss = load(strcat('fcss_processed_leo_test',num2str(val_n_trial),'_',val_date,'.mat'));
val_fdss_data = cell2mat(val_fdss.fdss_output(2:end,:));


val_qtm = load(strcat('qtm_processed_leo_test',num2str(val_n_trial),'_',val_date,'.mat'));
val_qtm_data = cell2mat(val_qtm.qtm_output(2:end,:));

depth_vid_filename = strcat('depth_processed_leo_test', num2str(val_n_trial), '.avi');

theta_type = 'theta_y';


%% Preprocess Data
% Training Data
[N, D] = size(fdss_data);
i_start = 1;
i_end = N;
fdss_fs = 60;  cutoff_freq = 1;  filter_order = 4;
[X, Y, data_idx, fdss_post_data, qtm_data_zone] = pre_process_fdss_data...
                                (fdss_data, qtm_data, fdss_fs, cutoff_freq, filter_order, theta_type, i_start, i_end);

[theta_x, theta_y, theta_z] = get_theta_xyz(qtm_data_zone); %for plotting purposes


% Validation Data
[val_N, val_D] = size(val_fdss_data);
val_i_start = 1;
val_i_end = val_N;
fdss_fs = 60;  cutoff_freq = 1;  filter_order = 4; 
[val_X, val_Y, val_data_idx, val_fdss_post_data, val_qtm_data_zone] = pre_process_fdss_data...
                                (val_fdss_data, val_qtm_data, fdss_fs, cutoff_freq, filter_order, theta_type, val_i_start, val_i_end);

[val_theta_x, val_theta_y, val_theta_z] = get_theta_xyz(val_qtm_data_zone); %for plotting purposes


%% Checking Preprocessed Data 
% plot_preprocessed_data(data_idx, X, Y)
% plot_preprocessed_data(val_data_idx, val_X, val_Y)



%% Train Data (Perform Regression)
show_other_status = 1;
[Yp, val_Yp] = regress_data(X, Y, theta_x, theta_y, theta_z,...
                      val_X, val_Y, val_theta_x, val_theta_y,val_theta_z,... 
                      show_other_status, theta_type, fdss_fs);

%% Verify video + qtm data + fcss data
[depth_obj, depth_frames, depth_mov] = process_video(depth_vid_filename, 0, 0, 0,0, 'all');

vid_fs = fdss_fs;
verify_all(val_Yp, depth_frames, depth_mov , val_qtm_data, vid_fs, theta_type)

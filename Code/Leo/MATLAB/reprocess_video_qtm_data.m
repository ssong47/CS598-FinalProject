%% Go to proper path
cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB'
addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));
clc; clear; close all;

%% Load data
% trial info
n_trial = 27;
date = '11_19_2020';

% load depth video
depth_vid_filename = strcat('depth_processed_leo_test',num2str(n_trial),'.avi');
depth_video = VideoReader(depth_vid_filename);
vid_frames = read(depth_video, [1 depth_video.NumFrames]);
num_frames = size(vid_frames,4);

save_status = 1;
save_video_status = 1; 
save_folder = strcat('C:\Users\77bis\Box\CS598 - Final Project\Preliminary Data v5\Test_Subject_Leo\test', num2str(n_trial),'\');
depth_vid_save_filename = strcat(save_folder, 'depth_processed2_leo_test', num2str(n_trial), '.avi');
qtm_txt_save_file = strcat(save_folder,'qtm_processed2_leo_test', num2str(n_trial), '_', date ,'.txt');
qtm_mat_save_file = strcat(save_folder,'qtm_processed2_leo_test', num2str(n_trial), '_', date ,'.mat');



% load qtm data 
qtm = load(strcat('qtm_processed_leo_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(2:end,:));
qtm_theta_x = qtm_data(:,3);
qtm_theta_y = qtm_data(:,2);
qtm_theta_z = qtm_data(:,1);

% create time index
fs = 30;
time_idx = linspace(0, (length(qtm_data) - 1) / fs, length(qtm_data));

% offset value
i_offset = 45;


%% Saving Video
if save_video_status == 1
    extracted_depth_video = extract_frames(depth_vid_filename, 1, num_frames - i_offset);
    
    depth_new_video = VideoWriter(depth_vid_save_filename);
    open(depth_new_video)
    writeVideo(depth_new_video, extracted_depth_video);
    close(depth_new_video)
end


%% saving qtm data
if save_status == 1
    new_qtm = qtm_data(i_offset:end,:);
    qtm_header = {'Torso Twist Angle (deg)','Lean Forward/Backwards Angle (deg)', 'Lean Left/Right Angle (deg)'};
    qtm_output = [qtm_header; num2cell(new_qtm)];

    % Saving text file
    writecell(qtm_output, qtm_txt_save_file)

    % Saving mat file
    save(qtm_mat_save_file, 'qtm_output');
end
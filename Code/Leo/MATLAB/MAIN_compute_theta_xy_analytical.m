clear all; clc; close all;

% Adding path to appropriate location
cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB'
addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));

% Make list of subjects for data analysis
subjects = {'cz','cz','leo','leo','yc','yc'};
n_trial = [1,2,33,35,1,3];
date = {'12_2_2020','12_11_2020','11_25_2020','11_25_2020','12_2_2020','12_11_2020'};
i_start = 1;
i_end = -1;
seat_lr_angle = 0;
seat_fb_angle = 0;
plot_show = 1;
mae_x = zeros(length(n_trial),1);
mae_y = zeros(length(n_trial),1);


for i_test = 1:length(subjects)
    disp(subjects{i_test});
    [mae_x(i_test), mae_y(i_test)] = compute_theta_xy_analytical(subjects{i_test}, n_trial(i_test), date{i_test},...
                                           seat_fb_angle, seat_lr_angle,...
                                           i_start, i_end,...
                                           plot_show);                  
end
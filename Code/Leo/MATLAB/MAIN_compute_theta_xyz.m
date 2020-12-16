%% Load Data 
% Go to proper path
cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB'
addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));
clc; clear; close all;


save_status = -1;

% Training Data
n_trial = 35; %14
subject = 'leo'; %leo
date = '11_25_2020'; %11_11_2020
weight = 67;
height = 174;
fdss = load(strcat('fcss_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
i_start = 800; %300;
i_end = length(fdss.fdss_output);
i_end = 27054;
fdss_data = cell2mat(fdss.fdss_output(i_start:i_end,:));

qtm = load(strcat('qtm_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(i_start:i_end,:));

i_subject = 'leo'; 
i_trial = 41; 
date = '12_14_2020'; 
theta_type = 'theta_y'; 
show_plot = 1;
weight = 70; 
height = 170; 
val_residual = regress_batch_data(i_subject, i_trial, date, weight,...
                                         theta_type, fdss_data, qtm_data, show_plot);
                                     
disp(val_residual)
%% Batch Processing
val_residuals = [];
theta_type = 'theta_x';
show_plot = -1;
for subject = {'cz', 'yc', 'leo'}
   i_subject = subject{1};
   if strcmp(subject{1}, 'cz') == 1
      trials = [1,2];
      date = {'12_2_2020', '12_11_2020'};
      weight = 61;
      height = 180;
   elseif strcmp(subject{1}, 'yc') == 1
      trials = [1,3]; 
      date = {'12_2_2020', '12_11_2020'};
      weight = 70;
      height = 170;
   elseif strcmp(subject{1}, 'leo') == 1
      trials = [32,35]; 
      date = {'11_25_2020', '11_25_2020'};
      weight = 67;
      height = 174;
   end
   
   for i_trial = 1:length(trials)
       val_residual = regress_batch_data(i_subject, trials(i_trial), date{i_trial},weight,...
                                         theta_type, fdss_data, qtm_data, show_plot);
       val_residuals = [val_residuals; val_residual];
   end
end
disp('Validation Residuals are: ')
disp(val_residuals)
disp(mean(val_residuals))
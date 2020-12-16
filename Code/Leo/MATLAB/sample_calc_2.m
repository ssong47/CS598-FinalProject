%% Load Data 
% Go to proper path
cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB'
addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));
clc; clear; close all;


save_status = -1;
weight_all = [];
height_all = [];
qtm_all = [];
Mx_all = [];
My_all = [];
Mz_all = [];

% Training Data
n_trial = 35; %14
subject = 'leo'; %leo
date = '11_25_2020'; %11_11_2020
fdss = load(strcat('fcss_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
i_start = 800; %300;
i_end = length(fdss.fdss_output);
i_end = 27054;
fdss_data = cell2mat(fdss.fdss_output(i_start:i_end,:));
fdss_all = [fdss_data];
fdss_post_data = filter_fdss_data(fdss_data, 1, 4, 60);
[Mx, My, Mz] = compute_moments(fdss_post_data, 0.19, 0.08, 0.19);
weight = 67;
height = 174;
Mx_all = [Mx_all; Mx/(weight * height)];
My_all = [My_all; My/(weight * height)];
Mz_all = [Mz_all; Mz/(weight * height)];
weight = 67 * ones(length(fdss_data), 1);
weight_all = [weight];
height = 174 * ones(length(fdss_data), 1);
height_all = [height];

qtm = load(strcat('qtm_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(i_start:i_end,:));
qtm_all = [qtm_data];


% Training Data
n_trial = 1; %14
subject = 'cz'; %leo
date = '12_2_2020'; %11_11_2020
fdss = load(strcat('fcss_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
i_start = 2; %300;
i_end = length(fdss.fdss_output);
% i_end = 27054;
fdss_data = cell2mat(fdss.fdss_output(i_start:i_end,:));
fdss_all = [fdss_all ; fdss_data];
fdss_post_data = filter_fdss_data(fdss_data, 1, 4, 60);
[Mx, My, Mz] = compute_moments(fdss_post_data, 0.19, 0.08, 0.19);
weight = 60;
height = 180;
Mx_all = [Mx_all; Mx/(weight * height)];
My_all = [My_all; My/(weight * height)];
Mz_all = [Mz_all; Mz/(weight * height)];
weight = 60 * ones(length(fdss_data), 1);
weight_all = [weight_all; weight];
height = 180 * ones(length(fdss_data), 1);
height_all = [height_all; height];

qtm = load(strcat('qtm_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(i_start:i_end,:));
qtm_all = [qtm_all; qtm_data];

% Training Data
n_trial = 1; %14
subject = 'yc'; %leo
date = '12_2_2020'; %11_11_2020
fdss = load(strcat('fcss_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
i_start = 2; %300;
i_end = length(fdss.fdss_output);
% i_end = 27054;
fdss_data = cell2mat(fdss.fdss_output(i_start:i_end,:));
fdss_all = [fdss_all ; fdss_data];
fdss_post_data = filter_fdss_data(fdss_data, 1, 4, 60);
[Mx, My, Mz] = compute_moments(fdss_post_data, 0.19, 0.08, 0.19);
weight = 72;
height = 170;
Mx_all = [Mx_all; Mx/(weight * height)];
My_all = [My_all; My/(weight * height)];
Mz_all = [Mz_all; Mz/(weight * height)];
weight = 72 * ones(length(fdss_data), 1);
weight_all = [weight_all; weight];
height = 170 * ones(length(fdss_data), 1);
height_all = [height_all; height];

qtm = load(strcat('qtm_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(i_start:i_end,:));
qtm_all = [qtm_all; qtm_data];


X = Mx_all;
Y = qtm_all(:,3);
mdl = fitlm(X, Y, 'linear');

ypred = predict(mdl, X);
figure()
plot(ypred)
hold on
plot(Y)
legend('pred','truth')

avg_error = abs(ypred - Y);
disp(mean(avg_error))



% 
% 
% X = [Mx_all, weight_all, height_all];
% Y = qtm_all(:,3);
% mdl = fitlm(X, Y);
% 
% ypred = predict(mdl, X);
% figure()
% plot(ypred)
% hold on
% plot(Y)
% legend('pred','truth')
% 
% avg_error = abs(ypred - Y);
% disp(mean(avg_error))



%%
% Training Data
n_trial = 31; %14
subject = 'leo'; %leo
date = '11_24_2020'; %11_11_2020
fdss = load(strcat('fcss_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
i_start = 2; %300;
i_end = length(fdss.fdss_output);
fdss_data = cell2mat(fdss.fdss_output(i_start:i_end,:));
fdss_post_data = filter_fdss_data(fdss_data, 1, 4, 60);
[Mx, My, Mz] = compute_moments(fdss_post_data, 0.19, 0.08, 0.19);
weight = 67;
height = 174;
val_Mx = Mx./(weight * height);
val_My = My./(weight * height);
weight = 70 * ones(length(fdss_data), 1);
height = 170 * ones(length(fdss_data), 1);

qtm = load(strcat('qtm_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(i_start:i_end,:));

X_val = val_Mx;
Y_val = qtm_data(:,3);

ypred_val = predict(mdl, X_val);

figure()
plot(ypred_val)
hold on
plot(Y_val)
legend('pred','truth')

avg_error = abs(ypred_val - Y_val);
disp(mean(avg_error))

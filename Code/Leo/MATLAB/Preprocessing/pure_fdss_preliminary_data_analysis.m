
cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB\Preprocessing\'
addpath(genpath("C:\Users\77bis\Desktop\CS598-FinalProject\"))

clc; clear all;

time_start = 44;
time_end = 71;

%% Load Qualisys (QTM) Data
qtm_filename = 'qtm_test1_10_11_2020.mat';
load(qtm_filename);

qtm_marker_label = test1_10_11_2020.Trajectories.Labeled.Labels;
qtm_marker_data = test1_10_11_2020.Trajectories.Labeled.Data;

n_labels = length(qtm_marker_label); 
n_data_qtm = length(qtm_marker_data(1,1,:));

qtm_fs = 1/100;
qtm_time = linspace(0, n_data_qtm * qtm_fs, n_data_qtm);
qtm_start_sample = time_start * (1/qtm_fs);
qtm_end_sample = time_end * (1/qtm_fs);
%% Define Origin 
origin = {};
i_c = 1;
for i = 17:20
    origin{i_c} = reshape(qtm_marker_data(i, 1:3, :), n_data_qtm, 3);
    i_c = i_c + 1;
end

%% Define Seat Plane
seat_data = {};
seat_plane = {};

for i=1:4
    for j=1:n_data_qtm
       seat_data{i}(j,:) = qtm_marker_data(i, 1:3, j); 
    end
end

seat_normal = [];

for i = 1:n_data_qtm
    cross_val = cross(seat_data{1}(i,:) - seat_data{2}(i,:) , seat_data{1}(i,:) - seat_data{3}(i,:));
    seat_normal(i,:) = -cross_val / norm(cross_val);
end

seat_center = [(seat_data{1}(:,1) + seat_data{3}(:,1))/2,...
               (seat_data{1}(:,2) + seat_data{3}(:,2))/2,...
               (seat_data{1}(:,3) + seat_data{3}(:,3))/2 ];

%% Define Backrest Plane
backrest_data = {};
backrest_plane = {};
i_c = 1;
for i = 5:8
    for j = 1:n_data_qtm
       backrest_data{i_c}(j,:) = qtm_marker_data(i, 1:3, j); 
    end
    i_c = i_c + 1;
end

backrest_normal = [];

for i = 1:n_data_qtm
    cross_val = cross(backrest_data{1}(i,:) - backrest_data{2}(i,:), backrest_data{1}(i,:) - backrest_data{3}(i,:));
    backrest_normal(i,:) = cross_val / norm(cross_val);
end

backrest_center = [(backrest_data{1}(:,1) + backrest_data{3}(:,1))/2,...
               (backrest_data{1}(:,2) + backrest_data{3}(:,2))/2,...
               (backrest_data{1}(:,3) + backrest_data{3}(:,3))/2 ];




%% Define Trunk Plane (Shoulders + Clav or C7 or T10)
trunk_data = {};
trunk_plane = {};
i_c = 1;
for i = [9,10,11,12,15,16]
    for j = 1:n_data_qtm
       trunk_data{i_c}(j,:) = qtm_marker_data(i, 1:3, j); 
    end
    i_c = i_c + 1;
end

trunk_normal = [];

for i = 1:n_data_qtm
    cross_val = cross(trunk_data{1}(i,:) - trunk_data{2}(i,:), trunk_data{1}(i,:) - trunk_data{6}(i,:));
    trunk_normal(i,:) = cross_val / norm(cross_val);
end

trunk_center = [(trunk_data{1}(:,1) + trunk_data{2}(:,1) + trunk_data{6}(:,1))/3,...
               (trunk_data{1}(:,2) + trunk_data{2}(:,2) + trunk_data{6}(:,2))/3,...
               (trunk_data{1}(:,3) + trunk_data{2}(:,3) + trunk_data{6}(:,3))/3];


%% Compute Angles in 3D (projected angles)
ref_x = zeros(n_data_qtm,3);
ref_y = zeros(n_data_qtm,3);
ref_z = zeros(n_data_qtm,3);

proj_x_val = zeros(n_data_qtm,1);
proj_y_val = zeros(n_data_qtm,1);
proj_z_val = zeros(n_data_qtm,1);

proj_x = zeros(n_data_qtm,3);
proj_y = zeros(n_data_qtm,3);
proj_z = zeros(n_data_qtm,3);

angle_xy = zeros(n_data_qtm,1);
angle_xz = zeros(n_data_qtm,1);
angle_yz = zeros(n_data_qtm,1);


for i = 1:n_data_qtm
    ref_x(i,:) = (seat_data{2}(i,:) - seat_data{3}(i,:)) / norm(seat_data{2}(i,:) - seat_data{3}(i,:));
    ref_y(i,:) = (seat_data{1}(i,:) - seat_data{2}(i,:)) / norm(seat_data{1}(i,:) - seat_data{2}(i,:)); 
    ref_z(i,:) = seat_normal(i,:);

    proj_x_val(i) = dot(trunk_normal(i,:), ref_x(i,:));
    proj_y_val(i) = dot(trunk_normal(i,:), ref_y(i,:));
    proj_z_val(i) = dot(trunk_normal(i,:), ref_z(i,:));
    
    proj_x(i,:) = proj_x_val(i) * ref_x(i,:);
    proj_y(i,:) = proj_y_val(i) * ref_y(i,:);
    proj_z(i,:) = proj_z_val(i) * ref_z(i,:);
    
    angle_xy(i) = atan2d(proj_y_val(i,:) , proj_x_val(i,:));
    angle_xz(i) = atan2d(proj_z_val(i,:) , proj_x_val(i,:));
    angle_yz(i) = atand(proj_y_val(i,:) / proj_z_val(i,:));
end

qtm_angle_twist = angle_xy;
qtm_angle_leanfr = angle_xz;
qtm_angle_leanlr = angle_yz;

%% Plotting Qualisys Data
alpha_val = 0.5;
figure(1)
for i = 1:4
%     a = scatter3(origin{i}(1,1), origin{i}(1,2), origin{i}(1,3), 'ko', 'filled');
%     hold on;
    b = scatter3(seat_data{i}(1,1), seat_data{i}(1,2), seat_data{i}(1,3), 'ko','filled');
    hold on;
    c = scatter3(backrest_data{i}(1,1), backrest_data{i}(1,2), backrest_data{i}(1,3), 'ko','filled');
end

for i = 1:6
    d = scatter3(trunk_data{i}(1,1), trunk_data{i}(1,2), trunk_data{i}(1,3), 'ro','filled');
end
e = scatter3(seat_center(1,1), seat_center(1,2), seat_center(1,3), 'ko', 'filled');
f = scatter3(backrest_center(1,1), backrest_center(1,2), backrest_center(1,3), 'ko', 'filled');


seat_plot_1 = [seat_data{1}(1,:)' seat_data{2}(1,:)' seat_data{3}(1,:)'];
seat_plot_2 = [seat_data{3}(1,:)' seat_data{4}(1,:)' seat_data{1}(1,:)'];
g = fill3(seat_plot_1(1,:), seat_plot_1(2,:), seat_plot_1(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);
h = fill3(seat_plot_2(1,:), seat_plot_2(2,:), seat_plot_2(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);

backrest_plot_1 = [backrest_data{1}(1,:)' backrest_data{2}(1,:)' backrest_data{3}(1,:)'];
backrest_plot_2 = [backrest_data{3}(1,:)' backrest_data{4}(1,:)' backrest_data{1}(1,:)'];
i = fill3(backrest_plot_1(1,:), backrest_plot_1(2,:), backrest_plot_1(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);
j = fill3(backrest_plot_2(1,:), backrest_plot_2(2,:), backrest_plot_2(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);

trunk_plot_1 = [trunk_data{1}(1,:)' trunk_data{2}(1,:)' trunk_data{6}(1,:)'];
fill3(trunk_plot_1(1,:), trunk_plot_1(2,:), trunk_plot_1(3,:), 'r', 'EdgeColor', 'none', 'facealpha', alpha_val);


amp = 1000;
quiver3(seat_center(1,1), seat_center(1,2), seat_center(1,3),...
        seat_normal(1,1) * amp, seat_normal(1,2) * amp, seat_normal(1,3) * amp, 'k-');

quiver3(trunk_center(1,1), trunk_center(1,2), trunk_center(1,3),...
        trunk_normal(1,1) * amp, trunk_normal(1,2) * amp, trunk_normal(1,3) * amp, 'r-');

% 
% quiver3(seat_center(1,1), seat_center(1,2), seat_center(1,3),...
%         trunk_normal(1,1) * amp, trunk_normal(1,2) * amp, trunk_normal(1,3) * amp, 'r-');

quiver3(seat_center(1,1), seat_center(1,2), seat_center(1,3),...
        ref_x(1,1) * amp, ref_x(1,2) * amp, ref_x(1,3) * amp, 'k-');

quiver3(seat_center(1,1), seat_center(1,2), seat_center(1,3),...
        ref_y(1,1) * amp, ref_y(1, 2) * amp, ref_y(1,3) * amp, 'k-');
% 
% quiver3(seat_center(1,1), seat_center(1,2), seat_center(1,3),...
%         proj_x(1,1) * amp, proj_x(1,2) * amp, proj_x(1,3) * amp, 'g-');
% 
% quiver3(seat_center(1,1), seat_center(1,2), seat_center(1,3),...
%         proj_y(1,1) * amp, proj_y(1,2) * amp, proj_y(1,3) * amp, 'g-');
%     
% quiver3(seat_center(1,1), seat_center(1,2), seat_center(1,3),...
%         proj_z(1,1) * amp, proj_z(1,2) * amp, proj_z(1,3) * amp, 'g-');
% %     
axis equal
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');


%% Load FDSS Data
fdss_filename = 'fdss_test1_10_11_2020.txt';
fid = fopen(fdss_filename,'r');
raw_data={};    % all the collected raw data string from serial monitor
test_start_line = fgetl(fid);    
line_counter = 1;
fdss_fs = 1/25;
fdss_time_lag = 8;
%Find the lines where calibration and test data starts
while ischar(test_start_line)       % Start reading from raw text file 
    test_start_line = fgetl(fid);
    raw_data{end + 1,1} = test_start_line;
    line_counter = line_counter + 1; 
end
fclose(fid);

%Extracting Data from Raw Data
fdss_start_index = (fdss_time_lag) * (1/fdss_fs);
fdss_start_sample = time_start * (1/fdss_fs);
fdss_end_sample = time_end * (1/fdss_fs);

raw_full_data = raw_data(fdss_start_index:end-10);
str_full_data = raw_full_data(~cellfun('isempty',raw_full_data)); % remove empty data strings
full_data  = regexp(str_full_data , '\t', 'split');
fdss_data = cellfun(@str2num,vertcat(full_data{:}));

fdss_time_raw = fdss_data(:,1) * 1e-3;
fdss_time_start = fdss_time_raw(1);
fdss_time = fdss_time_raw - fdss_time_start;

n_data_fdss = length(fdss_time);



figure(3)
yyaxis left
plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data(fdss_start_sample: fdss_end_sample,8),...
    '-', 'linewidth', 1)
hold on;

plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data(fdss_start_sample: fdss_end_sample,9),...
    'b-', 'linewidth', 1);
ylabel('distance (mm)');
ylim([0 500]);

yyaxis right
plot(qtm_time(qtm_start_sample:qtm_end_sample), qtm_angle_twist(qtm_start_sample:qtm_end_sample), '-', 'linewidth', 2);
xlabel('time (s)');
ylabel('angle (deg)');
legend('Distance Sensor Left','Distance Sensor Right', 'Angle Twist from MoCap')
ylim([-60 200]);
grid on;




%% Map FDSS Data to Qualisys (REGRESSION)
input_x = [];
n_dim = 2;


cutoff_freq = 1;                      
filter_order = 4; 
[bLP, aLP] = butter(filter_order, cutoff_freq / ((1/fdss_fs) /2));
filt_data_1 = filtfilt(bLP, aLP, fdss_data (:, 8));
filt_data_2 = filtfilt(bLP, aLP, fdss_data (:, 9));

figure(4)
yyaxis left
plot(fdss_time(fdss_start_sample: fdss_end_sample), filt_data_1(fdss_start_sample: fdss_end_sample),...
    '-', 'linewidth', 1)
hold on;

plot(fdss_time(fdss_start_sample: fdss_end_sample), filt_data_2(fdss_start_sample: fdss_end_sample),...
    'b-', 'linewidth', 1);
ylabel('distance (mm)');
ylim([0 500]);

yyaxis right
plot(qtm_time(qtm_start_sample:qtm_end_sample), qtm_angle_twist(qtm_start_sample:qtm_end_sample), '-', 'linewidth', 2);
xlabel('time (s)');
ylabel('angle (deg)');
legend('Distance Sensor Left','Distance Sensor Right', 'Angle Twist from MoCap')
ylim([-60 200]);
grid on;


filt_data_1 = filtfilt(bLP, aLP, fdss_data (fdss_start_sample:fdss_end_sample, 8));
filt_data_2 = filtfilt(bLP, aLP, fdss_data (fdss_start_sample:fdss_end_sample, 9));

for i = 1:(n_dim + 1)
    if (i == 1)
        input_x(:,i) = interp( filt_data_1 , 4);
    elseif (i == 2)
        input_x(:,i) = interp( filt_data_2 , 4);
    elseif (i == 3)
        input_x(:,i) = 1;
    end
end

% output_y = qtm_angle_twist(qtm_start_sample : (qtm_start_sample + (length(input_x(:,1))) - 1) );
output_y = qtm_angle_twist(qtm_start_sample : (qtm_start_sample + (length(input_x(:,1))) - 1) );

map_reg = regress(output_y, input_x);
n_data_reg = length(input_x);

output_pred = input_x * map_reg;
time_pred = linspace(0, n_data_reg * (qtm_fs), n_data_reg);

figure(5)
plot(time_pred, output_pred, 'linewidth', 2);
hold on;
plot(time_pred, output_y, 'linewidth', 2);
legend('FDSS (Regression)','Angle Twist from Mocap');
xlabel('time (s)');
ylabel('angle (deg)');

fdss_start_sample = 1;
fdss_end_sample = length(fdss_time);
figure(6)
yyaxis left
plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data((fdss_start_sample: fdss_end_sample),2), 'r-','linewidth', 2)
hold on;
plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data((fdss_start_sample: fdss_end_sample),3), 'g-','linewidth', 2);
plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data((fdss_start_sample: fdss_end_sample),4), 'b-','linewidth', 2);
plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data((fdss_start_sample: fdss_end_sample),5), 'c-','linewidth', 2);
plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data((fdss_start_sample: fdss_end_sample),6), 'm-','linewidth', 2);
plot(fdss_time(fdss_start_sample: fdss_end_sample), fdss_data((fdss_start_sample: fdss_end_sample),7), 'y-','linewidth', 2);
ylabel('Load (kg)');
yyaxis right
% plot(qtm_time(qtm_start_sample:qtm_end_sample), qtm_angle_twist(qtm_start_sample:qtm_end_sample),'linewidth', 2);
xlabel('time (s)');
ylabel('angle (deg)');
% plot(qtm_time(1:qtm_end_sample), qtm_angle_leanlr(1:qtm_end_sample));
plot(qtm_time, qtm_angle_twist);
hold on;
plot(qtm_time, qtm_angle_leanfr);
plot(qtm_time, qtm_angle_leanlr);
legend('Fz1','Fz2', 'Fz3','Fx1','Fx2','Fy', 'twist', 'fr', 'lr')
grid on
set(gca,'Color','k')

% OBSERVATIONS
% Need real-time filter on IR sensor since its data is noisy
% Once filtered using butterworth, the regression seems to work well 
% 
% The seat load cells do not show promising data for torso twist
% The distance sensors becomes unreadable (too noisy) when leaning forward
% The distance sensors can measure lean FR angles 


figure(7)
plot(fdss_time, fdss_data(:,8))
hold on
plot(fdss_time, fdss_data(:,9))
plot(qtm_time, qtm_angle_twist);

%% Map FDSS Data to Qualisys (MVREG)




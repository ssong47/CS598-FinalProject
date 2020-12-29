cd 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB\Preprocessing\'
addpath(genpath("C:\Users\77bis\Desktop\CS598-FinalProject\"));
addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));

clc; clear; close all;
save_status = -1;
save_video_status = -1;
ml_status = -1;

%% Load Qualisys (QTM) Data
n_trial = 54;
date = '12_20_2020';

i_start = 900;%110; %Leo1-447, Leo2- 182, Leo 3- 132
i_end = 12060;%1396; %Leo1-2764, Leo2- 1910,Leo 3- 1627
subject = 'leo';

qtm_filename = strcat('qtm_',subject,'_test', num2str(n_trial), '_', date ,'.mat');
fdss_filename = strcat('fcss_',subject,'_load_test', num2str(n_trial), '.csv');
color_vid_filename = strcat('fcss_',subject,'_color_test', num2str(n_trial), '.avi');
depth_vid_filename = strcat('fcss_',subject,'_depth_test', num2str(n_trial), '.avi');


save_folder = strcat('C:\Users\77bis\Box\CS598 - Final Project\Preliminary Data V5 Dynamic Incline\Test_Subject_',subject,'\test', num2str(n_trial),'\');

color_vid_save_filename = strcat(save_folder, 'color_processed_',subject,'_test', num2str(n_trial), '.avi');
depth_vid_save_filename = strcat(save_folder, 'depth_processed_',subject,'_test', num2str(n_trial), '.avi');
fdss_txt_save_file = strcat(save_folder,'fcss_processed_',subject,'_test', num2str(n_trial), '_', date ,'.txt');
seat_txt_save_file = strcat(save_folder,'seat_processed_',subject,'_test', num2str(n_trial), '_', date ,'.txt');
qtm_txt_save_file = strcat(save_folder,'qtm_processed_',subject,'_test', num2str(n_trial), '_', date ,'.txt');

fdss_mat_save_file = strcat(save_folder,'fcss_processed_',subject,'_test', num2str(n_trial), '_', date ,'.mat');
seat_mat_save_file = strcat(save_folder,'seat_processed_',subject,'_test', num2str(n_trial), '_', date ,'.mat');
qtm_mat_save_file = strcat(save_folder,'qtm_processed_',subject,'_test', num2str(n_trial), '_', date ,'.mat');


if ml_status == 1
   ml_save_file = strcat(save_folder, 'ml_pred_', subject, '_test', num2str(n_trial), '.txt');
end


load(qtm_filename);


qtm_marker_label = qtm_leo_test54_12_20_2020.Trajectories.Labeled.Labels;
qtm_marker_data = qtm_leo_test54_12_20_2020.Trajectories.Labeled.Data;


n_labels = length(qtm_marker_label); 
n_data_qtm = length(qtm_marker_data(1,1,:));

qtm_fs = 1/60;
qtm_time = linspace(0, (n_data_qtm - 1) * qtm_fs, n_data_qtm);

sign_vec = -1;

%% Define Origin 
origin = {};
i_c = 1;

for i = 12:15
    for j = 1:n_data_qtm
        origin{i_c}(j,:) = qtm_marker_data(i, 1:3, j);
    end
    i_c = i_c + 1;
end

%% Define Seat Plane
seat_data = {};
seat_plane = {};
i_c = 1;


for i = 4:7
    for j=1:n_data_qtm
       seat_data{i_c}(j,:) = qtm_marker_data(i, 1:3, j); 
    end
    i_c = i_c + 1;
end

seat_normal = [];

for i = 1:n_data_qtm
    cross_val = cross(seat_data{1}(i,:) - seat_data{2}(i,:) , seat_data{1}(i,:) - seat_data{3}(i,:));
    seat_normal(i,:) = sign_vec * cross_val / norm(cross_val);
end

seat_center = [(seat_data{1}(:,1) + seat_data{3}(:,1))/2,...
               (seat_data{1}(:,2) + seat_data{3}(:,2))/2,...
               (seat_data{1}(:,3) + seat_data{3}(:,3))/2 ];

%% Compute Seat Angle
show_plot = -1;
[seat_theta_x, seat_theta_y, avg_seat_theta_x, avg_seat_theta_y] = compute_seat_angle(origin, seat_data, show_plot);

%% Define Backrest Plane
backrest_data = {};
backrest_plane = {};
i_c = 1;

for i = 8:11
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

for i = 1:3
    for j = 1:n_data_qtm
       trunk_data{i_c}(j,:) = qtm_marker_data(i, 1:3, j); 
    end
    i_c = i_c + 1;
end

trunk_normal = [];

for i = 1:n_data_qtm
    cross_val = cross(trunk_data{1}(i,:) - trunk_data{2}(i,:), trunk_data{1}(i,:) - trunk_data{3}(i,:));
    trunk_normal(i,:) = cross_val / norm(cross_val);
end

trunk_center = [(trunk_data{1}(:,1) + trunk_data{2}(:,1) + trunk_data{3}(:,1))/3,...
               (trunk_data{1}(:,2) + trunk_data{2}(:,2) + trunk_data{3}(:,2))/3,...
               (trunk_data{1}(:,3) + trunk_data{2}(:,3) + trunk_data{3}(:,3))/3];

tcenter_z_vec = zeros(n_data_qtm,3);
tcenter_y_vec = zeros(n_data_qtm,3);

for i = 1:n_data_qtm
    tcenter_z_vec(i,:) = (trunk_center(i,:) - seat_center(i,:))/ norm(trunk_center(i,:) - seat_center(i,:));
    tcenter_y_vec(i,:) = (trunk_data{1}(i,:) - trunk_data{2}(i,:))/ norm(trunk_data{1}(i,:) - trunk_data{2}(i,:));
end

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

angle_twist = zeros(n_data_qtm,1);
angle_xz = zeros(n_data_qtm,1);
angle_yz = zeros(n_data_qtm,1);

anglex = zeros(n_data_qtm,1);
angley = zeros(n_data_qtm,1);

proj_x_2 = zeros(n_data_qtm,3);
proj_y_2 = zeros(n_data_qtm,3);

t_origin = {};

for i = 1:n_data_qtm
    ref_x(i,:) = (seat_data{2}(i,:) - seat_data{3}(i,:)) / norm(seat_data{2}(i,:) - seat_data{3}(i,:));
    ref_y(i,:) = (seat_data{1}(i,:) - seat_data{2}(i,:)) / norm(seat_data{1}(i,:) - seat_data{2}(i,:)); 
    ref_z(i,:) = seat_normal(i,:);

    proj_x_val(i) = dot(tcenter_z_vec(i,:), ref_x(i,:));
    proj_y_val(i) = dot(tcenter_z_vec(i,:), ref_y(i,:));
    proj_z_val(i) = dot(tcenter_z_vec(i,:), ref_z(i,:));
    
    proj_x(i,:) = proj_x_val(i) * ref_x(i,:);
    proj_y(i,:) = proj_y_val(i) * ref_y(i,:);
    proj_z(i,:) = proj_z_val(i) * ref_z(i,:);
    
    angle_xz(i) = atan2d(proj_x_val(i) , proj_z_val(i));
    angle_yz(i) = atan2d(proj_y_val(i) , proj_z_val(i));
    
    angley(i) = atand(proj_x_val(i) / proj_z_val(i));
    anglex(i) = -atand(proj_y_val(i) / proj_z_val(i));

    Rx = [[1;0;0],[0;cosd(anglex(i));sind(anglex(i))],[0;-sind(anglex(i));cosd(anglex(i))]];
    Ry = [[cosd(angley(i));0;-sind(angley(i))],[0;1;0],[sind(angley(i));0;cosd(angley(i))]];
    Rz = eye(3);
    t_origin{i} =  Rx * Ry * Rz * [ref_x(i,:)', ref_y(i,:)', ref_z(i,:)'];

    proj_x_2_val =  dot(tcenter_y_vec(i,:) , t_origin{i}(:,1));
    proj_y_2_val =  dot(tcenter_y_vec(i,:) , t_origin{i}(:,2));

    proj_x_2(i,:) = proj_x_2_val * t_origin{i}(:,1);
    proj_y_2(i,:) = proj_y_2_val * t_origin{i}(:,2);

    angle_twist(i) = atan2d(proj_x_2_val, proj_y_2_val);

end

qtm_angle_twist = angle_twist;
qtm_angle_leanfb = angle_xz;
qtm_angle_leanlr = angle_yz;

% Create final Qualisys data 
qtm_total_data = [qtm_angle_twist, qtm_angle_leanfb, qtm_angle_leanlr];
% qtm_total_data = trunk_data{1}(:,1) - trunk_data{2}(:,1);

% plot_qtm_data()

%%
% figure(1)
% plot(qtm_angle_leanfb)
% hold on 
% plot(fdss_data(:,2))
% legend('qtm','fdss')

%% Load FDSS Data
fid = fopen(fdss_filename,'r');
raw_data={};    % all the collected raw data string from serial monitor
test_start_line = fgetl(fid);    
line_counter = 1;
fdss_fs =  qtm_fs;

%Find the lines where calibration and test data starts
while ischar(test_start_line)       % Start reading from raw text file 
    test_start_line = fgetl(fid);
    raw_data{end + 1,1} = test_start_line;
    line_counter = line_counter + 1; 
end
fclose(fid);

%Extracting Data from Raw Data
raw_full_data = raw_data(1:end-5);
str_full_data = raw_full_data(~cellfun('isempty',raw_full_data)); % remove empty data strings
full_data  = regexp(str_full_data , ',', 'split');
count = 0;
for i=1:length(full_data)
   if length(full_data{i}) ~= 7  
      full_data{i} = full_data{i-1};
   end
end

fdss_data = cellfun(@str2num,vertcat(full_data{:}));
fdss_time_sync = fdss_data(:,1);

%Obtain starting and ending index synced with Qualisys
[fdss_start, fdss_end] = fdss_find_start_end(fdss_time_sync, n_data_qtm);
n_data_fdss = fdss_end - fdss_start + 1;


%Extract FDSS data 
fdss_time = linspace(0, (n_data_fdss-1) * fdss_fs, n_data_fdss);

n_fsens = 6;
f_sens = zeros(n_data_fdss, n_fsens);
for i = 2:7
   f_sens(:,i-1) = fdss_data(fdss_start:fdss_end,i);
end

%Create processed fdss and qualisys data with time stamps and synced start/end time
qtm_total_data(isnan(qtm_total_data)) = 0;
% qtm_final_data_temp = resample(qtm_total_data, n_data_fdss, n_data_qtm);
min_two = min(n_data_fdss, n_data_qtm);
qtm_final_data_temp = qtm_total_data(1:min_two, :);
fdss_final_data_temp = fdss_data(fdss_start:(fdss_start + min_two -1), 2:end);

%%
%Truncate final data to exclude 
N = length(fdss_final_data_temp);
if i_end == -1
   i_end = N; 
end

fdss_final_data = fdss_final_data_temp(i_start:i_end,:);
qtm_final_data = qtm_final_data_temp(i_start:i_end,:);
seat_final_data = [seat_theta_x(i_start:i_end, :), seat_theta_y(i_start:i_end, :)];

%% Plotting preliminary figures
plot_i = linspace(0, (i_end - i_start), i_end - i_start+1);
lw = 1;


figure(8)
ax1 = subplot(3,1,1);
plot(plot_i, fdss_final_data(:,1));
hold on;
plot(plot_i, fdss_final_data(:,2));
plot(plot_i, fdss_final_data(:,3));
legend('Fz bottom', 'Fz left', 'Fz right')
xlabel('data index');
ylabel('force (kg)');
xlim([0 max(plot_i)]);
% ylim([0 500]);

ax2 = subplot(3,1,2);
plot(plot_i, fdss_final_data(:,4));
hold on;
plot(plot_i, fdss_final_data(:,5));
plot(plot_i, fdss_final_data(:,6));
legend('Fx left', 'Fx right', 'Fy')
xlabel('data index');
ylabel('force (kg)');
xlim([0 max(plot_i)]);

% 
% ax3 = subplot(3,1,3);
% plot(plot_i, qtm_final_data(:,1))
% hold on;
% plot(plot_i, qtm_final_data(:,2))
% plot(plot_i, qtm_final_data(:,3))
% plot(plot_i, [ml_data(:,3); 0])
% legend('twist angle', 'lean fb angle', 'lean lr angle')
% ylabel('angle (deg)');
% xlabel('data index');
% xlim([0 max(plot_i)]);
% linkaxes([ax1, ax2, ax3], 'x');
% 
% 
ax3 = subplot(3,1,3);
plot(plot_i, qtm_final_data(:,1))
hold on;
plot(plot_i, qtm_final_data(:,2))
plot(plot_i, qtm_final_data(:,3))
legend('twist angle', 'lean fb angle', 'lean lr angle')
ylabel('angle (deg)');
xlabel('data index');
xlim([0 max(plot_i)]);
ylim([-40 40]);
linkaxes([ax1, ax2, ax3], 'x');


%% Saving processed Qualisys data and FDSS data 
if save_status == 1
    fdss_header = {'Fz bottom (kg)', ...
                   'Fz left (kg)',...
                   'Fz right (kg)',...
                   'Fx left (kg)',...
                   'Fx right (kg)',...
                   'Fy (kg)'};
    fdss_output = [fdss_header; num2cell(fdss_final_data)];
    
    seat_header = {'thetaX (deg)',...
                   'thetaY (deg)'};
               
    seat_output = [seat_header; num2cell(seat_final_data)];
   
    qtm_header = {'Torso Twist Angle (deg)','Lean Forward/Backwards Angle (deg)', 'Lean Left/Right Angle (deg)'};
    qtm_output = [qtm_header; num2cell(qtm_final_data)];
    
    
    % Saving text file
    writecell(fdss_output, fdss_txt_save_file)
    writecell(seat_output, seat_txt_save_file)
    writecell(qtm_output, qtm_txt_save_file)
    
    
    % Saving mat file
    save(fdss_mat_save_file,'fdss_output');
    save(seat_mat_save_file,'seat_output');
    save(qtm_mat_save_file, 'qtm_output');
end


%% Process Video
i_offset = -75;
[depth_obj, depth_frames, depth_mov] = process_video(depth_vid_filename, fdss_start, i_start, i_end, i_offset, 'extract');
vid_fs = 1/fdss_fs;

%% Verify fcss + video + qtm data
theta_type = 'all_raw';
i_time = [0.1 , 20];
save_raw_vid = -1; 
save_raw_vid_path = 'sample.avi';
verify_video(depth_frames, depth_mov, qtm_final_data, fdss_final_data, vid_fs, theta_type, i_time, save_raw_vid, save_raw_vid_path)

%% Verify fcss + video + ml + qtm data 
if ml_status == 1
    i_time = [round(8112/60) , round(10000/60)];
    theta_type = 'all_raw';
    ml_data = importdata(ml_save_file);
    save_raw_vid = 1; 
    save_raw_vid_path = strcat(save_folder, 'all_data_',subject,'_test', num2str(n_trial), '.avi');
    verify_ml(depth_frames, depth_mov, qtm_final_data, fdss_final_data, vid_fs, theta_type, i_time, save_raw_vid, save_raw_vid_path, ml_data)
end



%% Save Video
if save_video_status == 1
    save_depth_video(depth_frames, depth_mov, depth_vid_save_filename, vid_fs)
end


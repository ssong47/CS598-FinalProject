function [mae_x, mae_y] = compute_theta_xy_analytical(subject, n_trial,date,...
                                           seat_fb_angle, seat_lr_angle,...
                                           i_start, i_end,...
                                           plot_show)
    
                                       
                                      
    subject = 'leo';
    n_trial = 55;
    date = '12_20_2020';
    i_start = 1;
    i_end = -1;
    plot_show = 1;
    close all;
    
    % Adding path to appropriate location
    addpath(genpath("C:\Users\77bis\Box\CS598 - Final Project\"));
    addpath(genpath("C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\MATLAB"));

    
    % Load force, seat, and qtm data
    fdss = load(strcat('fcss_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
    if i_end == -1
       i_end = length(fdss.fdss_output) - 1; 
    end
    fdss_data = cell2mat(fdss.fdss_output(i_start+1:i_end,:));

    seat = load(strcat('seat_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
    seat_data = cell2mat(seat.seat_output(i_start+1:i_end,:));
    
    seat_theta_x = seat_data(:,1);
    seat_theta_y = seat_data(:,2);
    
    qtm = load(strcat('qtm_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
    qtm_data = cell2mat(qtm.qtm_output(i_start+1:i_end,:));
    
    true_theta_x = qtm_data(:,3);
    true_theta_y = qtm_data(:,2);
    
    % Get subject info 
    [user_mass, user_height] = get_subject_info(subject); % in kg, cm
       
    % Get seat information 
    [seat_mass, seat_def_angle, d1, d2, d3] = get_seat_info(); % in kg, cm, cm, cm
    
    % Remove forces due to seat from the force readings
    user_force_data = remove_seat_force(fdss_data, seat_theta_y, seat_def_angle, seat_theta_x, seat_mass);
    
    % Compute moment
    [Mx, My, Mz] = compute_moments(user_force_data, d1, d2, d3);
    
    % Compute theta 
    [theta_x, theta_y] = compute_theta_analytical(seat_def_angle,...
                                                  seat_theta_y, seat_theta_x,...
                                                  user_mass, user_height,...
                                                  Mx, My);
    
    % Compute MAE 
    mae_x = mean(abs(theta_x - true_theta_x))
    mae_y = mean(abs(theta_y - true_theta_y))
   
    
    
    % Plot theta 
    if plot_show == 1
        fs = 60;
        plot_data(theta_x, theta_y, true_theta_x, true_theta_y,...
                  subject, n_trial, seat_theta_x, seat_theta_y,...
                  i_start, i_end, fs)
    end
    


end
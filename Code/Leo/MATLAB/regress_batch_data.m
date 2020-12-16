function [val_residuals] = regress_batch_data(subject, val_n_trial, val_date,weight,...
                                                theta_type, fdss_data, qtm_data, show_plot)
                                            
    disp(strcat('fcss_processed_',subject,'_test',num2str(val_n_trial),'_',val_date,'.mat'))
    
    val_fdss = load(strcat('fcss_processed_',subject,'_test',num2str(val_n_trial),'_',val_date,'.mat'));
    val_fdss_data = cell2mat(val_fdss.fdss_output(2:end,:));


    val_qtm = load(strcat('qtm_processed_',subject,'_test',num2str(val_n_trial),'_',val_date,'.mat'));
    val_qtm_data = cell2mat(val_qtm.qtm_output(2:end,:));

    depth_vid_filename = strcat('depth_processed_',subject,'_test', num2str(val_n_trial), '.avi');



    %% Preprocess Data
    % Training Data
    [N, D] = size(fdss_data);
    i_start = 1;
    i_end = N;
    fdss_fs = 60;  cutoff_freq = 1;  filter_order = 4;
%     fdss_data = normalize(fdss_data, 'norm');

    [X, Y, data_idx, fdss_post_data, qtm_data_zone] = pre_process_fdss_data...
                                    (fdss_data, qtm_data, fdss_fs, cutoff_freq, filter_order, theta_type, i_start, i_end);
    
    
    [theta_x, theta_y, theta_z] = get_theta_xyz(qtm_data_zone); %for plotting purposes


    % Validation Data
    [val_N, val_D] = size(val_fdss_data);
    val_i_start = 1;
    val_i_end = val_N;
    fdss_fs = 60;  cutoff_freq = 1;  filter_order = 4; 
    
%     val_fdss_data = normalize(val_fdss_data, 'norm');

    [val_X, val_Y, val_data_idx, val_fdss_post_data, val_qtm_data_zone] = pre_process_fdss_data...
                                    (val_fdss_data, val_qtm_data, fdss_fs, cutoff_freq, filter_order, theta_type, val_i_start, val_i_end);
    

    [val_theta_x, val_theta_y, val_theta_z] = get_theta_xyz(val_qtm_data_zone); %for plotting purposes


    %% Checking Preprocessed Data 
    % plot_preprocessed_data(data_idx, X, Y)
    % plot_preprocessed_data(val_data_idx, val_X, val_Y)



    %% Train Data (Perform Regression)
    show_other_status = 1;
    X_norm = X;
    val_X_norm = val_X;
    
    [Yp, val_Yp, val_residuals] = regress_data(X_norm, Y, theta_x, theta_y, theta_z,...
                          val_X_norm, val_Y, val_theta_x, val_theta_y,val_theta_z,... 
                          show_other_status, theta_type, fdss_fs, show_plot);

    %% Verify video + qtm data + fcss data
    % [depth_obj, depth_frames, depth_mov] = process_video(depth_vid_filename, 0, 0, 0, 0, 'all');
    % 
    % vid_fs = fdss_fs;
    % verify_all(val_Yp, depth_frames, depth_mov , val_qtm_data, vid_fs, theta_type)



end
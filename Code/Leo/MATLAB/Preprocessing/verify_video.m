function verify_video(depth_frames, mov, qtm_data, fcss_data, fs, theta_type, i_time, save_stat, save_vid_file)
    % load qtm data 
    ylabel_str_out = strcat(theta_type,'(deg)');
    ylim_range_out = [-30, 30];
    n_subplots = 2;
    if strcmp(theta_type, 'theta_x') == 1
        theta_interest = qtm_data(:,3);
    elseif strcmp(theta_type, 'theta_y') == 1
        theta_interest = qtm_data(:,2);
    elseif strcmp(theta_type, 'theta_z') == 1
        theta_interest = qtm_data(:,1);
    elseif strcmp(theta_type, 'all') == 1
        theta_interest = qtm_data;
    elseif strcmp(theta_type, 'all_raw') == 1
        force_interest = fcss_data;
        theta_interest = qtm_data;
        ylabel_str_out = strcat('\theta (^o)');
        ylabel_str_in = strcat('Force (kg)');
        ylim_range_in = [-80, 20];
        n_subplots = 3;
    end

    % create time index
    time_idx = linspace(0, (length(qtm_data) - 1) / fs, length(qtm_data));

    %% Plot and Play
    close all
    figure(1)
    set(gcf, 'Position',  [300, 400, 1600, 400])
    if strcmp(theta_type, 'all_raw') == 1
        ax1 = subplot(1, n_subplots, 1);
        curve21 = animatedline(ax1, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
        curve22 = animatedline(ax1, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
        curve23 = animatedline(ax1, 'LineWidth', 2, 'Color', [0.9290, 0.6940, 0.1250]);
        curve24 = animatedline(ax1, 'LineWidth', 2, 'Color', [0.4940, 0.1840, 0.5560]);
        curve25 = animatedline(ax1, 'LineWidth', 2, 'Color', [0.4660, 0.6740, 0.1880]);
        curve26 = animatedline(ax1, 'LineWidth', 2, 'Color', [0.3010, 0.7450, 0.9330]);    
        set(ax1, 'ylim', ylim_range_in);
        ylabel(ylabel_str_in);
        xlabel('time(s)');
        legend(ax1, 'Fz1', 'Fz2', 'Fz3', 'Fx1', 'Fx2', 'Fy');
        grid on;
    end
    
    
    ax_vid = subplot(1, n_subplots, n_subplots - 1);
    
    
    ax3 = subplot(1, n_subplots, n_subplots);
    curve11 = animatedline(ax3, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
    curve12 = animatedline(ax3, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
    curve13 = animatedline(ax3, 'LineWidth', 2, 'Color', [0.9290, 0.6940, 0.1250]);
    set(ax3, 'ylim', ylim_range_out);
    ylabel(ylabel_str_out);
    xlim_min = 0;
    xlabel('time(s)')
    t_int = 3;
    xlim_max = xlim_min + t_int;
    xlim(ax3, [xlim_min xlim_max]);
    xlim(ax1, [xlim_min xlim_max]);
    grid on;
    if (strcmp(theta_type, 'all') ~= 1) && (strcmp(theta_type, 'all_raw') ~= 1)
        legend(theta_type);
    elseif (strcmp(theta_type, 'all') == 1) || (strcmp(theta_type, 'all_raw') == 1)
        legend(ax3, '\theta_x', '\theta_y', '\theta_z');
    end
    
    
    if save_stat == 1
        myVideo = VideoWriter(save_vid_file); %open video file
        myVideo.FrameRate = 30;  %can adjust this, 5 - 10 works well for me
        open(myVideo) 

    else
        disp('not saving');
        
    end
    

    if i_time == -1
       i_start = 1;
       i_end = length(depth_frames);
    else
       i_start = i_time(1) * fs;
       i_end = i_time(2) * fs;
    end
    
    
    for i = i_start:i_end

        drawnow
        if (strcmp(theta_type, 'all') ~= 1) && (strcmp(theta_type, 'all_raw') ~= 1)
            addpoints(curve11, time_idx(i), theta_interest(i));
        elseif strcmp(theta_type, 'all') == 1
            addpoints(curve11, time_idx(i), theta_interest(i,3));
            addpoints(curve12, time_idx(i), theta_interest(i,2));
            addpoints(curve13, time_idx(i), theta_interest(i,1));
        elseif strcmp(theta_type, 'all_raw') == 1
            
            addpoints(curve11, time_idx(i), theta_interest(i,3));
            addpoints(curve12, time_idx(i), theta_interest(i,2));
            addpoints(curve13, time_idx(i), theta_interest(i,1));
            
            addpoints(curve21, time_idx(i), force_interest(i,1));
            addpoints(curve22, time_idx(i), force_interest(i,2));
            addpoints(curve23, time_idx(i), force_interest(i,3));
            addpoints(curve24, time_idx(i), force_interest(i,4));
            addpoints(curve25, time_idx(i), force_interest(i,5));
            addpoints(curve26, time_idx(i), force_interest(i,6));
        end

        if time_idx(i) > xlim_max
            xlim_min = xlim_max;
            xlim_max = xlim_min + t_int;
            set(ax1, 'xlim', [xlim_min xlim_max]);
            set(ax3, 'xlim', [xlim_min xlim_max]);
        end

        image(ax_vid, mov(i).cdata);
        pause(1/fs);
        
        if save_stat == 1
            frame = getframe(gcf); %get frame
            writeVideo(myVideo, frame);
        end

    end
    
    if save_stat == 1
        close(myVideo);
    end

end
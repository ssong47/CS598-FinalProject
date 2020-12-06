function verify_all(val_Yp, depth_frames, mov, qtm_data, fs, theta_type)
    % load qtm data 
    ylim_range = [-30, 30];
    if strcmp(theta_type, 'theta_x') == 1
        theta_interest = qtm_data(:,3);
        j = 2;
    elseif strcmp(theta_type, 'theta_y') == 1
        theta_interest = qtm_data(:,2);
        j = 1;
    elseif strcmp(theta_type, 'all') == 1
        theta_interest = qtm_data;
    end

    % create time index
    time_idx = linspace(0, (length(qtm_data) - 1) / fs, length(qtm_data));

    %% Plot and Play
    close all
    figure(1)
    set(gcf, 'Position',  [600, 100, 400, 800])
    % Setting up QTM plot
    ax1 = subplot(2,1,1);
    grid on;
    xlim_min = 0;
    curve1 = animatedline(ax1, 'LineWidth', 2, 'Color', 'r');
    curve2 = animatedline(ax1, 'LineWidth', 2, 'Color', 'g');
    
    fss_curve1 = animatedline(ax1, 'LineWidth', 2, 'Color', 'r', 'LineStyle', '--');
    fss_curve2 = animatedline(ax1, 'LineWidth', 2, 'Color', 'g', 'LineStyle', '--');
    
    t_int = 3;
    xlim_max = xlim_min + t_int;
    
    if strcmp(theta_type, 'all') ~= 1
            legend(theta_type);
    else

        legend([curve1, fss_curve1, curve2, fss_curve2],{'\theta_Y', '\theta_Y FSS', '\theta_X', '\theta_X FSS'});
    end

    
    axis([ax1], [xlim_min xlim_max ylim_range]);
    xlabel([ax1], ['Time(s)']);
    ylabel([ax1], ['\theta(^o)']);
    
    
    
    % Setting up video 
    ax3 = subplot(2,1,2);

    
    for i = 1:length(depth_frames)

        drawnow
        if strcmp(theta_type, 'all') ~= 1
            addpoints(curve1, time_idx(i), theta_interest(i));
            addpoints(fss_curve1, time_idx(i), val_Yp(i));
        else
            addpoints(curve1, time_idx(i), theta_interest(i,2));
            addpoints(fss_curve1, time_idx(i), val_Yp{1}(i));
            
            addpoints(curve2, time_idx(i), theta_interest(i,3));
            addpoints(fss_curve2, time_idx(i), val_Yp{2}(i));
        end

        if time_idx(i) > xlim_max
            xlim_min = xlim_max;
            xlim_max = xlim_min + t_int;
            axis([ax1], [xlim_min xlim_max ylim_range]);
        end

        
        
        image(ax3, mov(i).cdata);
        pause(1/fs * 0.0001);

    end



end
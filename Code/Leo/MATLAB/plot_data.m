function plot_data(theta_x, theta_y, true_theta_x, true_theta_y, ...
                   subject, n_trial, seat_theta_x, seat_theta_y,...
                   i_start, i_end, fs)
    if i_end == -1
       i_end = length(theta_x); 
    end
    
    if i_start == 1
        i_start = 0;
    end
    
    x = linspace(i_start/fs, (i_end - i_start)/fs, (i_end - i_start - 1));
    
    
    figure()
    plot(x, theta_x)
    hold on
    plot(x, true_theta_x);
    legend('pred', 'truth');
    title_str = strcat('[',subject,' ', num2str(n_trial), '] \theta_x ',...
                        'with seat fb angle = ', num2str(0),...
                        ', seat lr angle = ', num2str(0));
    title(title_str);
    grid on;
    ylim([-30 30]);
    ylabel('\theta_x (^o)');
    xlabel('time (s)');
    
    
    figure()
    plot(x, theta_y)
    hold on
    plot(x, true_theta_y);
    legend('pred', 'truth');
    title_str = strcat('[',subject,' ', num2str(n_trial), '] \theta_y ',...
                        'with seat fb angle = ', num2str(0),...
                        ', seat lr angle = ', num2str(0));
    title(title_str);
%     ylim([-10 50]);
    ylabel('\theta_y (^o)');
    xlabel('time (s)');
    grid on;
    
    figure()
    plot(x, seat_theta_x);
    hold on;
    plot(x, seat_theta_y);
    legend('\theta_x', '\theta_y');
    grid on;
    xlabel('time (s)');
    ylabel('\theta (^o)');

end
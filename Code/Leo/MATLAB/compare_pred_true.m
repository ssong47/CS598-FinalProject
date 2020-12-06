function compare_pred_true(fs, Ypred, Ytrue, theta_x, theta_y, theta_z, other_status)
    N = length(Ypred);
    data_idx = linspace(0, (N-1)/fs, N);
    
    lw = 2;
    figure()
    if other_status == 0
        plot(data_idx, Ytrue,'-','LineWidth', lw, 'Color', [0, 0.4470, 0.7410])
        hold on
        plot(data_idx, Ypred,'-','LineWidth', lw, 'Color', [0.8500, 0.3250, 0.0980]	)
        legend('truth', 'predicted')
        xlabel('data index')
        ylabel('Y')
        grid on 
    elseif other_status == 1
        subplot(2,1,1)
        plot(data_idx, Ytrue,'-','LineWidth', lw, 'Color', [0, 0.4470, 0.7410])
        hold on
        plot(data_idx, Ypred,'-','LineWidth', lw, 'Color', [0.8500, 0.3250, 0.0980]	)
        legend('truth', 'predicted')
        xlabel('Time (s)')
        ylabel('Y')
        grid on 
        
        subplot(2,1,2)
        plot(data_idx, theta_y, 'LineWidth', 2, 'Color',  	[0, 0.4470, 0.7410]	)
        hold on
        plot(data_idx, theta_x, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]	 )
        plot(data_idx, theta_z, 'LineWidth', 2, 'Color', [0.4660, 0.6740, 0.1880] )
        legend('(lean) fw/back', '(lean) left/right', '(twist) CW/CCW');
        xlabel('Time (s)')
        ylabel('Y')
        grid on 
    end



end
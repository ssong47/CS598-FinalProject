function plot_preprocessed_data(data_idx, X, Y)
    figure()
    ax1 = subplot(2,1,1);
    plot(data_idx, X)
    xlabel('data index');
    ylabel('X:Moment(Nm)');
    
    ax2 = subplot(2,1,2);
    plot(data_idx, Y)
    xlabel('data index');
    ylabel('Y:Angle(deg)');
    
    
    linkaxes([ax1, ax2], 'x');


end
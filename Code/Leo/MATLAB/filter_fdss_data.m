function fdss_post_data = filter_fdss_data(fdss_final_data, cutoff_freq, filter_order, fdss_fs)

    %% Preprocess FDSS data
    % Smoothen data
    [N, D] = size(fdss_final_data);

    i_start = 1;
    % N = 2410; % 384, 867, 1342, 1787, 2105, 2410
    [bLP, aLP] = butter(filter_order, cutoff_freq / (fdss_fs /2));
    fdss_filt_data = zeros(N-i_start+1, D);
    fdss_post_data = zeros(N-i_start+1, D);

    for i = 1:D
        % Filter data
        fdss_filt_data(:,i) = filtfilt(bLP, aLP, fdss_final_data (i_start:N, i));

        % Normalize data
        fdss_post_data(:,i) = fdss_filt_data(:,i); %/max(fdss_filt_data(:,i)); 
    end

end



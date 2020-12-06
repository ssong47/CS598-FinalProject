function [Yp, val_Yp] = regress_data(X, Y, theta_x, theta_y, theta_z,...
                      val_X, val_Y, val_theta_x, val_theta_y,val_theta_z,... 
                      show_other_status, regress_type, fdss_fs)

    if strcmp(regress_type, 'all') == 1
        Yp = {};
        val_Yp = {};
        for i = 1:2 
            [Yp{i}, mdl] = perform_regression(X(:,i), Y(:,i)); %mdl is a MATLAB object that contains regression info
            mdl_c = mdl.Coefficients.Estimate;
            compare_pred_true(fdss_fs, Yp{i}, Y(:,i), theta_x, theta_y, theta_z, show_other_status)
            residuals = mean(abs(Yp{i} - Y(:,i)));
            disp(residuals)

            % Validate Regression
            val_Yp{i} = mdl_c(1) + mdl_c(2) * val_X(:,i);
            compare_pred_true(fdss_fs, val_Yp{i}, val_Y(:,i), val_theta_x, val_theta_y, val_theta_z, show_other_status);

            val_residuals = mean(abs(val_Yp{i} - val_Y(:,i)));
            disp(val_residuals);
            
        end
    else
        [Yp, mdl] = perform_regression(X, Y); %mdl is a MATLAB object that contains regression info
        mdl_c = mdl.Coefficients.Estimate;
        compare_pred_true(fdss_fs, Yp, Y, theta_x, theta_y, theta_z, show_other_status)
        residuals = mean(abs(Yp - Y));
        disp(residuals)

        % Validate Regression
        val_Yp = mdl_c(1) + mdl_c(2) * val_X;
        compare_pred_true(fdss_fs, val_Yp, val_Y, val_theta_x, val_theta_y, val_theta_z, show_other_status);

        val_residuals = mean(abs(val_Yp - val_Y));
        disp(val_residuals);

    end

end
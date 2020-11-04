function [theta_x, theta_y, theta_z] = get_theta_xyz(qtm_data_zone)
    theta_x = qtm_data_zone(:,3);
    theta_y = qtm_data_zone(:,2);
    theta_z = qtm_data_zone(:,1);

end
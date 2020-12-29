function [theta_x, theta_y] = compute_theta_analytical(seat_def_angle,...
                                                       seat_fb_angle, seat_lr_angle,...
                                                       user_mass, user_height,...
                                                       Mx, My)
    g = 9.81;
    
    theta_x = 90 - real(acosd(-Mx./(user_height * user_mass * g)) - seat_lr_angle); 
    
    theta_y = 90 - real(acosd(-My./(user_height * user_mass * g)) - seat_fb_angle - seat_def_angle); 


end
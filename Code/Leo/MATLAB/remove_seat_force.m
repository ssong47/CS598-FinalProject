function user_force_data = remove_seat_force(force_data, seat_fb_angle, seat_def_angle, seat_lr_angle, seat_mass)
    N = length(force_data);
    user_force_data = zeros(size(force_data));
    
    for i = 1:N
        user_force_data(i,:) = force_data(i,:) - [-10.2, -2.3, -2.78,...
                                    0.45 * seat_mass * sind(seat_def_angle + seat_fb_angle(i)),...
                                    0.55 * seat_mass * sind(seat_def_angle + seat_fb_angle(i)),...
                                    seat_mass * sind(seat_lr_angle(i))];
        
    end
    
                                
    

end
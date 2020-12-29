function [seat_theta_x_array_post, seat_theta_y_array_post, seat_theta_x, seat_theta_y] =...
                        compute_seat_angle(origin_pts, seat_pts, show_plot)

%     origin_pts = (ox1, ox2, oy1, oy2)
    ox1 = origin_pts{:,1};
    ox2 = origin_pts{:,2};
    oy1 = origin_pts{:,3};
    oy2 = origin_pts{:,4};
   
%     seat_pts = (seat_fl, fr, br, bl)
    seat_fl = seat_pts{:,1};
    seat_fr = seat_pts{:,2};
    seat_br = seat_pts{:,3};
    seat_bl = seat_pts{:,4};
    
%     Initialize output arrays
    N = length(ox1);
    seat_theta_x_array = zeros(N,1);
    seat_theta_y_array = zeros(N,1);

    
%     Find projection of seat vectors on reference vectors 
    for i = 1:N
        
    %     Obtain reference X,Y,Z vectors
        ox = (ox2(i,:) - ox1(i,:)) / norm(ox2(i,:) - ox1(i,:)); 
        oy = (oy2(i,:) - oy1(i,:)) / norm((oy2(i,:) - oy1(i,:)));
        oz = cross(ox, oy) / norm(cross(ox, oy));

    %     Obtain seat X,Y,Z vectors
        seat_x = (seat_fr(i,:) - seat_br(i,:)) / norm(seat_fr(i,:) - seat_br(i,:));
        seat_y = (seat_bl(i,:) - seat_br(i,:)) / norm(seat_bl(i,:) - seat_br(i,:));
        seat_z = cross(seat_x, seat_y) / norm(cross(seat_x, seat_y));
        seat_center = [(seat_fl(:,1) + seat_br(:,2))/2, (seat_fl(:,2) + seat_br(:,2))/2, (seat_fr(:,3) + seat_br(:,3))/2];

        
        proj_zx = dot(seat_z, ox);
        proj_zy = dot(seat_z, oy);
        proj_zz = dot(seat_z, oz); 
        seat_theta_x_array(i) = -atan2d(proj_zy, proj_zz); 
        seat_theta_y_array(i) = -atan2d(proj_zx, proj_zz);
        
    end
    
    seat_theta_x_array_post = rmmissing(seat_theta_x_array);
    seat_theta_y_array_post = rmmissing(seat_theta_y_array);
    
    seat_theta_x = mean(seat_theta_x_array_post);
    seat_theta_y = mean(seat_theta_y_array_post);
    
    if show_plot == 1

        figure()
        quiver3(0, 0, 0, seat_x(1), seat_x(2), seat_x(3));
        hold on
        quiver3(0, 0, 0, seat_y(1), seat_y(2), seat_y(3));
        quiver3(0, 0, 0, seat_z(1), seat_z(2), seat_z(3));
        quiver3(0,0,0, ox(1), ox(2), ox(3), 'k');
        quiver3(0,0,0, oy(1), oy(2), oy(3), 'k');
        quiver3(0,0,0, oz(1), oz(2), oz(3), 'k');
        legend('seat X', 'seat Y','seat Z','origin X', 'origin Y','origin Z');
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        axis equal
    end
    
    




end
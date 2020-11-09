function plot_qtm_data(seat_data, tcenter_z_vec, tcenter_y_vec, t_origin, backrest_data, trunk_data, seat_center)

%% Plotting Qualisys Angle Data

% figure(7)
% plot(qtm_time, qtm_angle_twist);
% hold on
% plot(qtm_time, qtm_angle_leanfb);
% % hold on
% plot(qtm_time, qtm_angle_leanlr);
% legend('twist','fb','lr')

figure(6)
t_indx = 4500;
quiver3(0, 0, 0,...
        ref_x(t_indx,1), ref_x(t_indx,2), ref_x(t_indx,3), 'k-');
hold on 
quiver3(0, 0, 0,...
        ref_y(t_indx,1), ref_y(t_indx,2), ref_y(t_indx,3), 'k-');
quiver3(0, 0, 0,...
        ref_z(t_indx,1), ref_z(t_indx,2), ref_z(t_indx,3), 'k-');

quiver3(0, 0, 0, tcenter_z_vec(t_indx,1), tcenter_z_vec(t_indx,2), tcenter_z_vec(t_indx,3), 'r');
quiver3(0, 0, 0, tcenter_y_vec(t_indx,1), tcenter_y_vec(t_indx,2), tcenter_y_vec(t_indx,3), 'g');

quiver3(0, 0, 0, t_origin{t_indx}(1,1), t_origin{t_indx}(2,1), t_origin{t_indx}(3,1), '--k')
quiver3(0, 0, 0, t_origin{t_indx}(1,2), t_origin{t_indx}(2,2), t_origin{t_indx}(3,2), '--k')
quiver3(0, 0, 0, t_origin{t_indx}(1,3), t_origin{t_indx}(2,3), t_origin{t_indx}(3,3), '--k')

quiver3(0, 0, 0, proj_x_2(t_indx, 1), proj_x_2(t_indx,2), proj_x_2(t_indx,3), '--g')
quiver3(0, 0, 0, proj_y_2(t_indx,1), proj_y_2(t_indx,2), proj_y_2(t_indx,3), '--g')

axis equal
xlabel('x')
ylabel('y')
zlabel('z')

%% Plotting Qualisys Data
alpha_val = 0.5;
figure(1)
t_idx = 5000;
% Plotting origin and seat and backrest corners
for i = 1:4
%     a = scatter3(origin{i}(t_idx,1), origin{i}(t_idx,2), origin{i}(t_idx,3), 'ko', 'filled');
%     hold on;
    b = scatter3(seat_data{i}(t_idx,1), seat_data{i}(t_idx,2), seat_data{i}(t_idx,3), 'ko','filled');
    hold on;
    c = scatter3(backrest_data{i}(t_idx,1), backrest_data{i}(t_idx,2), backrest_data{i}(t_idx,3), 'ko','filled');
    
end

% Plotting Trunk markers
for i = 1:3
    d = scatter3(trunk_data{i}(t_idx,1), trunk_data{i}(t_idx,2), trunk_data{i}(t_idx,3), 'ro','filled');
end

% Plotting center of seat and backrest
e = scatter3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3), 'ko', 'filled');
f = scatter3(backrest_center(t_idx,1), backrest_center(t_idx,2), backrest_center(t_idx,3), 'ko', 'filled');

% Plotting seat plane
seat_plot_1 = [seat_data{1}(t_idx,:)' seat_data{2}(t_idx,:)' seat_data{3}(t_idx,:)'];
seat_plot_2 = [seat_data{3}(t_idx,:)' seat_data{4}(t_idx,:)' seat_data{1}(t_idx,:)'];
g = fill3(seat_plot_1(1,:), seat_plot_1(2,:), seat_plot_1(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);
h = fill3(seat_plot_2(1,:), seat_plot_2(2,:), seat_plot_2(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);

% Plotting backrest plane
backrest_plot_1 = [backrest_data{1}(t_idx,:)' backrest_data{2}(t_idx,:)' backrest_data{3}(t_idx,:)'];
backrest_plot_2 = [backrest_data{3}(t_idx,:)' backrest_data{4}(t_idx,:)' backrest_data{1}(t_idx,:)'];
i = fill3(backrest_plot_1(1,:), backrest_plot_1(2,:), backrest_plot_1(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);
j = fill3(backrest_plot_2(1,:), backrest_plot_2(2,:), backrest_plot_2(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);

% Plotting trunk plane
trunk_plot_1 = [trunk_data{1}(t_idx,:)' trunk_data{2}(t_idx,:)' trunk_data{3}(t_idx,:)'];
fill3(trunk_plot_1(1,:), trunk_plot_1(2,:), trunk_plot_1(3,:), 'r', 'EdgeColor', 'none', 'facealpha', alpha_val);

% Plotting seat normal vector (Z ref vector)
amp = 1000;
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        seat_normal(t_idx,1) * amp, seat_normal(t_idx,2) * amp, seat_normal(t_idx,3) * amp, 'k-');

% Plotting seat X ref vector
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        ref_x(t_idx,1) * amp, ref_x(t_idx,2) * amp, ref_x(t_idx,3) * amp, 'k-');

% Plotting seat Y ref vector
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        ref_y(t_idx,1) * amp, ref_y(t_idx, 2) * amp, ref_y(t_idx,3) * amp, 'k-');
    
% Plotting trunk normal vector
% quiver3(trunk_center(t_idx,1), trunk_center(t_idx,2), trunk_center(t_idx,3),...
%         trunk_normal(t_idx,1) * amp, trunk_normal(t_idx,2) * amp, trunk_normal(t_idx,3) * amp, 'r-');

% Plotting trunk normal vector at seat center
% quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
%         trunk_normal(t_idx,1) * amp, trunk_normal(t_idx,2) * amp, trunk_normal(t_idx,3) * amp, 'r-');
%     
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        tcenter_z_vec(t_idx,1) * amp, tcenter_z_vec(t_idx,2) * amp, tcenter_z_vec(t_idx,3) * amp, 'r-');
    
% Plotting trunk y vector at trunk center
quiver3(trunk_center(t_idx,1), trunk_center(t_idx,2), trunk_center(t_idx,3),...
        tcenter_y_vec(t_idx,1) * amp, tcenter_y_vec(t_idx,2) * amp, tcenter_y_vec(t_idx,3) * amp, 'r-');

% Plotting projection of trunk vector on seat x-axis
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        proj_x(t_idx,1) * amp, proj_x(t_idx,2) * amp, proj_x(t_idx,3) * amp, 'r--');

% Plotting projection of trunk vector on seat Y-axis
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        proj_y(t_idx,1) * amp, proj_y(t_idx,2) * amp, proj_y(t_idx,3) * amp, 'r--');

% Plotting projection of trunk vector on seat Z-axis    
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        proj_z(t_idx,1) * amp, proj_z(t_idx,2) * amp, proj_z(t_idx,3) * amp, 'r--');
    
% Plotting projection of trunk y vector on transformed seat coordinate system 
quiver3(trunk_center(t_idx,1), trunk_center(t_idx,2), trunk_center(t_idx,3),...
        proj_x_2(t_idx,1) * amp, proj_x_2(t_idx,2) * amp, proj_x_2(t_idx,3) * amp, 'g--');

% Plotting projection of trunk y vector on transformed seat coordinate system 
quiver3(trunk_center(t_idx,1), trunk_center(t_idx,2), trunk_center(t_idx,3),...
        proj_y_2(t_idx,1) * amp, proj_y_2(t_idx,2) * amp, proj_y_2(t_idx,3) * amp, 'g--');
    
axis equal
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');

%% Create Animation
figure(2)
curve = animatedline('LineWidth', 2);
set(gca,'Xlim', [-4000, -2500], 'Ylim', [-1000, 500], 'Zlim', [-600, 1200]);
view(-135, 45);
axis equal
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');
hold on;


lw = 3;

i_start = 4500;
i_skip = 4;
i_end = i_start + 1000;

alpha_val = 0.5;
t_idx = 30;

% Plotting origin and seat and backrest corners
for i = 1:4
    b = scatter3(seat_data{i}(t_idx,1), seat_data{i}(t_idx,2), seat_data{i}(t_idx,3), 'ko','filled');
    hold on;
    c = scatter3(backrest_data{i}(t_idx,1), backrest_data{i}(t_idx,2), backrest_data{i}(t_idx,3), 'ko','filled');
    
end


% Plotting center of seat and backrest
e = scatter3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3), 'ko', 'filled');
f = scatter3(backrest_center(t_idx,1), backrest_center(t_idx,2), backrest_center(t_idx,3), 'ko', 'filled');

% Plotting seat plane
seat_plot_1 = [seat_data{1}(t_idx,:)' seat_data{2}(t_idx,:)' seat_data{3}(t_idx,:)'];
seat_plot_2 = [seat_data{3}(t_idx,:)' seat_data{4}(t_idx,:)' seat_data{1}(t_idx,:)'];
g = fill3(seat_plot_1(1,:), seat_plot_1(2,:), seat_plot_1(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);
h = fill3(seat_plot_2(1,:), seat_plot_2(2,:), seat_plot_2(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);

% Plotting backrest plane
backrest_plot_1 = [backrest_data{1}(t_idx,:)' backrest_data{2}(t_idx,:)' backrest_data{3}(t_idx,:)'];
backrest_plot_2 = [backrest_data{3}(t_idx,:)' backrest_data{4}(t_idx,:)' backrest_data{1}(t_idx,:)'];
i = fill3(backrest_plot_1(1,:), backrest_plot_1(2,:), backrest_plot_1(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);
j = fill3(backrest_plot_2(1,:), backrest_plot_2(2,:), backrest_plot_2(3,:), 'k', 'EdgeColor', 'none', 'facealpha', alpha_val);

% Plotting seat normal vector (Z ref vector)
amp = 1000;
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        seat_normal(t_idx,1) * amp, seat_normal(t_idx,2) * amp, seat_normal(t_idx,3) * amp, 'k-');

% Plotting seat X ref vector
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        ref_x(t_idx,1) * amp, ref_x(t_idx,2) * amp, ref_x(t_idx,3) * amp, 'k-');

% Plotting seat Y ref vector
quiver3(seat_center(t_idx,1), seat_center(t_idx,2), seat_center(t_idx,3),...
        ref_y(t_idx,1) * amp, ref_y(t_idx, 2) * amp, ref_y(t_idx,3) * amp, 'k-');



    
for i = i_start:i_skip:i_end
%     addpoints(curve, trunk_data{1}(i,1), trunk_data{1}(i,2), trunk_data{1}(i,3));
    shoulder_left = scatter3(trunk_data{1}(i,1), trunk_data{1}(i,2), trunk_data{1}(i,3), 'r', 'filled');
    shoulder_right = scatter3(trunk_data{2}(i,1), trunk_data{2}(i,2), trunk_data{2}(i,3), 'r', 'filled');
    c7 = scatter3(trunk_data{3}(i,1), trunk_data{3}(i,2), trunk_data{3}(i,3), 'r', 'filled');
    trunk_plot_1 = [trunk_data{1}(i,:)' trunk_data{2}(i,:)' trunk_data{3}(i,:)'];
    trunk_plane = fill3(trunk_plot_1(1,:), trunk_plot_1(2,:), trunk_plot_1(3,:), 'r', 'EdgeColor', 'none', 'facealpha', alpha_val);

    trunk_z_vec_plot = quiver3(seat_center(i,1), seat_center(i,2), seat_center(i,3),...
        tcenter_z_vec(i,1) * amp, tcenter_z_vec(i,2) * amp, tcenter_z_vec(i,3) * amp, 'r-', 'LineWidth', lw);
    
    trunk_y_vec_plot = quiver3(trunk_center(i,1), trunk_center(i,2), trunk_center(i,3),...
        tcenter_y_vec(i,1) * amp, tcenter_y_vec(i,2) * amp, tcenter_y_vec(i,3) * amp, 'r-', 'LineWidth', lw);

    
    time_text = text(-3000, -800, 600, num2str(qtm_time(i)));

    
    % Plotting projection of trunk vectro on seat x-axis
    trunk_vec_x = quiver3(seat_center(i,1), seat_center(i,2), seat_center(i,3),...
            proj_x(i,1) * amp, proj_x(i,2) * amp, proj_x(i,3) * amp, 'g-', 'LineWidth', lw);

    % Plotting projection of trunk vectro on seat Y-axis
    trunk_vec_y = quiver3(seat_center(i,1), seat_center(i,2), seat_center(i,3),...
            proj_y(i,1) * amp, proj_y(i,2) * amp, proj_y(i,3) * amp, 'g-', 'LineWidth', lw);

    % Plotting projection of trunk vectro on seat Z-axis    
    trunk_vec_z = quiver3(seat_center(i,1), seat_center(i,2), seat_center(i,3),...
            proj_z(i,1) * amp, proj_z(i,2) * amp, proj_z(i,3) * amp, 'g-', 'LineWidth', lw);
        
    
    
    % Plotting projection of trunk y vector on transformed seat coordinate system 
    trunk_y_vec_proj_x = quiver3(trunk_center(i,1), trunk_center(i,2), trunk_center(i,3),...
            proj_x_2(i,1) * amp, proj_x_2(i,2) * amp, proj_x_2(i,3) * amp, 'g--', 'LineWidth', lw);

    % Plotting projection of trunk y vector on transformed seat coordinate system 
    trunk_y_vec_proj_y = quiver3(trunk_center(i,1), trunk_center(i,2), trunk_center(i,3),...
            proj_y_2(i,1) * amp, proj_y_2(i,2) * amp, proj_y_2(i,3) * amp, 'g--', 'LineWidth', lw);
    
    drawnow
    delete(shoulder_left);
    delete(shoulder_right);
    delete(c7);
    delete(trunk_plane);
    delete(trunk_z_vec_plot);
    delete(trunk_y_vec_plot);
    delete(trunk_vec_x);
    delete(trunk_vec_y);
    delete(trunk_vec_z);
    delete(time_text);
    delete(trunk_y_vec_proj_x);
    delete(trunk_y_vec_proj_y);
end



end
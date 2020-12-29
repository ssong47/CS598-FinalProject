clear all; close all; clc;

g = 9.81;
m = 68 * (0.551 + 0.0826);
% m = 62 * (0.551 + 0.0826);
% m = 60 * (0.551 + 0.0826);
d1 = 0.19;
d2 = 0.08;
d3 = 0.19;
l = 1.74 * 0.35;
% l = 0.70;
% l = 1.70 * 0.35;
pure_angle_fb = 0;
pure_angle_lr = 0;
seat_angle_fb = 11.5 + pure_angle_fb;
seat_angle_lr = pure_angle_lr;

% Training Data
n_trial = 35; %14
subject = 'leo'; %leo
date = '11_25_2020'; %11_11_2020
fdss = load(strcat('fcss_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
i_start = 2; %300;
i_end = length(fdss.fdss_output);
% i_end = 27054;
fdss_data = cell2mat(fdss.fdss_output(i_start:i_end,:));

qtm = load(strcat('qtm_processed_',subject,'_test',num2str(n_trial),'_',date,'.mat'));
qtm_data = cell2mat(qtm.qtm_output(i_start:i_end,:));


% FB Angles
% fdss_data_pure = fdss_data - [-12.04,-9.06,-5.97,-0.29,3.48,0.64]; % -10deg

% fdss_data_pure = fdss_data - [-10.61,-9.68,-6.54,0.43,3.90,0.63]; % -5deg

fdss_post_data = fdss_data - [-10.19,-2.31,-2.78,1.98,2.5,0.03]; % 0deg
    
% fdss_data_pure = fdss_data - [-8.52,-10.44,-7.48,-0.57,1.83,0.20]; % 5deg

% fdss_data_pure = fdss_data - [-9.68,-2.23,-2.62,3.27,3.94,0.24]; % 10deg

A = [[-10.10,-2.36,-2.96,0.57,1.06,-0.05];
     [-10.13,-2.43,-2.77,1.30,1.80,0.05];
     [-10.19,-2.31,-2.78,1.98,2.5,0.03];
     [-8.52,-10.44,-7.48,-0.57,1.83,0.20];
     [-9.68,-2.23,-2.62,3.27,3.94,0.24]] * g ;

m_seat = 19;
tilt_fr_angle = -9; 
tilt_lr_angle = 0;

for i = 1:5
    fx_hat = sind(11.5 + tilt_fr_angle) * m_seat * g;
    fy_hat = sind(tilt_lr_angle) * m_seat * g;
    disp(fx_hat)
end
    
% LR Angles
% fdss_data_pure = fdss_data - [-9.98,-2.27,-2.88,2.37,2.06,-3.82]; % 12deg CW

% fdss_post_data = fdss_data - [-10.08,-2.30,-2.88,2.21,2.23,-2.23]; % 7deg CW

% fdss_post_data = fdss_data - [-10.03,-2.33,-2.73,1.63,2.63,2.08]; % 6deg CCW

% fdss_post_data = fdss_data - [-9.69,-2.35,-2.62,1.23,2.85,4.08]; % 12deg CCW

[Mx_i, My_i, Mz_i] = compute_moments([-8.52,-10.44,-7.48,-0.57,1.83,0.20], d1, d2, d3);
disp(Mx_i)
disp(My_i)


% fdss_post_data = filter_fdss_data(fdss_data_pure, 1.0, 4, 60);

fz1 = fdss_data(:,1) * g;
fz2 = fdss_data(:,2) * g;
fz3 = fdss_data(:,3) * g;


fx1 = fdss_data(:,4) * g;
fx2 = fdss_data(:,5) * g;
fx = fx1 + fx2;

[Mx, My, Mz]= compute_moments(fdss_post_data, d1, d2, d3);

figure()
yyaxis left
plot(Mx)
yyaxis right
plot(qtm_data(:,3))

% fh = m * g / sind(11.5 + );
% theta_yy = zeros(length(fx),1);
% for i=1:length(fx)
%     theta_yy(i) = acotd( fx(i) * cosd(11.5) / (m*g - fx(i) * sind(11.5)));
% end
figure()
plot(My)
hold on
plot(Myy)
legend('My','Myy')
theta_yy = 90 - (real(acosd(-My ./ (l * m * g))) - seat_angle_fb);
theta_xx = 90 - (real(acosd(-Mx ./ (l * m * g))) - seat_angle_lr);
% 
figure(1)
plot(theta_yy)
hold on
plot(qtm_data(:,2))
legend('pred','truth')

avg_error = abs(theta_yy - qtm_data(:,2));
disp(mean(avg_error));

figure(2)
plot(theta_xx)
hold on
plot(qtm_data(:,3))
legend('pred','truth')

avg_error = abs(theta_xx - qtm_data(:,3));
disp(mean(avg_error));

%%
figure(3)
yyaxis left
plot(-Mx)
yyaxis right
plot(qtm_data(:,3))
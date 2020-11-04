function [Mx, My]= compute_moments(fdss_post_data, d1, d2, d3)
g = 9.81;

My = ((fdss_post_data(:, 5) + fdss_post_data(:, 6)) * d1 + ...
     (fdss_post_data(:, 7) + fdss_post_data(:, 8)) * d2) * g;
 
Mx = (fdss_post_data(:, 6) - fdss_post_data(:, 5)) * d3 * g;    



end
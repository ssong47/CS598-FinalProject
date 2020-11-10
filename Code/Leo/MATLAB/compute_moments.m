function [Mx, My, Mz]= compute_moments(fdss_post_data, d1, d2, d3)
g = 9.81;

My = ((fdss_post_data(:, 2) + fdss_post_data(:, 3) - fdss_post_data(:,1)) * d1 + ...     
     (fdss_post_data(:, 4) + fdss_post_data(:, 5)) * d2) * g;
 
Mx = ((fdss_post_data(:, 2) - fdss_post_data(:, 3)) * d3  + fdss_post_data(:,6) * d2)* g;    


Mz = (fdss_post_data(:,4) - fdss_post_data(:,5)) * d3 * g;

end
function [weight, height] = get_subject_info(subject)
    
    w_per = (0.551 + 0.0826);
    h_per = 0.30;
    if strcmp(subject, 'cz') == 1
        weight = 62 * w_per; % weight of user's torso + head in kg
        height = 1.80 * h_per; % user's torso height in m
        
    elseif strcmp(subject, 'yc') == 1
        weight = 70 * w_per;
        height = 1.70 * h_per;
        
    elseif strcmp(subject, 'leo') == 1
        weight = 68 * w_per;
        height = 1.74 * h_per;
    end
    
end
function [i_start, i_end] = fdss_find_start_end(time_sync)
    flag = 0;
    
    for i = 1:length(time_sync)
       sync_val = time_sync(i);
       sync_thresh = 10;
       
       if (sync_val < sync_thresh) && (flag == 0)
            i_start = i;
            flag = 1;
        
       end
       
       
       if (sync_val < sync_thresh) && (flag == 1) && (i > (i_start + 100))
           i_end = i; 
           break
           
       end
        
    end
    

end
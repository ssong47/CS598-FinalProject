function [i_start, i_end] = fdss_find_start_end(time_sync)
    flag = 0;
    i_start_count = 0;
    i_end_count = 0;
    for i = 1:length(time_sync)
       sync_val = time_sync(i);
       sync_thresh = 20;
       
       if (sync_val < sync_thresh) && (flag == 0)
            
            i_start_count = i_start_count + 1; 
            
            if i_start_count > 5
               flag = 1;
               i_start = i - 5;
            end
       else
           i_start_count = 0;
       end
       
       
       if (sync_val < sync_thresh) && (flag == 1) && (i > (i_start + 100))
           i_end_count = i_end_count + 1;
           if i_end_count > 5
               i_end = i - 5; 
               break
           end
           
       else
          i_end_count = 0; 
       end
        
    end
    

end
function [depth_obj, depth_video_post, mov] = process_video(depth_vid_filename, fdss_start, i_start, i_end,i_offset, all)

    % load video data
    depth_obj = VideoReader(depth_vid_filename);
    vid_frames = read(depth_obj, [1 depth_obj.NumFrames]);
    disp('num_frames=')
    disp(depth_obj.NumFrames)
    if strcmp(all,'all') ~= 1
        i = 1;
        for k = (fdss_start + i_start + i_offset): (fdss_start + i_end + i_offset)
            mov(i).cdata = vid_frames(:,:,:,k);
            mov(i).colormap = [];
            i = i + 1;
        end
        depth_video_post = vid_frames(:,:,:,[fdss_start+i_start+i_offset:fdss_start+i_end+i_offset]);
    else
        for k = 1:depth_obj.NumFrames
            mov(k).cdata = vid_frames(:,:,:,k);
            mov(k).colormap = [];
        end
        depth_video_post = vid_frames(:,:,:,:);
    end
end




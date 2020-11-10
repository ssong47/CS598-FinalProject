function new_frames = extract_frames(vid_filename, vid_start_frame, vid_end_frame)
    % Obtain object handle for color video
    vid = VideoReader(vid_filename);

    % Compute starting and ending time for video
%     vid_fr = vid.FrameRate;
%     vid_start_frame = round(vid_start_time * vid_fr);
%     vid_end_frame = round(vid_end_time * vid_fr);

    % Extract the necessary frames
    new_frames = read(vid,[vid_start_frame, vid_end_frame]);

    


end
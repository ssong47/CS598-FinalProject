function new_frames = extract_frames(vid_filename, vid_start_frame, vid_end_frame)
    % Obtain object handle for color video
    vid = VideoReader(vid_filename);

    % Extract the necessary frames
    new_frames = read(vid,[vid_start_frame, vid_end_frame]);

   

end
function save_video(save_filename, new_frames)
    % Save the extracted frames 
    new_video = VideoWriter(save_filename);
    open(new_video);

    for i = 1:length(new_frames)
       write_frame = new_frames(:,:,:,i);
       writeVideo(new_video, write_frame);
    end
    close(new_video);
end
function save_depth_video(frames, movie, savefilename, fs)

    
    obj=VideoWriter(savefilename);
    obj.FrameRate = fs;
    disp(savefilename);
    open(obj);
    for i=1:length(frames)
        movie(i).cdata=rgb2gray(frames(:,:,:,i));
        movie(i).colormap=gray;
    end

    writeVideo(obj,movie);
    close(obj);
end
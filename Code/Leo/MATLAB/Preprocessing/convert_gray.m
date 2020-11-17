function gray_frames = convert_gray(rgb_frames)
    size_video = size(rgb_frames);
    gray_frames = zeros(size_video(1), size_video(2), 1, size_video(4));

    for i=1:length(rgb_frames)
        gray_frames(:,:,1,i) = rgb2gray(rgb_frames(:,:,:,i));
    end
end
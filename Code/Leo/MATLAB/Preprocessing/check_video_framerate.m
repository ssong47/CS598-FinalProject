%% to obtain timestamp for each frame in lice video for timeseries
vid_file = 'C:\Users\77bis\Desktop\CS598-FinalProject\Code\Leo\Jupyter\depth_processed_leo_test26.avi';
obj = VideoReader(vid_file); %video
framecount = 0;

while hasFrame(obj)
    readFrame(obj);
    framecount = framecount + 1;
    current_time(framecount) = obj.CurrentTime;
end

estiamted_total_frame = obj.Duration * obj.FrameRate
actual_total_frame = obj.NumberOfFrames
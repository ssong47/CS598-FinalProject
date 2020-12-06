#####################################################
##               Read bag from file                ##
#####################################################


# First import library
import pyrealsense2 as rs
# Import Numpy for easy array manipulation
import numpy as np
# Import OpenCV for easy image rendering
import cv2


file_path = 'C:\\Users\\77bis\\Desktop\\bag_test30.bag'




# Create an object to read from camera 
video = cv2.VideoCapture(0) 
   
# We need to check if camera is opened previously or not 
if (video.isOpened() == False):  
    print("Error reading video file") 
    
# We need to set resolutions. so, convert them from float to integer. 
frame_width = int(video.get(3)) 
frame_height = int(video.get(4)) 
size = (frame_width, frame_height) 
mag_deci = 4

# Save Video
n_trial = 30
depthwriter = cv2.VideoWriter('fcss_leo_depth_test'+str(n_trial)+'.avi',  
                         cv2.VideoWriter_fourcc(*'DIVX'), 
                         30, (int(frame_width/mag_deci), int(frame_height/mag_deci)), 1) 



# Create pipeline
pipeline = rs.pipeline()

# Create a config object
config = rs.config()
# Tell config that we will use a recorded device from file to be used by the pipeline through playback.
rs.config.enable_device_from_file(config, file_path)

# Configure the pipeline to stream the depth stream
config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)

# Start streaming from file
pipeline.start(config)


# Convert to black-to-white color scheme
colorizer = rs.colorizer()
colorizer.set_option(rs.option.color_scheme, 3)


# Filter parameters
decimation = rs.decimation_filter(mag_deci)
threshold = rs.threshold_filter(0.15, 1.6)


i_frame = 0
max_frame = 84
i_count = 0
prev_frame = 0

# Get max frame number 
while True:
    # Get frameset of depth
    frames = pipeline.wait_for_frames()

    # Get current frame    
    n_frame = frames.get_frame_metadata(rs.frame_metadata_value.frame_counter)

    prev_frame = frames.get_frame_metadata(rs.frame_metadata_value.frame_timestamp) 
    # Get max frame number 
    if max_frame < n_frame:
        max_frame = n_frame
        # print(max_frame)
        i_frame = i_frame + 1
    if max_frame > n_frame:
        # print(max_frame)
        break
print('Total frame number is ',max_frame)

# Streaming loop
while (i_count < max_frame):
    # Wait for a coherent pair of frames: depth and color
    frames = pipeline.wait_for_frames()
    depth_frame = frames.get_depth_frame()
    if not depth_frame:
        continue

    # Decimation 
    depth_frame = decimation.process(depth_frame)

    # Thresholding
    depth_frame = threshold.process(depth_frame)
        
    # Apply colormap on depth image (image must be converted to8-bit per pixel first)
    depth_colormap = np.asanyarray(colorizer.colorize(depth_frame).get_data())  
    
    # Resize frame 
    depth_save = cv2.resize(depth_colormap, (int(frame_width/mag_deci), int(frame_height/mag_deci)))

    # Save depth data
    depthwriter.write(depth_save)

    # Show images
    cv2.imshow('Depth Stream', depth_save)

    # Render image in opencv window
    key = cv2.waitKey(1)
    # if pressed escape exit program
    if key == 27:
        pipeline.stop()
        cv2.destroyAllWindows()
        depthwriter.release()
        video.release()
        break
    i_count = i_count + 1

pipeline.stop()
cv2.destroyAllWindows()
depthwriter.release() 
video.release()
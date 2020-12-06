import time
import concurrent.futures 
import pyrealsense2 as rs
import numpy as np
import cv2
import serial 


def log_serial_data(run_time):
	fs = 30
	run_idx = run_time * fs
	addr = "COM4" 
	baud = 115200 
	ser = serial.Serial(
    	port = addr,\
    	baudrate = baud)

	n_trial = 30
	
	fcss_filename = "fcss_load_test"+str(n_trial)+".csv"
	datafile = open(fcss_filename, 'a')
	idx = 0 
	try:
		while idx < run_idx:
		    try: 
			    ser_bytes = ser.readline()
			    decoded_bytes = (ser_bytes[0:len(ser_bytes)-2].decode("utf-8").split(","))
			    write_line = ",".join(decoded_bytes) + str("\n")
			    datafile.write(write_line)
			    idx = idx + 1
		    except: 
		    	pass 
		    	breakn
	finally:
		ser.close()	
		datafile.close()





def log_video_data(run_time):
	fps = 30
	run_idx = run_time * fps
	n_trial = 30
	pipeline = rs.pipeline()
	config = rs.config()
	config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)
	bag_filename = 'depth_test' + str(n_trial) + '.bag'
	config.enable_record_to_file(bag_filename)
	pipeline.start(config)

	idx = 0 
	try:
	    while idx < run_idx:	        
	    	frames = pipeline.wait_for_frames()

        	depth_frame = frames.get_depth_frame()

        	# Colorize depth frame to jet colormap
	        depth_color_frame = colorizer.colorize(depth_frame)

	        # Convert depth_frame to numpy array to render image in opencv
	        depth_color_image = np.asanyarray(depth_color_frame.get_data())

	        # Render image in opencv window
	        cv2.imshow("Depth Stream", depth_color_image)
	        key = cv2.waitKey(1)
	        
	        # if pressed escape exit program	        
	        if key == 27:
	            cv2.destroyAllWindows()
	            break
        	
        	idx = idx + 1 
	finally:
	    pipeline.stop()
	    cv2.destroyAllWindows()
	    pass
	    

    
if __name__ == '__main__':
		
	with concurrent.futures.ProcessPoolExecutor() as executor:
		f1 = executor.submit(log_serial_data, 60)
		f2 = executor.submit(log_video_data, 60)

import time
import concurrent.futures 
import pyrealsense2 as rs
import numpy as np
import cv2
import serial 


def log_serial_data(run_time):
	addr = "COM6" 
	baud = 115200 
	
	n_trial = 30
	
	fcss_filename = "fcss_load_test"+str(n_trial)+".csv"
	datafile = open(fcss_filename, 'a')
	idx = 0 

	ser = serial.Serial(
    	port = addr,\
    	baudrate = baud)

	t_start = time.perf_counter()
	try:
		current_time = time.perf_counter() - t_start
		while (current_time < run_time):
		    try: 
			    ser_bytes = ser.readline()
			    decoded_bytes = (ser_bytes[0:len(ser_bytes)-2].decode("utf-8").split(","))
			    write_line = ",".join(decoded_bytes) + str("\n")
			    datafile.write(write_line)
			    idx = idx + 1
		    except: 
		    	pass 
		    	break
		    	
	finally:
		ser.close()	
		datafile.close()





def log_video_data(run_time):
	fps = 30
	run_idx = run_time * fps
	n_trial = 30
	
	bag_filename = 'depth_test' + str(n_trial) + '.avi'
	
	cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)

	# Define the codec and create VideoWriter object
	fourcc = cv2.VideoWriter_fourcc(*'XVID')
	out = cv2.VideoWriter(bag_filename,fourcc, fps, (640,480))

	t_start = time.perf_counter()
	try: 
		current_time = (time.perf_counter() - t_start)
		print(current_time)
		while(current_time < run_time):
		    ret, frame = cap.read()
		    
		    if ret==True:
		        out.write(frame)
		        cv2.imshow('frame',frame)
		        if cv2.waitKey(1) & 0xFF == ord('q'):
		            break
		    else:
		        break
	finally:
		# Release everything if job is finished
		cap.release()
		out.release()
		cv2.destroyAllWindows()        
	    

    
if __name__ == '__main__':
		
	with concurrent.futures.ProcessPoolExecutor() as executor:
		f1 = executor.submit(log_serial_data, 5)
		f2 = executor.submit(log_video_data, 5)

		
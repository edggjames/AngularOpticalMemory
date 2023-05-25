# AngularOpticalMemory

This repository contains the code that I have written to control an angular optical memory experiment, as per the attached paper Schott et al. 2015. 

The main script is develop_interface.m, which allows the user to 
- specify experimental parameters,
- initialise the camera,
- initialise the DAQ (which controls the galvo mirror),
- acquire a preview camera image,
- acquire data,
- inspect the experimental log file,
- correlate the experimental data,
- save the data.

All necessary functions are contained with this repository. 

Additionally, manual_voltage_control.m allows the user to set a voltage signal to the galvo mirror for system alignment. test_exposure_time.m allows the user to view image histograms prior to the experiment so as to select an exposure time that avoids pixel saturation but which makes appropriate use of the dynamic range of the sensor. 

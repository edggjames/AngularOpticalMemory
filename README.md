# AngularOpticalMemory

This repository contains the code that I have written to control an angular optical memory experiment, as per the paper Schott _et al_. 2015 in the Documentation folder. 

The main script is develop_interface.m, which allows the user to 
- specify experimental parameters,
- initialise the camera,
- initialise the DAQ (which controls the galvo mirror),
- acquire a preview camera image,
- acquire data,
- inspect the experimental log file,
- correlate the experimental data,
- save the data anf log file for post processing.

All necessary functions are contained with the Functions folder. 

Additionally, manual_voltage_control.m allows the user to set a voltage signal to the galvo mirror for system alignment. test_exposure_time.m allows the user to view image histograms prior to the experiment so as to select an exposure time that avoids pixel saturation but which makes appropriate use of the dynamic range of the sensor. 

Any omissions, bugs, questions, or comments, please contact me on <e.james.14@ucl.ac.uk>.


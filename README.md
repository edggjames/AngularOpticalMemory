# AngularOpticalMemory

This repository contains the code that I have written to control an angular optical memory experiment, as per the paper Schott _et al_. 2015 in the Documentation folder. 

The main script is [develop_interface.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/develop_interface.m), which allows the user to 
- specify experimental parameters,
- initialise the camera,
- initialise the DAQ (which controls the galvo mirror),
- acquire a preview camera image,
- acquire data,
- inspect the experimental log file,
- preview the correlation of the experimental data (without compensating for translational shift),
- save the data and log file for post processing (e.g. [post_process_data.m]).

All necessary functions are contained with the Functions folder. 

Additionally, [manual_voltage_control.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/manual_voltage_control.m) allows the user to set a voltage signal to the galvo mirror for system alignment. [test_exposure_time.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/test_exposure_time.m) allows the user to view image histograms prior to the experiment so as to select an exposure time that avoids pixel saturation but which makes appropriate use of the dynamic range of the sensor. 

Any omissions, bugs, questions, or comments, please contact me on <e.james.14@ucl.ac.uk>.

![Documentation/experimental_setup.jpg
](https://github.com/edggjames/AngularOpticalMemory/blob/main/Documentation/experimental_setup.jpg)

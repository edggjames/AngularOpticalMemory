# AngularOpticalMemory

This repository contains the code that I have written to control and analyse the data from an angular optical memory experiment, as per the paper [Schott _et al_. 2015](https://github.com/edggjames/AngularOpticalMemory/blob/main/Documentation/Schott%20-%202015.pdf) in the [Documentation folder](https://github.com/edggjames/AngularOpticalMemory/tree/main/Documentation)

The main script is [develop_interface.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/develop_interface.m), which allows the user to 
- specify experimental parameters,
- initialise the camera,
- initialise the DAQ (which controls and reads the position of the galvo mirror),
- acquire a preview camera image,
- acquire data,
- inspect the experimental log file,
- preview the correlation of the experimental data (without compensating for translational shift),
- save the data and log file for post processing (see [post_process_data.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/post_process_data.m))

Additionally, [manual_voltage_control.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/manual_voltage_control.m) allows the user to set a voltage signal to the galvo mirror for system alignment. [test_exposure_time.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/test_exposure_time.m) allows the user to view image histograms prior to the experiment so as to select an exposure time that avoids pixel saturation but which makes appropriate use of the dynamic range of the sensor

[post_process_data.m](https://github.com/edggjames/AngularOpticalMemory/blob/main/post_process_data.m) carries out the following functions
- removal of second order polynomial background from individual camera frames
- visualisaion of these backgrounds as a montage
- examination of the experimental log file
- generation of a video of the unshifted camera frame stack
- calculation of correlation of unshifted frames
- model fitting of the unshifted correlation function to theory based on incident beam diameter
- calculation of correlation of shifted frames
- visualisation of this correlation function and verification against theory for a ground glass diffuser (for both correlation function and translational shift)
- generation of a video of the shifted camera frame stack
- visualisation of translational correlation functions for each image
- writing of all videos and images (which requires [export_fig](https://github.com/altmany/export_fig)) to the current working directory

All necessary functions are contained with the [Functions folder](https://github.com/edggjames/AngularOpticalMemory/tree/main/Functions)

Any omissions, bugs, questions, broken links, comments, or requests for example data sets, please contact me on <edggjames@hotmail.com>

![Documentation/experimental_setup.jpg
](https://github.com/edggjames/AngularOpticalMemory/blob/main/Documentation/experimental_setup.jpg)

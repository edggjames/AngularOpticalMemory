clc
close all hidden
clearvars
imaqreset
addpath('C:\Users\edggj\Dropbox\desktop\PDRA\Code\Functions')

%% todo
% add display outputs
% add error checks
% save camera frames on the go, or just at the end?

%% path for log file and camera data to be saved to
file_path = 'D:\Optical_Memory_Experiment\';
file_name = '23_05_2023_dataset_2';

%% set parameters for data acquisition
params.v_0     = -0.320;     % normal for manual alignment
params.v_start = 0;          % start voltage
params.v_end   = 1.0;        % end voltage (4.5 for bertolotti, 0.3 for schott)
params.num_its = 200;        % number of iterations (20 or 200)
params.t_exp   = 200;        % camera exposure time in microseconds
params.z       = 170.26;     % distance from sample to edge of flange on camera in mm (this is the end of the cage rods)
params.D       = [];         % measured spot diameter on sample in mm
params.iris    = [];         % parameter of iris in mm
params.vernier = -15;        % reading on camera rotation vernier
params.sample  = 'AR coated diffuser';
params.OD      = 1.6;        % OD of neutral density filter stack

params.dim_1   = 1200;       % sensor dimension 1
params.dim_2   = 1920;       % sensor dimension 2
params.f_0     = 299;        % focal length of L1 in mm
params.f_1     = 45;         % focal length of objective lens in mm
params.f_2     = 398.7;      % focal length of L2 in mm
params.BFD     = 17.98;      % back flange distance of camera in mm (+- 0.1 mm)
params.d_pix   = 3.45*1e-3;  % pixel size in mm
params.lambda  = 531.9*1e-6; % wavelength in mm
params.D_laser = 4;          % spot size at laser in mm
params.NA      = 0.1;        % numerical aperture of objective lens

%% voltages bigger than asind(0.1)/2 will be outside NA of objective lens
if params.v_end > asind(params.NA)/2
    quest = 'Warning - end voltage exceeds NA of objective lens - do you wish to proceed?';
    [flag] = dialogueQuestionBox(quest);
    if flag
        close all
        return % break out of script
    end
else
    percent = 100*params.v_end/(asind(params.NA)/2);
    quest = ['You are using ',num2str(percent,3),...
        ' % of the NA of objective lens - do you wish to proceed?'];
    [flag] = dialogueQuestionBox(quest);
    if flag
        close all
        return % break out of script
    end
end

%% calculate spot size at sample
[params.D_theoretical] = calcSpotSizeAtSample(params);

%% calculate vector of voltages for mirror
voltages = linspace(params.v_start+params.v_0,params.v_end+params.v_0,params.num_its);
% round to nearest millivolt
voltages = round(voltages*1000)/1000;

%% initialise DAQ
[dq] = initialiseDAQ;

%% initialise camera
[adapter_info,info,dev_info,cam,camProps] = initialiseCamera(params.t_exp);

%% show camera preview image
v_write = voltages(1);
[flag] = writeVoltage(dq,v_write);
if flag
    return % break out of script
end    
imshow(getsnapshot(cam),[])
title('Preview image')

%% add check clause here
quest = 'Is preview image ok?';
[flag] = dialogueQuestionBox(quest);
if flag
    close all
    return % break out of script
end

%% pre-allocate memory
im_stack = uint16(zeros(params.num_its,params.dim_1,params.dim_2));
log = zeros(params.num_its,4);

%% initialise waitbar
h = waitbar(0,'Acquiring data');

%% start clock
clock_start = datetime;

for i = 1:params.num_its

    %% calculate desired voltage output
    v_write = voltages(i);

    %% write voltage
    [flag] = writeVoltage(dq,v_write);
    if flag
        break % break out of loop
    end

    %% it takes the mirror 300 μs to come to rest at the command position    
    pause(300e-6)

    %% read voltage on channels 1 and 2
    v_read = timetable2table(read(dq));
    v_read = table2array(v_read(:,2:3));

    %% record numerical data in log file
    log(i,1) = v_write;   % this is command input +ve (command input -ve is ground)
    log(i,2) = v_read(1); % this is positioning error x 5
    log(i,3) = v_read(2); % this is scanner position 

    %% acquire camera frame
    im_stack(i,:,:) = getsnapshot(cam);

    %% check for pixel saturation
    max_pix_val = max(im_stack(i,:,:),[],'all');
    if max_pix_val >= 65504 % could just be ==
        disp('Error - pixel saturation encountered')
        close all hidden
        return
    end

    %% log elapsed time
    log(i,4) = time2num(datetime-clock_start,'seconds'); % this is time

    %% update wait bar
    waitbar(i/params.num_its)

end

%% close waitbar
close(h)
disp([newline,'Data acquistion complete',newline])

%% plot log file contents
plotLogFile(log,params)

quest = 'Is log file ok?';
[flag] = dialogueQuestionBox(quest);
if flag
    close all
    return % break out of script
end

%% call function to remove background from frames
% TBD
% this may not be necessary?

%% correlate frames
[rho] = correlateFrames(im_stack,params.num_its);

%% calculate angle at sample
[theta_sample] = calcAngleAtSample(log,params);

%% plot this
plotCorrelationPreview(theta_sample,rho)

quest = 'Is correlation ok?';
[flag] = dialogueQuestionBox(quest);
if flag
    close all
    return % break out of script
end

%% save parameters and log file
quest = 'Save data?';
[flag] = dialogueQuestionBox(quest);
close all 
if flag
    % do nothing
else
    disp([newline,'Saving data ... ',newline])
    save([file_path file_name], 'camProps', 'im_stack', 'log', 'params', 'cam',...
        'adapter_info', 'dev_info', 'info','-v7.3')
    disp('Data saved')
end

%% display camera temperature
disp([newline,'Camera temperature is ',num2str(camProps.DeviceTemperature),' degrees celsius'])
% NB operating temperature is 0 to 50 degrees celsius, and this is read
% from sensor
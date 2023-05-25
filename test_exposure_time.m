clc
close all hidden
clearvars
imaqreset

% script to assess best exposure time

%% enter exposure time to test
t_exp = 300; % microseconds
% Adjust exposure (6 us to 30 s) until mean value is ~33,000 (or near 65,535?)

%% initialise DAQ
[dq] = initialiseDAQ;

%% input desired output
v_write = -0.320;
writeVoltage(dq,v_write);
disp('voltage written')

%% initialise camera
[adapter_info,info,dev_info,cam,camProps] = initialiseCamera(t_exp);

%% check camProps
disp(['Exposure time is ',num2str(camProps.ExposureTime),' microseconds'])
disp(['ExposureAuto is set to ',num2str(camProps.ExposureAuto)]) % we want 'Off'
disp(['Gamma is set to ',num2str(camProps.Gamma)]) % we want 'False'
disp(['GammaEnable is set to ',num2str(camProps.GammaEnable)]) % we want 'False'
disp(['Gain is set to ',num2str(camProps.Gain)]) % we want 0
disp(['GainAuto is set to ',num2str(camProps.GainAuto)]) % we want 'Off'
disp(['GainRaw is set to ',num2str(camProps.GainRaw)]) % we want 0
disp(['AdcBitDepth is set to ',num2str(camProps.AdcBitDepth)]) % we want 'Bit12'
disp(['SaturationEnable is set to ',num2str(camProps.SaturationEnable)]) % we want 'False'
disp(['Saturation is set to ',num2str(camProps.Saturation)]) % we want '0'

%% grab frame
frame = getsnapshot(cam);

newFigureFillScreen;
subplot(1,2,1)
imshow(frame,[])
title('Preview image')
subplot(1,2,2)
histogram(frame(:))
title('Histogram')
xlim([0 65535])
disp([newline,'Minimum camera frame value is ',num2str(min(frame(:)))])
disp(['Mean camera frame value is ',num2str(mean(frame(:)))])
disp(['Maximum camera frame value is ',num2str(max(frame(:)))])


%% display camera temperature
disp([newline,'Camera temperature is ',num2str(camProps.DeviceTemperature),' degrees celsius'])
% NB operating temperature is 0 to 50 degrees celsius. 

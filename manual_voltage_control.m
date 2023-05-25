clc
close all
clearvars
addpath('C:\Users\edggj\Dropbox\desktop\PDRA\Code\Functions')

% manually position mirror for development

%% initialise DAQ
[dq] = initialiseDAQ;

%% input desired output
v_write = -0.320;
writeVoltage(dq,v_write);
disp('voltage written')

% -0.325 is baseline without any lenses
% still same with L1
% then with L2 is -0.55
% then with L3 is -0.7?

% negative is toward gift surg poster
% positive is toward CMIC poster

%% check if in range
% writeVoltage(dq,v_write);

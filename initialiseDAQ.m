function [dq] = initialiseDAQ

%% add voltage output
dq = daq("ni");
addoutput(dq, "myDAQ1", "ao0", "Voltage");
% This drives the mirror position - command input +ve
% Goes to pin 1 on J7 (see page 19 of manual)
% pin 2 on J7 is then grounded for a standard output function generator

% addoutput(dq, "myDAQ1", "ao1", "Voltage");
% This drives the mirror position - command input -ve (set to zero)
% Goes to pin 2 on J7 (see page 19 of manual) for a differential output
% function generator

% I have set this to 1 volt per degree

%% add voltage inputs
addinput(dq, "myDAQ1", "ai0", "Voltage");
% connect this to J6 pin 3 - positioning error x 5
addinput(dq, "myDAQ1", "ai1", "Voltage");
% this is a measurement of the scanner position
% connect to pin J6 pin 1 (see page 19 of manual).

% This is set to 0.5 volts per degree. 
end
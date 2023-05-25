function [adapter_info,info,dev_info,cam,camProps] = initialiseCamera(t_exp)
%% initialise camera
adapter_info = imaqhwinfo;
info = imaqhwinfo('gentl');
dev_info = imaqhwinfo('gentl',1);
cam = videoinput('gentl',1,'Mono16');
camProps = getselectedsource(cam);

%% set camera parameters
% see https://uk.mathworks.com/help/imaq/working-with-properties.html
% and also lines 555 to 583 of Hhanalyser.jl

camProps.ExposureTime      = t_exp;
camProps.ExposureAuto      = 'Off';
camProps.Gamma             = 0;
camProps.GammaEnable       = "False";
camProps.Gain              = 0;
camProps.GainAuto          = "Off";
camProps.GainRaw           = 0;
camProps.AdcBitDepth       = "Bit12";
camProps.SaturationEnable  = "False";
camProps.Saturation        = 0;
end
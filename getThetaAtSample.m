function [theta_sample] = getThetaAtSample(theta_mirror,params)
%Function to calculate angle at sample
% theta is specified in degrees

theta_sample = atand(tand(theta_mirror*2)*params.f_1/params.f_2);
end
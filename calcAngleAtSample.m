function [theta_sample] = calcAngleAtSample(log,params)
%Function to calculate angle at sample from raw data

% calculate mirror angle in degrees
theta_mirror = log(:,3)*2;
% convert mirror angle to start at 0
theta_mirror = theta_mirror-theta_mirror(1);
% now convert from angle of mirror to angle of incident beam on sample
[theta_sample] = getThetaAtSample(theta_mirror,params);
end
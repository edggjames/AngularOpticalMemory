function [spotSize] = calcSpotSizeAtSample(params)
%Function to calculate spot size at sample

% calculate beam diameter at output of objective lens
D = params.f_1/params.f_0*params.D_laser;

% calculate spot size at sample
spotSize = params.f_2*params.lambda*1.22*2/D;

end
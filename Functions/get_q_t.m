function cov_func = get_q_t(theta,D,mode,z)
% function to get correlation curve from angles and beam spot size  

% check iz z has been parsed
if ~exist('z','var')
    z = 1;
    %disp('z set to default value of 1 in function get_q_t')
else
    %disp('using input value of z')
end

lambda = 531.9*1e-9; % wavelength / m
A = pi*abs(sind(theta))/lambda;
if strcmp(mode,'Goodman')
    x_arg = D*A/z;
    %disp('using mode Goodman')
elseif strcmp(mode, 'Bertolotti')
    x_arg = 2*D*A/z;
    %disp('using mode Bertolotti')
end
mu_func = 2*besselj(1,x_arg)./(x_arg);
mu_func(x_arg==0)=1;
mu_func = reshape(mu_func,1,[]);
cov_func = abs(mu_func).^2;
end
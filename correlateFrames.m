function [rho] = correlateFrames(im_stack,n_frames,baseline_idx)
%Correlate input camera frame stack with no translation 

% if baseline_idx is not parsed, then uses 1 as default
if ~exist('baseline_idx','var')
    baseline_idx = 1;
    disp('Setting baseline image index to 1 in correlateFrames')
else
    disp('Using user defined baseline image index in correlateFrames')
end

crop_factor = 1;
rho = zeros(1,n_frames);
I_0 = double(squeeze(im_stack(baseline_idx,:,:)));
[dim_1,dim_2] = size(I_0);
win = centerCropWindow2d([dim_1,dim_2],round([dim_1,dim_2]/sqrt(crop_factor)));
I_0 = imcrop(I_0,win);
I_0_std = std(I_0(:));
for j = 1:n_frames
    I_j = double(squeeze(im_stack(j,:,:)));
    I_j = imcrop(I_j,win);
    C = cov(I_0,I_j);
    C = C(1,2); % this could equally be C(2,1);
    I_j_std = std(I_j(:));
    rho(j) = C/(I_0_std*I_j_std);
    clear I_j I_j_std C
    display(['Correlated images 1 and ',num2str(j)])
end
clear I_0 I_0_std
end
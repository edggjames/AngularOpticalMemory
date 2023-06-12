function [shifts, rho_shift] = correlateWithShift(im_stack,params,shifts,crop_factor)
%Function to correlate a stack of images over all possible translations
% Doesn't use central window approach, so quite expensive approach
% Do we take non-zero component or not?

% crop_factor = 9;
% therefore we take the central 9th of the image of the image, and reduce each  
% dimension by a factor of sqrt(crop_factor).

I_baseline = squeeze(im_stack(1,:,:));
% apply window here?
% window = hamming(params.dim_1).*hamming(params.dim_2)';
% I_baseline = I_baseline.*window;
% [dim_1,dim_2] = size(I_baseline);
% dim_1_start = round(dim_1/3+1);
% dim_1_end   = round(dim_1_start+dim_1/3-1);
% dim_2_start = round(dim_2/3+1);
% dim_2_end   = round(dim_2_start+dim_2/3-1);
% I_baseline  = I_baseline(dim_1_start:dim_1_end,dim_2_start:dim_2_end);

if exist('shifts','var')
    n_shifts = length(shifts);
    disp('Using user defined shifts in correlateWithShift')
else
    mkr = params.dim_2*2;
    n_shifts = mkr-1;
    shifts = (1:n_shifts)-mkr/2;
    disp('Using all possible shifts in correlateWithShift')
end
rho_shift = zeros(params.num_its,n_shifts);

take_non_zero = true;
% take_non_zero = false;

for j = 1:params.num_its
    % specify image for correlation
    I_corr = squeeze(im_stack(j,:,:));


    for shift = 1:n_shifts

        I_corr_trans = imtranslate(I_corr,[shifts(shift), 0]);
        % apply window here
%         I_corr_trans  = I_corr_trans(dim_1_start:dim_1_end,dim_2_start:dim_2_end);
%         % check for zeros in central window
%         % disp(min(I_corr_trans(:)))
%         temp_sum = sum(I_corr_trans,1);
%         k = find(temp_sum);
%         idx_1 = k(1);
%         idx_2 = k(end);
%         if idx_2 - idx_1 ~= dim_2_end-dim_2_start
%             disp('warning - zeros in central window')
%         end

        % take non-zero component?
        if take_non_zero
            % first sum columns
            temp_sum = sum(I_corr_trans,1);
            k = find(temp_sum);
            idx_1 = k(1);
            idx_2 = k(end); 
            I_corr_trans = I_corr_trans(:,idx_1:idx_2);

            % take equivalent component of un-shifted image
            I_baseline_trim = I_baseline(:,idx_1:idx_2);

            % define hamming window here
            % [dim_1,dim_2] = size(I_corr_trans);
            % window = hamming(dim_1).*hamming(dim_2)';
            % I_corr_trans    = I_corr_trans.*window;
            % I_baseline_trim = I_baseline_trim.*window;
            % clear window dim_1 dim_2

            % take central portion of image of remaining image
            [dim_1,dim_2] = size(I_corr_trans);
            win = centerCropWindow2d([dim_1,dim_2],round([dim_1,dim_2]/sqrt(crop_factor)));
            I_baseline_trim = imcrop(I_baseline_trim,win);
            I_corr_trans = imcrop(I_corr_trans,win);

            %             dim_1_start = round(dim_1/3+1);
            %             dim_1_end   = round(dim_1_start+dim_1/3-1);
            %             dim_2_start = round(dim_2/3+1);
            %             dim_2_end   = round(dim_2_start+dim_2/3-1);
%             I_baseline_trim  = I_baseline_trim(dim_1_start:dim_1_end,dim_2_start:dim_2_end);
%             I_corr_trans     = I_corr_trans(dim_1_start:dim_1_end,dim_2_start:dim_2_end);
            %             clear temp_sum k idx_1 idx_2

            clear temp_sum k idx_1 idx_2 dim_1 dim_2 win
        else
            I_baseline_trim = I_baseline;
%             % define hamming window
%             [dim_1,dim_2] = size(I_baseline_trim);
%             window = hamming(dim_1).*hamming(dim_2)';
%             I_baseline_trim = I_baseline_trim.*window;
%             I_corr_trans    = I_corr_trans.*window;
%             clear window dim_1 dim_2
        end

        % correlate the two
        C = cov(I_baseline_trim,I_corr_trans);
        C = C(1,2); % this could equally be C(2,1)
        I_0_std = std(I_baseline_trim(:));
        I_trans_std = std(I_corr_trans(:));
        rho_shift(j,shift) = C/(I_0_std*I_trans_std);
        clear I_baseline_trim I_corr_trans C I_trans_std I_0_std
        display(['For image ',num2str(j),' of ',num2str(params.num_its),...
            ', correlated shift ',num2str(shift),' of ',num2str(n_shifts)])
    end
    clear I_corr
end

end
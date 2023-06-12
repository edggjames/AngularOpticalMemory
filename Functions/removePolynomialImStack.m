function [recon_im_stack,log,params,background_stack] = removePolynomialImStack(data_file,order,mode_poly)
%Function to remove nth order polynomial from image stack

[im_stack, log, params] = loadData(data_file);
[X,Y] = meshgrid(1:params.dim_2, 1:params.dim_1);
x1d = reshape(X, numel(X), 1);
y1d = reshape(Y, numel(Y), 1);
recon_im_stack = zeros(size(im_stack));

if strcmp(mode_poly,'average')
    % fit to mean of whole image stack
    mean_im = squeeze(mean(im_stack,1));
    z1d = double(reshape(mean_im, numel(mean_im), 1));

    if order == 1
        fit_surface = fit([x1d y1d],z1d,"poly11");
    elseif order ==2
        fit_surface = fit([x1d y1d],z1d,"poly22");
    end
    coefs = coeffvalues(fit_surface);
    % higher order fits don't seem to work so well

    % reconstruct
    if order == 1
        background_stack = coefs(1)+coefs(2)*x1d+coefs(3)*y1d;
    elseif order == 2
        background_stack = coefs(1)+coefs(2)*x1d+coefs(3)*y1d+coefs(4)*x1d.^2+...
            coefs(5)*x1d.*y1d+coefs(6)*y1d.^2;
    end

    background_stack = reshape(background_stack,[params.dim_1 params.dim_2]);

    for i = 1:params.num_its

        % do this with the mean of the im_stack?
        temp_im = squeeze(im_stack(i,:,:));

        recon_im_stack(i,:,:) = temp_im-background_stack;

        clear temp_im

        disp(['Frame ',num2str(i),' of ',num2str(params.num_its),' complete'])
    end

elseif strcmp(mode_poly,'single')
    background_stack = zeros(size(im_stack));

    for i = 1:params.num_its
        % take ith image and fit an nth order polynomial to it
        temp_im = squeeze(im_stack(i,:,:));
        z1d = double(reshape(temp_im, numel(temp_im), 1));

        if order == 1
            fit_surface = fit([x1d y1d],z1d,"poly11");
        elseif order ==2
            fit_surface = fit([x1d y1d],z1d,"poly22");
        end
        coefs = coeffvalues(fit_surface);
        % higher order fits don't seem to work so well

        % reconstruct
        if order == 1
            background = coefs(1)+coefs(2)*x1d+coefs(3)*y1d;
        elseif order == 2
            background = coefs(1)+coefs(2)*x1d+coefs(3)*y1d+coefs(4)*x1d.^2+...
                coefs(5)*x1d.*y1d+coefs(6)*y1d.^2;
        end

        background = reshape(background,[params.dim_1 params.dim_2]);

        background_stack(i,:,:) = background;
        recon_im_stack(i,:,:) = temp_im-background;
    
        clear fit_surface coefs temp_im z1d
        clear background
        disp(['Frame ',num2str(i),' of ',num2str(params.num_its),' complete'])

    end

end
% normalise im_stack
recon_im_stack = recon_im_stack-min(recon_im_stack(:));
recon_im_stack = recon_im_stack/max(recon_im_stack(:));
% normalise background stack
background_stack = background_stack-min(background_stack(:));
background_stack = background_stack/max(background_stack(:));
end
clc
close all
clearvars

% Script to analyse AngularOpticalMemory experiment data for ground glass
% diffuser sample

% 1) pre translational correction
% 2) post translational correction

% polynomial removal parameters here
mode_poly = 'single';
order = 2;

% crop_factor for shifting
crop_factor = 9;

% define shifts
shifts = -250:10;

% perform shift correlation?
shift_correlate = true;
% shift_correlate = false;

% define data file
data_file = 'ground_glass_diffuser_data.mat';

%% Remove second order polynomial background from images and load data
[im_stack,log,params,background] = removePolynomialImStack(data_file,order,mode_poly);

%% show background image
[LW,fs] = newFigureFillScreen;
montage(permute(background,[2,3,1]))
title('2nd Order Polynomial Background - All Frames')
colormap gray
axis off

%% examine log file
plotLogFile(log,params);

%% make video of unshifted stack
newFigureFillScreen;
video = VideoWriter('unshifted.avi');
% create the video object
open(video); % open the file for writing
for j = 1:params.num_its
    temp_image = squeeze(im_stack(j,:,:));
    imshow(temp_image,[])
    drawnow
    writeVideo(video,temp_image); % write the image to file
end
close(video); % close the file
close(gcf)

%% correlate frames without shift
[rho] = correlateFrames(im_stack,params.num_its);

%% calculate angle at sample
[theta_sample] = calcAngleAtSample(log,params);

%% plot this
plotCorrelationPreview(theta_sample,rho)

%% fit for q_t
hold on
title(['Correlation Prior to Translational Correction - Theoretical beam diameter = ',...
    num2str(params.D_theoretical,2),' mm'],FontSize=fs)
% fit for q_t
mode = 'Goodman';
obj_func = @(x) sum((abs(rho-get_q_t(theta_sample,x,mode))).^2);
x_0 = params.D_theoretical*1e-3;
params.D_recon = fminsearch(obj_func,x_0);
q_t = get_q_t(theta_sample,params.D_recon,mode);
plot(theta_sample,q_t,'b-',LineWidth=LW)
% add legend
legend('experimental data',...
    ['Goodman model fit - beam diameter = ',num2str(params.D_recon*1000,2),' mm'],...
    'Location','best','fontsize',fs)

%% correlate im_stack with shift
if shift_correlate
    [shifts, rho_shift] = correlateWithShift(im_stack,params,shifts,crop_factor);
    save('rho_shift', 'rho_shift')
else
    load rho_shift
end

%% now find maximum correlation for each image
[rho_max,idx] = max(abs(rho_shift),[],2);
% take these shifts
max_cor_shifts = shifts(idx);

% plot rho_max and shifts they occur at
% plot this
newFigureFillScreen;
sz = 150;
% now plot
subplot(2,1,1)
scatter(theta_sample,abs(rho_max),sz,'ks','LineWidth',LW)
hold on
% plot expected results
yline(1,'b-','LineWidth',LW)
xlim([min(theta_sample) max(theta_sample)])
ylim([0 1.1])
xlabel('Rotation angle / deg',FontSize=fs)
ylabel('|Correlation|',FontSize=fs)
% calculate residual
residual_a = mean(abs(1-abs(rho_max)));
title(['Correlation after translational correction - residual = ',...
    num2str(residual_a)],FontSize=fs)
legend('data','expected','location','best',FontSize=fs)

subplot(2,1,2)
scatter(theta_sample,abs(max_cor_shifts),sz,'ks','LineWidth',LW)
hold on
% plot expected value
expected_shift = tand(theta_sample)*(params.BFD+params.z)/params.d_pix;
plot(theta_sample,expected_shift,'b-','LineWidth',LW)
xlim([min(theta_sample) max(theta_sample)])
xlabel('Rotation angle / deg',FontSize=fs)
ylabel('|Translational shift| / pixels',FontSize=fs)
legend('data','expected','location','best',FontSize=fs)
% calculate residual
residual_b = mean(abs(abs(max_cor_shifts)-expected_shift'));
title(['Residual = ',num2str(residual_b)],FontSize=fs)

%% now loop through frames and apply this shift
im_stack_shift = zeros(params.num_its,params.dim_1,params.dim_2);
for j = 1:params.num_its
    im_stack_shift(j,:,:) = imtranslate(squeeze(im_stack(j,:,:)),[max_cor_shifts(j), 0]);
    disp(j)
end
% normalise
im_stack_shift = im_stack_shift-min(im_stack_shift(:));
im_stack_shift = im_stack_shift/max(im_stack_shift(:));

%% make video of shifted im_stack
newFigureFillScreen;
video = VideoWriter('shifted.avi');
% create the video object
open(video); %open the file for writing
for j = 1:params.num_its
    temp_image = squeeze(im_stack_shift(j,:,:));
    imshow(temp_image,[])
    drawnow
    writeVideo(video,temp_image); %write the image to file
end
close(video); %close the file
close(gcf)

%% plot all correlation functions
offset = 0;
for j = 1:2
    newFigureFillScreen;
    for k = 1:16
        if k+offset > params.num_its
            break
        else
            subplot(4,4,k)
            plot(shifts,abs(rho_shift(k+offset,:)))
            xlabel('shift / pixels')
            ylabel('|correlation|')
            title(num2str(k+offset))
            ylim([0 1])
            xlim([min(shifts) max(shifts)])
        end
    end
    offset = offset + 16;
    sgtitle('Translational Correlation Functions for Each Image')
end

%% save images to current working directory
saveAllFigs(pwd)

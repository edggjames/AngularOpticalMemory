function plotCorrelationPreview(theta_sample,rho)
%Plot correlation preview

[~,fs] = newFigureFillScreen;
scatter(theta_sample,abs(rho),100,'kx')
xlim([min(theta_sample) max(theta_sample)])
ylim([0 1])
xlabel('Rotation angle at sample / deg',FontSize=fs)
ylabel('|Correlation|',FontSize=fs)
title('Correlation Preview',FontSize=fs)
end
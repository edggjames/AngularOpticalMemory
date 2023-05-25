function plotLogFile(log,params)
%Function to plot log file contents

[LW,fs] = newFigureFillScreen;

% calculate mirror angle in degrees
theta_mirror = log(:,3)*2;

% then plot
subplot(3,1,1)
plot(log(:,1),'r-','LineWidth',LW)
hold on
plot(theta_mirror,'k--','LineWidth',LW)
hold off
legend('J7 Pin 1 - command input +ve / 1.0',...
    'J6 Pin 1 - scanner position / 0.5',...
    'location','best',FontSize=fs)
xlabel('iteration number',FontSize=fs)
ylabel('volts / V',FontSize=fs)
xlim([1 params.num_its])

subplot(3,1,2)
plot(log(:,2),'k-','LineWidth',LW)
legend('J6 Pin 3 - positioning error x 5',...
    'location','best',FontSize=fs)
xlabel('iteration number',FontSize=fs)
ylabel('volts / V',FontSize=fs)
xlim([1 params.num_its])

subplot(3,1,3)
plot(log(:,4),'k-','LineWidth',LW)
xlabel('iteration number',FontSize=fs)
ylabel('time / s',FontSize=fs)
sgtitle('log file',FontSize=fs)
xlim([1 params.num_its])
end
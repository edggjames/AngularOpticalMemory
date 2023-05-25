function [LW,fs] = newFigureFillScreen
%Function to open figure window to fill screen
figure('units','normalized','outerposition',[0 0 1 1])

% add niceties for publishing here 
LW = 1.5;
fs = 15;
ax = gca;
ax.FontSize = fs; % this normally goes in between plots and labels
box on
end
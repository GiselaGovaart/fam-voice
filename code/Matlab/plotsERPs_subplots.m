
% This currently only works if I run the sections on after the other, 
% then maximize the figure, and then save it

%% Subplots training speaker
%F3
subplot(2,3,1);
h1 = plot(GA_dev12.times, ...
    mean((DIFF_12(F3,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean((GA_dev12.data(F3,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean((GA_stan12.data(F3,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('F3')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)



%-------------------------------------------------------------------------
%Fz
subplot(2,3,2);
h1 = plot(GA_dev12.times, ...
    mean((DIFF_12(Fz,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean((GA_dev12.data(Fz,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean((GA_stan12.data(Fz,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Fz')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

%-------------------------------------------------------------------------
%F4
subplot(2,3,3);
h1 = plot(GA_dev12.times, ...
    mean((DIFF_12(F4,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean((GA_dev12.data(F4,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean((GA_stan12.data(F4,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('F4')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

%-------------------------------------------------------------------------
%C3
subplot(2,3,4);
h1 = plot(GA_dev12.times, ...
    mean((DIFF_12(C3,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean((GA_dev12.data(C3,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean((GA_stan12.data(C3,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('C3')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)


%-------------------------------------------------------------------------
%Cz
subplot(2,3,5);
h1 = plot(GA_dev12.times, ...
    mean((DIFF_12(Cz,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean((GA_dev12.data(Cz,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean((GA_stan12.data(Cz,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Cz')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)



%-------------------------------------------------------------------------
%C4
subplot(2,3,6);
h1 = plot(GA_dev12.times, ...
    mean((DIFF_12(C4,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean((GA_dev12.data(C4,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean((GA_stan12.data(C4,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('C4')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)


%--------------------------------------------------------------------------

% Save figure
sgtitle('Training speaker') 


% This currently only works if I run the section, then maximize the figure,
% and then save it
%exportgraphics(gcf, strcat(DIR.grandaverage, 'Trainingspeaker_subplots.png'), 'Resolution', 200);


%% Subplots novel speaker 3
%F3
subplot(2,3,1);
h1 = plot(GA_dev3.times, ...
    mean((DIFF_3(F3,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3.times, ...
    mean((GA_dev3.data(F3,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean((GA_stan3.data(F3,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('F3')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)



%-------------------------------------------------------------------------
%Fz
subplot(2,3,2);
h1 = plot(GA_dev3.times, ...
    mean((DIFF_3(Fz,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3.times, ...
    mean((GA_dev3.data(Fz,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean((GA_stan3.data(Fz,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Fz')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

%-------------------------------------------------------------------------
%F4
subplot(2,3,3);
h1 = plot(GA_dev3.times, ...
    mean((DIFF_3(F4,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3.times, ...
    mean((GA_dev3.data(F4,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean((GA_stan3.data(F4,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('F4')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

%-------------------------------------------------------------------------
%C3
subplot(2,3,4);
h1 = plot(GA_dev3.times, ...
    mean((DIFF_3(C3,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3.times, ...
    mean((GA_dev3.data(C3,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean((GA_stan3.data(C3,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('C3')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)


%-------------------------------------------------------------------------
%Cz
subplot(2,3,5);
h1 = plot(GA_dev3.times, ...
    mean((DIFF_3(Cz,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3.times, ...
    mean((GA_dev3.data(Cz,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean((GA_stan3.data(Cz,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Cz')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)



%-------------------------------------------------------------------------
%C4
subplot(2,3,6);
h1 = plot(GA_dev3.times, ...
    mean((DIFF_3(C4,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3.times, ...
    mean((GA_dev3.data(C4,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean((GA_stan3.data(C4,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('C4')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)


%--------------------------------------------------------------------------

% Save figure
sgtitle('Novel speaker') 

% This currently only works if I run the section, then maximize the figure,
% and then save it
%exportgraphics(gcf, strcat(DIR.grandaverage, 'Novelspeaker3_subplots.png'), 'Resolution', 200);


%% Subplots novel speaker4
%F3
subplot(2,3,1);
h1 = plot(GA_dev4.times, ...
    mean((DIFF_4(F3,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4.times, ...
    mean((GA_dev4.data(F3,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean((GA_stan4.data(F3,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('F3')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)



%-------------------------------------------------------------------------
%Fz
subplot(2,3,2);
h1 = plot(GA_dev4.times, ...
    mean((DIFF_4(Fz,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4.times, ...
    mean((GA_dev4.data(Fz,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean((GA_stan4.data(Fz,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Fz')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

%-------------------------------------------------------------------------
%F4
subplot(2,3,3);
h1 = plot(GA_dev4.times, ...
    mean((DIFF_4(F4,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4.times, ...
    mean((GA_dev4.data(F4,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean((GA_stan4.data(F4,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('F4')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

%-------------------------------------------------------------------------
%C3
subplot(2,3,4);
h1 = plot(GA_dev4.times, ...
    mean((DIFF_4(C3,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4.times, ...
    mean((GA_dev4.data(C3,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean((GA_stan4.data(C3,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('C3')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)


%-------------------------------------------------------------------------
%Cz
subplot(2,3,5);
h1 = plot(GA_dev4.times, ...
    mean((DIFF_4(Cz,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4.times, ...
    mean((GA_dev4.data(Cz,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean((GA_stan4.data(Cz,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Cz')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)



%-------------------------------------------------------------------------
%C4
subplot(2,3,6);
h1 = plot(GA_dev4.times, ...
    mean((DIFF_4(C4,:,:)),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4.times, ...
    mean((GA_dev4.data(C4,:,:)),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean((GA_stan4.data(C4,:,:)),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
hold on;

% Set axes
ylims = [-10 15]; 
xlims = [-140 650];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('C4')
xlabel('msec')
ylabel('µV')
legend([h1, h2, h3], ...
    {'Difference', ...
    'Deviant (fɪ)', ...
    'Standard (fɛ)'}, ...
    'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
% daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-140 -100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-140','','0','','','','','','','650'};
ax.YTick = [-10 -5 0 5 10];
ax.YTickLabel = {'-10','-5','0','5','10'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)


%--------------------------------------------------------------------------

% Save figure
sgtitle('Novel speaker') 

% This currently only works if I run the section, then maximize the figure,
% and then save it
%exportgraphics(gcf, strcat(DIR.grandaverage, 'Novelspeaker4_subplots.png'), 'Resolution', 200);

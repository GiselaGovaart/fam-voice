function plot_colloc_pilot(DIR)


%% Set up
% Definelty part of final ROI
Fz = 4;
F3 = 5;
F4 = 6;
FC5 = 11;
FC6 = 12;
Cz = 28;
C3 = 13;
C4 = 14;

% Possibly part of final ROI: 
F7 = 7;
F8 = 8;

% Eye electrodes to compare with F7 and F8
F9 = 9;
F10 = 10;
EOG1 = 1;
Fp2 = 3;


%% Collapsed localizer for ACQUISITION RQ
% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

cd(DIR.grandaverage);

% Make GAs for ACQ:
GA_dev12 = pop_loadset('ga_S12_Dev.set');
GA_dev4 = pop_loadset('ga_S4_Dev.set');

GA_dev_all = pop_mergeset(GA_dev12, GA_dev4);
GA_dev_all.data = mean(GA_dev_all.data(:,:,:),3);

GA_stan12 = pop_loadset('ga_S12_Stan.set');
GA_stan4 = pop_loadset('ga_S4_Stan.set');

GA_stan_all = pop_mergeset(GA_stan12, GA_stan4);
GA_stan_all.data = mean(GA_stan_all.data(:,:,:),3);

DIFF = GA_dev_all.data - GA_stan_all.data;

rmpath(genpath(DIR.EEGLAB_PATH)); 

% NB everywhere below, the code DIFF(Fz,:,:) could be changed to DIFF(Fz,:)
% because the double now only has 2 dimensions. It use to have three, but I
% averaged (above) over the pps, becuase there are a differnet number of
% pps for the different speakers, and then matlab would not want to plot
% all data together. 
% leaving DIFF(Fz,:,:) does not make a differnce though

% ALL
fig = figure;
h1 = plot(GA_dev_all.times, ...
    ((DIFF(Fz,:,:)+DIFF(F3,:,:)+DIFF(F4,:,:)+ ...
    DIFF(F7,:,:)+DIFF(F8,:,:)+DIFF(FC5,:,:)+ DIFF(FC6,:,:)+ ...
    DIFF(Cz,:,:)+DIFF(C3,:,:)+DIFF(C4,:,:)) ...
    /10), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    ((GA_dev_all.data(Fz,:,:)+GA_dev_all.data(F3,:,:)+GA_dev_all.data(F4,:,:)+ ...
    GA_dev_all.data(F7,:,:)+GA_dev_all.data(F8,:,:)+GA_dev_all.data(FC5,:,:)+ GA_dev_all.data(FC6,:,:)+ ...
    GA_dev_all.data(Cz,:,:)+GA_dev_all.data(C3,:,:)+GA_dev_all.data(C4,:,:)) ...
    /10), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    ((GA_stan_all.data(Fz,:,:)+GA_stan_all.data(F3,:,:)+GA_stan_all.data(F4,:,:)+ ...
    GA_stan_all.data(F7,:,:)+GA_stan_all.data(F8,:,:)+GA_stan_all.data(FC5,:,:)+ GA_stan_all.data(FC6,:,:)+ ...
    GA_stan_all.data(Cz,:,:)+GA_stan_all.data(C3,:,:)+GA_stan_all.data(C4,:,:)) ...
    /10), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ All')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_all.jpeg'), ...
    'Resolution', 300);

% Fz
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(Fz,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(Fz,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(Fz,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ Fz')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_fz.jpeg'), ...
    'Resolution', 300);

% F3
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F3,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F3,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F3,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ F3')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_f3.jpeg'), ...
    'Resolution', 300);

% F4
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F4,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F4,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F4,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ F4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_f4.jpeg'), ...
    'Resolution', 300);

% FC5
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(FC5,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(FC5,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(FC5,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ FC5')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_FC5.jpeg'), ...
    'Resolution', 300);

% FC6
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(FC6,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(FC6,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(FC6,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ FC6')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_FC6.jpeg'), ...
    'Resolution', 300);

% Cz
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(Cz,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(Cz,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(Cz,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ Cz')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_Cz.jpeg'), ...
    'Resolution', 300);

% C3
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(C3,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(C3,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(C3,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ C3')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_C3.jpeg'), ...
    'Resolution', 300);


% C4
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(C4,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(C4,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(C4,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_C4.jpeg'), ...
    'Resolution', 300);

% F7
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F7,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F7,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F7,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ F7')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_F7.jpeg'), ...
    'Resolution', 300);


% F8
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F8,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F8,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F8,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ F8')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_F8.jpeg'), ...
    'Resolution', 300);


% F9 - F10
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F9,:,:)-DIFF(F10,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F9,:,:)-GA_dev_all.data(F10,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F9,:,:)-GA_stan_all.data(F10,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ F9-F10')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_F9-F10.jpeg'), ...
    'Resolution', 300);



% EOG1-Fp2
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(EOG1,:,:)- DIFF(Fp2,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(EOG1,:,:)-GA_dev_all.data(Fp2,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(EOG1,:,:)-GA_stan_all.data(Fp2,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer ACQ EOG1-Fp2')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_EOG1-Fp2.jpeg'), ...
    'Resolution', 300);

% %% ERPs with SD: baseline check
% % Vizualization ERPs with standard diff to check whether the baseline
% % correction induces artifacts
% 
% plot_erp({ ...
%     {GA_dev_all}, ...
%     {GA_stan_all}}, ...
%     'Fz', ...
%     'plotdiff', 0, ...
%     'plotstd', 'fill', ...
%     'permute', 1000, ...  % Does not work, why not?
%     'avgmode', 'auto', ... 
%     'labels', {'deviant', 'standard'} ...
%     );
% 
% exportgraphics(gcf, strcat(DIR.plotsCL, ...
%     ['ERP_Colloc_ACQ_Fz_SD.jpeg']), ...
%     'Resolution', 300);


%% Collapsed localizer for RECOGNITION RQ
% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

cd(DIR.grandaverage);

% Make GAs for REC:
GA_dev12 = pop_loadset('ga_S12_Dev.set');
GA_dev4 = pop_loadset('ga_S4_Dev.set');
GA_dev3 = pop_loadset('ga_S3_Dev.set');

GA_dev_all = pop_mergeset(GA_dev12, GA_dev4);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev3);
GA_dev_all.data = mean(GA_dev_all.data(:,:,:),3);

GA_stan12 = pop_loadset('ga_S12_Stan.set');
GA_stan4 = pop_loadset('ga_S4_Stan.set');
GA_stan3 = pop_loadset('ga_S3_Stan.set');

GA_stan_all = pop_mergeset(GA_stan12, GA_stan4);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan3);
GA_stan_all.data = mean(GA_stan_all.data(:,:,:),3);

DIFF = GA_dev_all.data - GA_stan_all.data;


rmpath(genpath(DIR.EEGLAB_PATH)); 

% NB everywhere below, the code DIFF(Fz,:,:) could be changed to DIFF(Fz,:)
% because the double now only has 2 dimensions. It use to have three, but I
% averaged (above) over the pps, becuase there are a differnet number of
% pps for the different speakers, and then matlab would not want to plot
% all data together. 
% leaving DIFF(Fz,:,:) does not make a differnce though


% ALL
fig = figure;
h1 = plot(GA_dev_all.times, ...
    ((DIFF(Fz,:,:)+DIFF(F3,:,:)+DIFF(F4,:,:)+ ...
    DIFF(F7,:,:)+DIFF(F8,:,:)+DIFF(FC5,:,:)+ DIFF(FC6,:,:)+ ...
    DIFF(Cz,:,:)+DIFF(C3,:,:)+DIFF(C4,:,:)) ...
    /10), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    ((GA_dev_all.data(Fz,:,:)+GA_dev_all.data(F3,:,:)+GA_dev_all.data(F4,:,:)+ ...
    GA_dev_all.data(F7,:,:)+GA_dev_all.data(F8,:,:)+GA_dev_all.data(FC5,:,:)+ GA_dev_all.data(FC6,:,:)+ ...
    GA_dev_all.data(Cz,:,:)+GA_dev_all.data(C3,:,:)+GA_dev_all.data(C4,:,:)) ...
    /10), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    ((GA_stan_all.data(Fz,:,:)+GA_stan_all.data(F3,:,:)+GA_stan_all.data(F4,:,:)+ ...
    GA_stan_all.data(F7,:,:)+GA_stan_all.data(F8,:,:)+GA_stan_all.data(FC5,:,:)+ GA_stan_all.data(FC6,:,:)+ ...
    GA_stan_all.data(Cz,:,:)+GA_stan_all.data(C3,:,:)+GA_stan_all.data(C4,:,:)) ...
    /10), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_all.jpeg'), ...
    'Resolution', 300);

% Fz
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(Fz,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(Fz,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(Fz,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC Fz')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_fz.jpeg'), ...
    'Resolution', 300);

% F3
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F3,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F3,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F3,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC F3')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_f3.jpeg'), ...
    'Resolution', 300);

% F4
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F4,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F4,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F4,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC F4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_f4.jpeg'), ...
    'Resolution', 300);

% FC5
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(FC5,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(FC5,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(FC5,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC FC5')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_FC5.jpeg'), ...
    'Resolution', 300);

% FC6
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(FC6,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(FC6,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(FC6,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC FC6')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_FC6.jpeg'), ...
    'Resolution', 300);

% Cz
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(Cz,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(Cz,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(Cz,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC Cz')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_Cz.jpeg'), ...
    'Resolution', 300);

% C3
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(C3,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(C3,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(C3,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC C3')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_C3.jpeg'), ...
    'Resolution', 300);


% C4
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(C4,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(C4,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(C4,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_C4.jpeg'), ...
    'Resolution', 300);

% F7
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F7,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F7,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F7,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC F7')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_F7.jpeg'), ...
    'Resolution', 300);


% F8
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F8,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F8,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F8,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC F8')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_F8.jpeg'), ...
    'Resolution', 300);



% F9-F10
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(F9,:,:)-DIFF(F10,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(F9,:,:)-GA_dev_all.data(F10,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(F9,:,:)-GA_stan_all.data(F10,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC F9-F10')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_F9-F10.jpeg'), ...
    'Resolution', 300);



% EOG1-Fp2
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(EOG1,:,:)-DIFF(Fp2,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(EOG1,:,:)-GA_dev_all.data(Fp2,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(EOG1,:,:)-GA_stan_all.data(Fp2,:,:), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-15 15]; 
xlims = [-200 700];
ylim(ylims);
xlim(xlims);
set(gca,'YDir','reverse'); % reverse axes

% Add lines
hline = line(xlim, [0,0],'LineWidth',1);
hline.Color = 'black';
vline = line([0 0], ylim,'LineWidth',1);
vline.Color = 'black';

% Title, labels, legend
title('Collapsed localizer REC EOG1-Fp2')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_EOG1-Fp2.jpeg'), ...
    'Resolution', 300);



% %% ERPs with SD: baseline check
% % Vizualization ERPs with standard diff to check whether the baseline
% % correction induces artifacts
% 
% plot_erp({ ...
%     {GA_dev_all}, ...
%     {GA_stan_all}}, ...
%     'Fz', ...
%     'plotdiff', 0, ...
%     'plotstd', 'fill', ...
%     'permute', 1000, ...  % Does not work, why not?
%     'avgmode', 'auto', ... 
%     'labels', {'deviant', 'standard'} ...
%     );
% 
% exportgraphics(gcf, strcat(DIR.plotsCL, ...
%     ['ERP_Colloc_REC_Fz_SD.jpeg']), ...
%     'Resolution', 300);


end



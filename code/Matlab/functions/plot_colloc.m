function plot_colloc(DIR)


%% Set up
% Definelty part of final ROI
Fz = 14;
F3 = 6;
F4 = 7;
FC5 = 11;
FC6 = 12;
Cz = 27;
C3 = 1;
C4 = 2;

% Possibly part of final ROI: 
F7 = 8;
F8 = 9;

% Eye electrodes to check F7 and F8:
F9 = 10;
F10 = 5;
V2 = 26;
Fp2 = 13;


%% Collapsed localizer for ACQUISITION RQ
% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

cd(DIR.grandaverage);

% Make GAs for ACQ:
GA_dev12_fam = pop_loadset('ga_fam_S12_Dev.set');
GA_dev12_unfam = pop_loadset('ga_unfam_S12_Dev.set');
GA_dev4_fam = pop_loadset('ga_fam_S4_Dev.set');
GA_dev4_unfam = pop_loadset('ga_unfam_S4_Dev.set');

GA_dev_all = pop_mergeset(GA_dev12_fam, GA_dev12_unfam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_fam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_unfam); 
GA_dev_all.data = mean(GA_dev_all.data(:,:,:),3);

GA_stan12_fam = pop_loadset('ga_fam_S12_Stan.set');
GA_stan12_unfam = pop_loadset('ga_unfam_S12_Stan.set');
GA_stan4_fam = pop_loadset('ga_fam_S4_Stan.set');
GA_stan4_unfam = pop_loadset('ga_unfam_S4_Stan.set');

GA_stan_all = pop_mergeset(GA_stan12_fam, GA_stan12_unfam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_fam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_unfam); 
GA_stan_all.data = mean(GA_stan_all.data(:,:,:),3);

DIFF = GA_dev_all.data - GA_stan_all.data;

rmpath(genpath(DIR.EEGLAB_PATH)); 

% NB everywhere below, the code DIFF(Fz,:,:) could be changed to DIFF(Fz,:)
% because the double now only has 2 dimensions. It use to have three, but I
% averaged (above) over the pps, becuase there are a differnet number of
% pps for the different speakers, and then matlab would not want to plot
% all data together. 
% leaving DIFF(Fz,:,:) does not make a differnce though

%% ACQ ALL 
fig = figure;
h1 = plot(GA_dev_all.times, ...
    ((DIFF(Fz,:,:)+DIFF(F3,:,:)+DIFF(F4,:,:)+ ...
    DIFF(FC5,:,:)+ DIFF(FC6,:,:)+ ...
    DIFF(Cz,:,:)+DIFF(C3,:,:)+DIFF(C4,:,:)) ...
    /8), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    ((GA_dev_all.data(Fz,:,:)+GA_dev_all.data(F3,:,:)+GA_dev_all.data(F4,:,:)+ ...
    GA_dev_all.data(FC5,:,:)+ GA_dev_all.data(FC6,:,:)+ ...
    GA_dev_all.data(Cz,:,:)+GA_dev_all.data(C3,:,:)+GA_dev_all.data(C4,:,:)) ...
    /8), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    ((GA_stan_all.data(Fz,:,:)+GA_stan_all.data(F3,:,:)+GA_stan_all.data(F4,:,:)+ ...
   GA_stan_all.data(FC5,:,:)+ GA_stan_all.data(FC6,:,:)+ ...
    GA_stan_all.data(Cz,:,:)+GA_stan_all.data(C3,:,:)+GA_stan_all.data(C4,:,:)) ...
    /8), ...
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


%% ACQ per electrode
% F7 ----------------------------------------------------------------------
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

% F8 ----------------------------------------------------------------------
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

% Eye electrodes:
% F9 - F10 ----------------------------------------------------------------
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

% V2-Fp2 ------------------------------------------------------------------
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(V2,:,:)- DIFF(Fp2,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(V2,:,:)-GA_dev_all.data(Fp2,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(V2,:,:)-GA_stan_all.data(Fp2,:,:), ...
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
title('Collapsed localizer ACQ V2-Fp2')
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
    'ERP_Colloc_ACQ_V2-Fp2.jpeg'), ...
    'Resolution', 300);


%% Collapsed localizer for RECOGNITION RQ
% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

cd(DIR.grandaverage);
% Make GAs for RQ:
GA_dev12_fam = pop_loadset('ga_fam_S12_Dev.set');
GA_dev12_unfam = pop_loadset('ga_unfam_S12_Dev.set');
GA_dev3_fam = pop_loadset('ga_fam_S3_Dev.set');
GA_dev3_unfam = pop_loadset('ga_unfam_S3_Dev.set');
GA_dev4_fam = pop_loadset('ga_fam_S4_Dev.set');
GA_dev4_unfam = pop_loadset('ga_unfam_S4_Dev.set');

GA_dev_all = pop_mergeset(GA_dev12_fam, GA_dev12_unfam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev3_fam); 
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev3_unfam); 
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_fam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_unfam);

GA_dev_all.data = mean(GA_dev_all.data(:,:,:),3);

GA_stan12_fam = pop_loadset('ga_fam_S12_Stan.set');
GA_stan12_unfam = pop_loadset('ga_unfam_S12_Stan.set');
GA_stan3_fam = pop_loadset('ga_fam_S3_Stan.set');
GA_stan3_unfam = pop_loadset('ga_unfam_S3_Stan.set');
GA_stan4_fam = pop_loadset('ga_fam_S4_Stan.set');
GA_stan4_unfam = pop_loadset('ga_unfam_S4_Stan.set');

GA_stan_all = pop_mergeset(GA_stan12_fam, GA_stan12_unfam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan3_fam); 
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan3_unfam); 
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_fam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_unfam);

GA_stan_all.data = mean(GA_stan_all.data(:,:,:),3);

DIFF = GA_dev_all.data - GA_stan_all.data;

rmpath(genpath(DIR.EEGLAB_PATH)); 

% NB everywhere below, the code DIFF(Fz,:,:) could be changed to DIFF(Fz,:)
% because the double now only has 2 dimensions. It use to have three, but I
% averaged (above) over the pps, becuase there are a differnet number of
% pps for the different speakers, and then matlab would not want to plot
% all data together. 
% leaving DIFF(Fz,:,:) does not make a differnce though


%% REC ALL
fig = figure;
h1 = plot(GA_dev_all.times, ...
    ((DIFF(Fz,:,:)+DIFF(F3,:,:)+DIFF(F4,:,:)+ ...
    DIFF(FC5,:,:)+ DIFF(FC6,:,:)+ ...
    DIFF(Cz,:,:)+DIFF(C3,:,:)+DIFF(C4,:,:)) ...
    /8), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    ((GA_dev_all.data(Fz,:,:)+GA_dev_all.data(F3,:,:)+GA_dev_all.data(F4,:,:)+ ...
    GA_dev_all.data(FC5,:,:)+ GA_dev_all.data(FC6,:,:)+ ...
    GA_dev_all.data(Cz,:,:)+GA_dev_all.data(C3,:,:)+GA_dev_all.data(C4,:,:)) ...
    /8), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    ((GA_stan_all.data(Fz,:,:)+GA_stan_all.data(F3,:,:)+GA_stan_all.data(F4,:,:)+ ...
    GA_stan_all.data(FC5,:,:)+ GA_stan_all.data(FC6,:,:)+ ...
    GA_stan_all.data(Cz,:,:)+GA_stan_all.data(C3,:,:)+GA_stan_all.data(C4,:,:)) ...
    /8), ...
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

%% REC per electrode
% F7 ----------------------------------------------------------------------
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

% F8 ----------------------------------------------------------------------
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

% F9-F10 ------------------------------------------------------------------
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

% V2-Fp2 ------------------------------------------------------------------
fig = figure;
h1 = plot(GA_dev_all.times, ...
    DIFF(V2,:,:)-DIFF(Fp2,:,:), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    GA_dev_all.data(V2,:,:)-GA_dev_all.data(Fp2,:,:), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    GA_stan_all.data(V2,:,:)-GA_stan_all.data(Fp2,:,:), ...
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
title('Collapsed localizer REC V2-Fp2')
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
    'ERP_Colloc_REC_V2-Fp2.jpeg'), ...
    'Resolution', 300);


end



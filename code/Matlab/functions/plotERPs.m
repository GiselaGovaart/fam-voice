function plotERPs(DIR)


%% Set up

cd(DIR.grandaverage);

GA_dev12 = pop_loadset('ga_101-102.set');
GA_dev3 = pop_loadset('ga_103.set');
GA_dev4 = pop_loadset('ga_104.set');
GA_stan12 = pop_loadset('ga_231-232.set');
GA_stan3 = pop_loadset('ga_233.set');
GA_stan4 = pop_loadset('ga_234.set');

DIFF_12 = GA_dev12.data - GA_stan12.data;
DIFF_3 = GA_dev3.data - GA_stan3.data;
DIFF_4 = GA_dev4.data - GA_stan4.data;

GA_dev_all.data = (GA_dev12.data + GA_dev3.data  + GA_dev4.data)/3 ;
GA_stan_all.data = (GA_stan12.data + GA_stan3.data  + GA_stan4.data)/3 ;
DIFF_all = GA_dev_all.data - GA_stan_all.data;

rmpath(genpath(DIR.EEGLAB_PATH)); % not needed if run after
%computeGrandAverage.m

Fz = 4;
F3 = 5;
F4 = 6;
Cz = 28;
C3 = 13;
C4 = 14;

%% ALL SPEAKERS Fz, F3, F4
fig = figure;
h1 = plot(GA_dev12.times, ...
    mean(((DIFF_all(Fz,:,:)+DIFF_all(F3,:,:)+DIFF_all(F4,:,:)+ ...
    DIFF_all(Cz,:,:)+DIFF_all(C3,:,:)+DIFF_all(C4,:,:)) ...
    /6),3), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean(((GA_dev_all.data(Fz,:,:)+GA_dev_all.data(F3,:,:)+GA_dev_all.data(F4,:,:)+ ...
    GA_dev_all.data(Cz,:,:)+GA_dev_all.data(C3,:,:)+GA_dev_all.data(C4,:,:)) ...
    /6),3), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev12.times, ...
    mean(((GA_stan_all.data(Fz,:,:)+GA_stan_all.data(F3,:,:)+GA_stan_all.data(F4,:,:)+ ...
    GA_stan_all.data(Cz,:,:)+GA_stan_all.data(C3,:,:)+GA_stan_all.data(C4,:,:)) ...
    /6),3), ...
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
title('All speakers')
subtitle('F3, Fz, F4, C3, Cz, C4')
xlabel('msec')
ylabel('µV')
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent backrgound, set both here and above to 'none'


% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.grandaverage, ...
    'AllSpeakers_F3FzF4C3CzC4.jpeg'), ...
    'Resolution', 300);


%% TRAINING SPEAKER Fz, F3, F4
fig = figure;
h1 = plot(GA_dev12.times, ...
    mean(((DIFF_12(Fz,:,:)+DIFF_12(F3,:,:)+DIFF_12(F4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean(((GA_dev12.data(Fz,:,:)+GA_dev12.data(F3,:,:)+GA_dev12.data(F4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev12.times, ...
    mean(((GA_stan12.data(Fz,:,:)+GA_stan12.data(F3,:,:)+GA_stan12.data(F4,:,:))/3),3), ...
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
%title('Training speaker')
%subtitle('F3, Fz, F4')
xlabel('msec')
ylabel('µV')
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent backrgound, set both here and above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.grandaverage, ...
    'Trainingspeaker_F3FzF4_SABfinal.jpeg'), ...
    'Resolution', 300);


%% Trainingspeaker Cz, C3, C4
fig = figure;
h1 = plot(GA_dev12.times, ...
    mean(((DIFF_12(Cz,:,:)+DIFF_12(C3,:,:)+DIFF_12(C4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean(((GA_dev12.data(Cz,:,:)+GA_dev12.data(C3,:,:)+GA_dev12.data(C4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev12.times, ...
    mean(((GA_stan12.data(Cz,:,:)+GA_stan12.data(C3,:,:)+GA_stan12.data(C4,:,:))/3),3), ...
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
%title('Training speaker')
%subtitle('C3, Cz, C4')
xlabel('msec')
ylabel('µV')
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent backrgound, set both here and above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.grandaverage, ...
    'Trainingspeaker_C3CzC4_SABfinal.jpeg'), ...
    'Resolution', 300);
%% NOVEL SPEAKER (3) Fz, F3, F4
fig = figure;
h1 = plot(GA_dev3.times, ...
    mean(((DIFF_3(Fz,:,:)+DIFF_3(F3,:,:)+DIFF_3(F4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle','--');
hold on;
h2 = plot(GA_dev3.times, ...
    mean(((GA_dev3.data(Fz,:,:)+GA_dev3.data(F3,:,:)+GA_dev3.data(F4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev3.times, ...
    mean(((GA_stan3.data(Fz,:,:)+GA_stan3.data(F3,:,:)+GA_stan3.data(F4,:,:))/3),3), ...
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
%title('Novel speaker')
%subtitle('F3, Fz, F4')
xlabel('msec')
ylabel('µV')
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent backrgound, set both here and above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.grandaverage, ...
    'NovelSpeaker3_F3FzF4_SABfinal.jpeg'), ...
    'Resolution', 300);

%% Novel speaker (3) Cz, C3, C4
fig = figure;
h1 = plot(GA_dev3.times, ...
    mean(((DIFF_3(Cz,:,:)+DIFF_3(C3,:,:)+DIFF_3(C4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle','--');
hold on;
h2 = plot(GA_dev3.times, ...
    mean(((GA_dev3.data(Cz,:,:)+GA_dev3.data(C3,:,:)+GA_dev3.data(C4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev3.times, ...
    mean(((GA_stan3.data(Cz,:,:)+GA_stan3.data(C3,:,:)+GA_stan3.data(C4,:,:))/3),3), ...
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
%title('Novel speaker')
%subtitle('C3, Cz, C4')
xlabel('msec')
ylabel('µV')
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent backrgound, set both here and above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -210;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.grandaverage, ...
    'NovelSpeaker3_C3CzC4_SABfinal.jpeg'), ...
    'Resolution', 300);

%% NOVEL SPEAKER (4) Fz, F3, F4
fig = figure;
h1 = plot(GA_dev4.times, ...
    mean(((DIFF_4(Fz,:,:)+DIFF_4(F3,:,:)+DIFF_4(F4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle','--');
hold on;
h2 = plot(GA_dev4.times, ...
    mean(((GA_dev4.data(Fz,:,:)+GA_dev4.data(F3,:,:)+GA_dev4.data(F4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev4.times, ...
    mean(((GA_stan4.data(Fz,:,:)+GA_stan4.data(F3,:,:)+GA_stan4.data(F4,:,:))/3),3), ...
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
%title('Novel speaker')
%subtitle('F3, Fz, F4')
xlabel('msec')
ylabel(' µV')
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); 

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -200;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure
exportgraphics(fig, strcat(DIR.grandaverage, ...
    'NovelSpeaker4_F3FzF4_SABfinal.jpeg'), ...
    'Resolution', 300);

%% Novel speaker (4) Cz, C3, C4
fig = figure;
h1 = plot(GA_dev4.times, ...
    mean(((DIFF_4(Cz,:,:)+DIFF_4(C3,:,:)+DIFF_4(C4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle','--');
hold on;
h2 = plot(GA_dev4.times, ...
    mean(((GA_dev4.data(Cz,:,:)+GA_dev4.data(C3,:,:)+GA_dev4.data(C4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean(((GA_stan4.data(Cz,:,:)+GA_stan4.data(C3,:,:)+GA_stan4.data(C4,:,:))/3),3), ...
    'Color', '#3b8dca', 'Linewidth', 1);
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
%title('Novel speaker')
%subtitle('C3, Cz, C4')
xlabel('msec')
ylabel(' µV')
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); 

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};
% ax.TickDir = 'out'; % I like tick direction in better (default)
% ax.TickLength = [0.02, 0.02]; % I like the standard better, but with this
% you can make the length of the tick longer

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',1,'VerticalAlignment','middle')
hYLabel.Position(1) = -200;
hYLabel.Position(2) = 0;

set(gca,'LineWidth',1)

% Save figure
exportgraphics(fig, strcat(DIR.grandaverage, ...
    'NovelSpeaker4_C3CzC4_SABfinal.jpeg'), ...
    'Resolution', 300);


%% Topoplots
% Note: EEGlabs colors for the topoplot are horrible, because it overwrites
% the systems standard. I set it back by changing in
% eeglab2021.0/functions/sigprocfunc/icadefs.m line 70 from
% DEFAULT_COLORMAP = 'jet; ; to
% DEFAULT_COLORMAP = cmap_rdylbu
% that is a functions from colorbrewer, adapted by Benedikt Ehringer

cd(DIR.EEGLAB_PATH);
eeglab; close;

% All speakers
fig = figure;

% Define average of TW: 
TIME1   = 0.215; % time after stimulus onset (in seconds)
sample1 = round(eeg_lat2point(TIME1,1,GA_dev12.srate,[GA_dev12.xmin GA_dev12.xmax]));% convert TIME into EEG sampling point:
TIME2   = 0.465; % time after Stimulus onset (in seconds)
sample2 = round(eeg_lat2point(TIME2,1,GA_dev12.srate,[GA_dev12.xmin GA_dev12.xmax])); % convert TIME into EEG sampling point:

DIFF1 = mean(GA_dev_all.data,3) - mean(GA_stan_all.data,3); % calculate difference across mean of all subjects
DIFF_T1 = DIFF1(:,sample1:sample2); % neue Matrix mit Werten von TIME1-TIME2 ms ( sample3 / sample4)
DIFF_TW1 = mean(DIFF_T1,2); % calculate average

% Make Topoplot 
%topoplot(DIFF_TW1(:,:),GA_dev12.chanlocs, 'maplimits',[-5 5], 'style', 'fill', 'nosedir', '+X');
topoplot(DIFF_TW1(:,:),GA_dev12.chanlocs, 'maplimits',[-8 8], 'style', 'straight', 'nosedir', '+X', ...
    'electrodes', 'labels');
colorbar
title('All speakers (Difference): 215-465 ms')

exportgraphics(gcf, strcat(DIR.grandaverage, 'Allspeakers_topo.jpeg'), 'Resolution', 300);



% Training speaker
fig = figure;

% Define average of TW: 
TIME1   = 0.215; % time after stimulus onset (in seconds)
sample1 = round(eeg_lat2point(TIME1,1,GA_dev12.srate,[GA_dev12.xmin GA_dev12.xmax]));% convert TIME into EEG sampling point:
TIME2   = 0.465; % time after Stimulus onset (in seconds)
sample2 = round(eeg_lat2point(TIME2,1,GA_dev12.srate,[GA_dev12.xmin GA_dev12.xmax])); % convert TIME into EEG sampling point:

DIFF1 = mean(GA_dev12.data,3) - mean(GA_stan12.data,3); % calculate difference across mean of all subjects
DIFF_T1 = DIFF1(:,sample1:sample2); % neue Matrix mit Werten von TIME1-TIME2 ms ( sample3 / sample4)
DIFF_TW1 = mean(DIFF_T1,2); % calculate average

% Make Topoplot 
%topoplot(DIFF_TW1(:,:),GA_dev12.chanlocs, 'maplimits',[-5 5], 'style', 'fill', 'nosedir', '+X');
topoplot(DIFF_TW1(:,:),GA_dev12.chanlocs, 'maplimits',[-8 8], 'style', 'straight', 'nosedir', '+X', ...
    'electrodes', 'labels');
colorbar
title('Training speaker (Difference): 215-465 ms')

exportgraphics(gcf, strcat(DIR.grandaverage, 'Trainingspeaker_topo.jpeg'), 'Resolution', 300);

% Novel speaker 3
fig = figure;

% Define average of TW: 
TIME1   = 0.215; % time after stimulus onset (in seconds)
sample1 = round(eeg_lat2point(TIME1,1,GA_dev3.srate,[GA_dev3.xmin GA_dev3.xmax]));% convert TIME into EEG sampling point:
TIME2   = 0.465; % time after Stimulus onset (in seconds)
sample2 = round(eeg_lat2point(TIME2,1,GA_dev3.srate,[GA_dev4.xmin GA_dev3.xmax])); % convert TIME into EEG sampling point:

DIFF1 = mean(GA_dev3.data,3) - mean(GA_stan3.data,3); % calculate difference across mean of all subjects
DIFF_T1 = DIFF1(:,sample1:sample2); % neue Matrix mit Werten von TIME1-TIME2 ms ( sample3 / sample4)
DIFF_TW1 = mean(DIFF_T1,2); % calculate average

% Make Topoplot 
topoplot(DIFF_TW1(:,:),GA_dev3.chanlocs, 'maplimits',[-8 8], 'style', 'straight', 'nosedir', '+X', ...
    'electrodes', 'labels');
colorbar
title('Novel speaker (Difference): 215-465 ms')

exportgraphics(gcf, strcat(DIR.grandaverage, 'NovelSpeaker3_topo.jpeg'), 'Resolution', 300);


% Novel speaker 4
fig = figure;

% Define average of TW: 
TIME1   = 0.215; % time after stimulus onset (in seconds)
sample1 = round(eeg_lat2point(TIME1,1,GA_dev4.srate,[GA_dev4.xmin GA_dev4.xmax]));% convert TIME into EEG sampling point:
TIME2   = 0.465; % time after Stimulus onset (in seconds)
sample2 = round(eeg_lat2point(TIME2,1,GA_dev4.srate,[GA_dev4.xmin GA_dev4.xmax])); % convert TIME into EEG sampling point:

DIFF1 = mean(GA_dev4.data,3) - mean(GA_stan4.data,3); % calculate difference across mean of all subjects
DIFF_T1 = DIFF1(:,sample1:sample2); % neue Matrix mit Werten von TIME1-TIME2 ms ( sample3 / sample4)
DIFF_TW1 = mean(DIFF_T1,2); % calculate average

% Make Topoplot 
topoplot(DIFF_TW1(:,:),GA_dev4.chanlocs, 'maplimits',[-8 8], 'style', 'straight', 'nosedir', '+X', ...
    'electrodes', 'labels');
colorbar
title('Novel speaker (Difference): 215-465 ms')

exportgraphics(gcf, strcat(DIR.grandaverage, 'NovelSpeaker4_topo.jpeg'), 'Resolution', 300);



%% Make empty head plot for legend
% to make this plot, I increased the fontsize in topoplot.m:
% p_02453/packages/eeglab2021.0/functions/sigprocfunctions, change line 257
% to EFSIZE = 15; % use current default fontsize for electrode labels

% % remove functional electrodes
% GA_dev12 = pop_loadset('ga_101-102.set');
% GA_dev12.chanlocs(1)=[]; %EOG
% GA_dev12.chanlocs(1)=[];%Fp1
% GA_dev12.chanlocs(1)=[];%FP2
% GA_dev12.chanlocs(6)=[];%F9
% GA_dev12.chanlocs(6)=[];%F10
% GA_dev12.chanlocs(14)=[];%FP9
% GA_dev12.chanlocs(14)=[];%FP10
% 
% fig = figure;
% topoplot(DIFF_TW1(:,:),GA_dev12.chanlocs, 'style', 'blank', 'nosedir', '+X', ...
%     'electrodes', 'labels');
% 
% exportgraphics(gcf, strcat(DIR.grandaverage, 'EmptyHead.jpeg'), 'Resolution', 300);
% 
% GA_dev12 = pop_loadset('ga_101-102.set');


%% EEGLAB plotting
% pop_comperp( ALLEEG, 1, 1,2,'addavg','on','addstd','off','subavg','on','diffavg','on','diffstd','off','chans',4,'alpha',0.01,'tplotopt',{'ydir',-1});




end



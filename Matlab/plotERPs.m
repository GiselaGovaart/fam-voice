function plotERPs(DIR)


% %% Load paths and eeglab
% 
% % load EEGlab
% DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
% %addpath(genpath(DIR.EEGLAB_PATH));  % this gives a warning
% cd(DIR.EEGLAB_PATH);
% eeglab; close;
% 
% % Set Paths -  Later on include in master and delete this
% % params to play with
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% threshold = 150;
% minAmpValue = -threshold; 
% maxAmpValue = threshold; 
% wavThreshold = 'Hard'; %can be 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% 
% DIR.SET_PATH = '/data/p_02453/raw_eeg/pilot/raw-data-sets/';
% DIR.overallPath = strcat(DIR.SET_PATH,"01-output/hp",hpStr,"_Amp",int2str(threshold),...
%         "_wavThreshold", wavThreshold, "_version",int2str(version));
% DIR.processed =  strcat(DIR.overallPath,'/05-processed/');
% DIR.processed = convertStringsToChars(DIR.processed);

% %% Compute grand averages
% % this still needs to be added somewhere in the master if you delete here.
% % Or just leave here
% mkdir(strcat(DIR.overallPath,"/07-grandaverage/"));
% DIR.grandaverage = strcat(DIR.overallPath,'/07-grandaverage/');
% DIR.grandaverage = convertStringsToChars(DIR.grandaverage);
% 
% % 101_102: Deviant Training speaker
% EEG = pop_grandaverage({'01_processed_101.set', '02_processed_101.set', ...
%     '04_processed_102.set', '05_processed_101.set', '06_processed_101.set', ...
%     '07_processed_102.set', '08_processed_102.set', '09_processed_101.set', ...
%     '10_processed_101.set', '11_processed_102.set', '12_processed_102.set', ...
%     '13_processed_101.set', '15_processed_102.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 101-102');
% EEG = pop_saveset(EEG, 'filename', 'ga_101-102.set','filepath', DIR.grandaverage);
% 
% % 103: Deviant speaker 3
% EEG = pop_grandaverage( {'01_processed_103.set', '02_processed_103.set', ...
%     '04_processed_103.set', '05_processed_103.set', '06_processed_103.set', ...
%     '07_processed_103.set', '08_processed_103.set', '09_processed_103.set', ...
%     '10_processed_103.set', '11_processed_103.set', '12_processed_103.set', ...
%     '13_processed_103.set', '15_processed_103.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 103');
% EEG = pop_saveset( EEG, 'filename', 'ga_103.set','filepath', DIR.grandaverage);
% 
% % 104: Deviant speaker 4
% EEG = pop_grandaverage( {'01_processed_104.set', '02_processed_104.set', ...
%     '04_processed_104.set', '05_processed_104.set', '06_processed_104.set', ...
%     '07_processed_104.set', '08_processed_104.set', '09_processed_104.set', ...
%     '10_processed_104.set', '11_processed_104.set', '12_processed_104.set', ...
%     '13_processed_104.set', '15_processed_104.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 104');
% EEG = pop_saveset( EEG, 'filename', 'ga_104.set','filepath', DIR.grandaverage);
% 
% % 231-232: one standard training speaker
% EEG = pop_grandaverage( {'01_processed_231.set', ...
%     '02_processed_231.set', ...
%     '04_processed_232.set', ...
%     '05_processed_231.set', ...
%     '06_processed_231.set', ...
%     '07_processed_232.set', ...
%     '08_processed_232.set', ...
%     '09_processed_231.set', ...
%     '10_processed_231.set', ...
%     '11_processed_232.set', ...
%     '12_processed_232.set', ...
%     '13_processed_231.set', ...
%     '15_processed_232.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 231-232');
% EEG = pop_saveset( EEG, 'filename', 'ga_231-232.set','filepath', DIR.grandaverage);
% 
% % 233: one standard speaker 3
% EEG = pop_grandaverage( {'01_processed_233.set', ...
%     '02_processed_233.set', ...
%     '04_processed_233.set', ...
%     '05_processed_233.set', ...
%     '06_processed_233.set', ...
%     '07_processed_233.set', ...
%     '08_processed_233.set', ...
%     '09_processed_233.set', ...
%     '10_processed_233.set', ...
%     '11_processed_233.set', ...
%     '12_processed_233.set', ...
%     '13_processed_233.set', ...
%     '15_processed_233.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 233');
% EEG = pop_saveset( EEG, 'filename', 'ga_233.set','filepath', DIR.grandaverage);
% 
% % 234: one standard speaker 4
% EEG = pop_grandaverage( {'01_processed_234.set', ...
%     '02_processed_234.set', ...
%     '04_processed_234.set', ...
%     '05_processed_234.set', ...
%     '06_processed_234.set', ...
%     '07_processed_234.set', ...
%     '08_processed_234.set', ...
%     '09_processed_234.set', ...
%     '10_processed_234.set', ...
%     '11_processed_234.set', ...
%     '12_processed_234.set', ...
%     '13_processed_234.set', ...
%     '15_processed_234.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 234');
% EEG = pop_saveset( EEG, 'filename', 'ga_234.set','filepath', DIR.grandaverage);
% 
% 
% % 221-231-222-232: two standards training speaker
% EEG = pop_grandaverage( {'01_processed_221.set', '01_processed_231.set', ...
%     '02_processed_221.set', '02_processed_231.set', ...
%     '04_processed_222.set', '04_processed_232.set', ...
%     '05_processed_221.set', '05_processed_231.set', ...
%     '06_processed_221.set', '06_processed_231.set', ...
%     '07_processed_222.set', '07_processed_232.set', ...
%     '08_processed_222.set', '08_processed_232.set', ...
%     '09_processed_221.set', '09_processed_231.set', ...
%     '10_processed_221.set', '10_processed_231.set', ...
%     '11_processed_222.set', '11_processed_232.set', ...
%     '12_processed_222.set', '12_processed_232.set', ...
%     '13_processed_221.set', '13_processed_231.set', ...
%     '15_processed_222.set', '15_processed_232.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 221-231-222-232');
% EEG = pop_saveset( EEG, 'filename', 'ga_221-231-222-232.set','filepath', DIR.grandaverage);
% 
% % 223-233: two standards speaker 3
% EEG = pop_grandaverage( {'01_processed_223.set', '01_processed_233.set', ...
%     '02_processed_223.set', '02_processed_233.set', ...
%     '04_processed_223.set', '04_processed_233.set', ...
%     '05_processed_223.set', '05_processed_233.set', ...
%     '06_processed_223.set', '06_processed_233.set', ...
%     '07_processed_223.set', '07_processed_233.set', ...
%     '08_processed_223.set', '08_processed_233.set', ...
%     '09_processed_223.set', '09_processed_233.set', ...
%     '10_processed_223.set', '10_processed_233.set', ...
%     '11_processed_223.set', '11_processed_233.set', ...
%     '12_processed_223.set', '12_processed_233.set', ...
%     '13_processed_223.set', '13_processed_233.set', ...
%     '15_processed_223.set', '15_processed_233.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 223-233');
% EEG = pop_saveset( EEG, 'filename', 'ga_223-233.set','filepath', DIR.grandaverage);
% 
% % 224-234: two standards speaker 4
% EEG = pop_grandaverage( {'01_processed_224.set', '01_processed_234.set', ...
%     '02_processed_224.set', '02_processed_234.set', ...
%     '04_processed_224.set', '04_processed_234.set', ...
%     '05_processed_224.set', '05_processed_234.set', ...
%     '06_processed_224.set', '06_processed_234.set', ...
%     '07_processed_224.set', '07_processed_234.set', ...
%     '08_processed_224.set', '08_processed_234.set', ...
%     '09_processed_224.set', '09_processed_234.set', ...
%     '10_processed_224.set', '10_processed_234.set', ...
%     '11_processed_224.set', '11_processed_234.set', ...
%     '12_processed_224.set', '12_processed_234.set', ...
%     '13_processed_224.set', '13_processed_234.set', ...
%     '15_processed_224.set', '15_processed_234.set'}, ...
%     'pathname', DIR.processed);
% EEG = pop_editset(EEG,'setname', 'GA 224-234');
% EEG = pop_saveset(EEG, 'filename', 'ga_224-234.set','filepath', DIR.grandaverage);
% 

%% Plot

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

rmpath(genpath(DIR.EEGLAB_PATH)); 

Fz = 4;
F3 = 5;
F4 = 6;
Cz = 28;
C3 = 13;
C4 = 14;

%% TRAINING SPEAKER
%Fz, F3, F4
fig = figure;
h1 = plot(GA_dev12.times, ...
    mean(((DIFF_12(Fz,:,:)+DIFF_12(F3,:,:)+DIFF_12(F4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean(((GA_dev12.data(Fz,:,:)+GA_dev12.data(F3,:,:)+GA_dev12.data(F4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean(((GA_stan12.data(Fz,:,:)+GA_stan12.data(F3,:,:)+GA_stan12.data(F4,:,:))/3),3), ...
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
title('Training speaker')
subtitle('F3, Fz, F4')
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

% Save figure
exportgraphics(gcf, strcat(DIR.grandaverage, 'Trainingspeaker_F3FzF4.png'), 'Resolution', 100);


%-------------------------------------------------------------------------
% Cz, C3, C4
fig = figure;
h1 = plot(GA_dev12.times, ...
    mean(((DIFF_12(Cz,:,:)+DIFF_12(C3,:,:)+DIFF_12(C4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    mean(((GA_dev12.data(Cz,:,:)+GA_dev12.data(C3,:,:)+GA_dev12.data(C4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev12.times, ...
    mean(((GA_stan12.data(Cz,:,:)+GA_stan12.data(C3,:,:)+GA_stan12.data(C4,:,:))/3),3), ...
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
title('Training speaker')
subtitle('C3, Cz, C4')
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

% Save figure
exportgraphics(gcf, strcat(DIR.grandaverage, 'Trainingspeaker_C3CzC4.png'), 'Resolution', 100);
%% NOVEL SPEAKER (3)
% Fz, F3, F4
fig = figure;
h1 = plot(GA_dev3.times, ...
    mean(((DIFF_3(Fz,:,:)+DIFF_3(F3,:,:)+DIFF_3(F4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle','--');
hold on;
h2 = plot(GA_dev3.times, ...
    mean(((GA_dev3.data(Fz,:,:)+GA_dev3.data(F3,:,:)+GA_dev3.data(F4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean(((GA_stan3.data(Fz,:,:)+GA_stan3.data(F3,:,:)+GA_stan3.data(F4,:,:))/3),3), ...
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
title('Novel speaker')
subtitle('F3, Fz, F4')
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

% Save figure
exportgraphics(gcf, strcat(DIR.grandaverage, 'NovelSpeaker3_F3FzF4.png'), 'Resolution', 100);


%-------------------------------------------------------------------------
% Cz, C3, C4
fig = figure;
h1 = plot(GA_dev3.times, ...
    mean(((DIFF_3(Cz,:,:)+DIFF_3(C3,:,:)+DIFF_3(C4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle','--');
hold on;
h2 = plot(GA_dev3.times, ...
    mean(((GA_dev3.data(Cz,:,:)+GA_dev3.data(C3,:,:)+GA_dev3.data(C4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev3.times, ...
    mean(((GA_stan3.data(Cz,:,:)+GA_stan3.data(C3,:,:)+GA_stan3.data(C4,:,:))/3),3), ...
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
title('Novel speaker')
subtitle('C3, Cz, C4')
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

% Save figure
exportgraphics(gcf, strcat(DIR.grandaverage, 'NovelSpeaker3_C3CzC4.png'), 'Resolution', 100);


%% NOVEL SPEAKER (4)
%Fz, F3, F4
fig = figure;
h1 = plot(GA_dev4.times, ...
    mean(((DIFF_4(Fz,:,:)+DIFF_4(F3,:,:)+DIFF_4(F4,:,:))/3),3), ...
    'Color', 'black', 'Linewidth', 2, 'LineStyle','--');
hold on;
h2 = plot(GA_dev4.times, ...
    mean(((GA_dev4.data(Fz,:,:)+GA_dev4.data(F3,:,:)+GA_dev4.data(F4,:,:))/3),3), ...
    'Color', '#f78d95', 'Linewidth', 1);
hold on;
h3 = plot(GA_dev4.times, ...
    mean(((GA_stan4.data(Fz,:,:)+GA_stan4.data(F3,:,:)+GA_stan4.data(F4,:,:))/3),3), ...
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
title('Novel speaker')
subtitle('F3, Fz, F4')
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

% Save figure
exportgraphics(gcf, strcat(DIR.grandaverage, 'NovelSpeaker4_F3FzF4.png'), 'Resolution', 100);

%-------------------------------------------------------------------------
%Cz, C3, C4
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
title('Novel speaker')
subtitle('C3, Cz, C4')
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

% Save figure
exportgraphics(gcf, strcat(DIR.grandaverage, 'NovelSpeaker4_C3CzC4.png'), 'Resolution', 100);





%% EEGLAB plotting
% pop_comperp( ALLEEG, 1, 1,2,'addavg','on','addstd','off','subavg','on','diffavg','on','diffstd','off','chans',4,'alpha',0.01,'tplotopt',{'ydir',-1});




end



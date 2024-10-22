function plot_ERP_proc_woBLcorr(DIR, twstartacq, twendacq, twstartrec, twendrec)

% Plot the ERP per TestSpeaker per Group (FAM-UNFAM)

% NB: if you add F7 and F8 to the ROI, add it here!

%% Set up
ROI_labels = {'Fz', 'F3', 'F4', 'FC5', 'FC6', 'Cz', 'C3', 'C4','F7','F8'};

% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

% Load GAs (differently than in other plot scripts, for no reason:) same
% outcome though)
cd(DIR.grandaverage_woBLcorr);

GA_dev12_fam = pop_loadset('ga_fam_S12_Dev.set');
GA_dev12_fam.data = mean(GA_dev12_fam.data(:,:,:),3);
GA_dev12_unfam = pop_loadset('ga_unfam_S12_Dev.set');
GA_dev12_unfam.data = mean(GA_dev12_unfam.data(:,:,:),3);
GA_dev3_fam = pop_loadset('ga_fam_S3_Dev.set');
GA_dev3_fam.data = mean(GA_dev3_fam.data(:,:,:),3);
GA_dev3_unfam = pop_loadset('ga_unfam_S3_Dev.set');
GA_dev3_unfam.data = mean(GA_dev3_unfam.data(:,:,:),3);
GA_dev4_fam = pop_loadset('ga_fam_S4_Dev.set');
GA_dev4_fam.data = mean(GA_dev4_fam.data(:,:,:),3);
GA_dev4_unfam = pop_loadset('ga_unfam_S4_Dev.set');
GA_dev4_unfam.data = mean(GA_dev4_unfam.data(:,:,:),3);

GA_stan12_fam = pop_loadset('ga_fam_S12_Stan.set');
GA_stan12_fam.data = mean(GA_stan12_fam.data(:,:,:),3);
GA_stan12_unfam = pop_loadset('ga_unfam_S12_Stan.set');
GA_stan12_unfam.data = mean(GA_stan12_unfam.data(:,:,:),3);
GA_stan3_fam = pop_loadset('ga_fam_S3_Stan.set');
GA_stan3_fam.data = mean(GA_stan3_fam.data(:,:,:),3);
GA_stan3_unfam = pop_loadset('ga_unfam_S3_Stan.set');
GA_stan3_unfam.data = mean(GA_stan3_unfam.data(:,:,:),3);
GA_stan4_fam = pop_loadset('ga_fam_S4_Stan.set');
GA_stan4_fam.data = mean(GA_stan4_fam.data(:,:,:),3);
GA_stan4_unfam = pop_loadset('ga_unfam_S4_Stan.set');
GA_stan4_unfam.data = mean(GA_stan4_unfam.data(:,:,:),3);

GA_dev_all_acq = pop_mergeset(GA_dev12_fam, GA_dev12_unfam);
GA_dev_all_acq = pop_mergeset(GA_dev_all_acq, GA_dev4_fam);
GA_dev_all_acq = pop_mergeset(GA_dev_all_acq, GA_dev4_unfam); 
GA_dev_all_acq.data = mean(GA_dev_all_acq.data(:,:,:),3);

GA_stan_all_acq = pop_mergeset(GA_stan12_fam, GA_stan12_unfam);
GA_stan_all_acq = pop_mergeset(GA_stan_all_acq, GA_stan4_fam);
GA_stan_all_acq = pop_mergeset(GA_stan_all_acq, GA_stan4_unfam); 
GA_stan_all_acq.data = mean(GA_stan_all_acq.data(:,:,:),3);

GA_dev_all_rec = pop_mergeset(GA_dev12_fam, GA_dev12_unfam);
GA_dev_all_rec = pop_mergeset(GA_dev_all_rec, GA_dev3_fam); 
GA_dev_all_rec = pop_mergeset(GA_dev_all_rec, GA_dev3_unfam); 
GA_dev_all_rec = pop_mergeset(GA_dev_all_rec, GA_dev4_fam);
GA_dev_all_rec = pop_mergeset(GA_dev_all_rec, GA_dev4_unfam);
GA_dev_all_rec.data = mean(GA_dev_all_rec.data(:,:,:),3);

GA_stan_all_rec = pop_mergeset(GA_stan12_fam, GA_stan12_unfam);
GA_stan_all_rec = pop_mergeset(GA_stan_all_rec, GA_stan3_fam);
GA_stan_all_rec = pop_mergeset(GA_stan_all_rec, GA_stan3_unfam); 
GA_stan_all_rec = pop_mergeset(GA_stan_all_rec, GA_stan4_fam);
GA_stan_all_rec = pop_mergeset(GA_stan_all_rec, GA_stan4_unfam);
GA_stan_all_rec.data = mean(GA_stan_all_rec.data(:,:,:),3);

% Compute difference waves
DIFF_12_fam = GA_dev12_fam.data - GA_stan12_fam.data;
DIFF_12_unfam = GA_dev12_unfam.data - GA_stan12_unfam.data;
DIFF_3_fam = GA_dev3_fam.data - GA_stan3_fam.data;
DIFF_3_unfam = GA_dev3_unfam.data - GA_stan3_unfam.data;
DIFF_4_fam = GA_dev4_fam.data - GA_stan4_fam.data;
DIFF_4_unfam = GA_dev4_unfam.data - GA_stan4_unfam.data;

DIFF_all_acq = GA_dev_all_acq.data - GA_stan_all_acq.data;
DIFF_all_rec = GA_dev_all_rec.data - GA_stan_all_rec.data;

rmpath(genpath(DIR.EEGLAB_PATH));


% find indices of ROI channels
indices = zeros(1, numel(ROI_labels));

% loop over labels and find indices
for i = 1:numel(ROI_labels)
    label = ROI_labels{i};
    for j = 1:numel(GA_dev_all_acq.chanlocs)
        if strcmp(GA_dev_all_acq.chanlocs(j).labels, label)
            indices(i) = j;
            break;
        end
    end
end

%% TRAINING SPEAKER FAM
fig = figure;
h1 = plot(GA_dev12_fam.times, ...
    mean(DIFF_12_fam(indices(1:length(indices)),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12_fam.times, ...
    mean(GA_dev12_fam.data(indices(1:length(indices)),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev12_fam.times, ...
    mean(GA_stan12_fam.data(indices(1:length(indices)),:)), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-10 10]; 
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
title('Training speaker - Familiar voice condition')
subtitle('F3, Fz, F4, F7, F8, FC5, FC6, Cz, C3, C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent background, set both here and one line above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none')
exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
    'Trainingspeaker_FAM_woBLcorr.jpeg'), ...
    'Resolution', 300);

%% TRAINING SPEAKER UNFAM
fig = figure;
h1 = plot(GA_dev12_unfam.times, ...
    mean(DIFF_12_unfam(indices(1:length(indices)),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12_unfam.times, ...
    mean(GA_dev12_unfam.data(indices(1:length(indices)),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev12_unfam.times, ...
    mean(GA_stan12_unfam.data(indices(1:length(indices)),:)), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-10 10]; 
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
title('Training speaker - Unfamiliar voice condition')
subtitle('F3, Fz, F4, F7, F8, FC5, FC6, Cz, C3, C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent background, set both here and one line above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none')
exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
    'Trainingspeaker_UNFAM_woBLcorr.jpeg'), ...
    'Resolution', 300);

%% SPEAKER 3 FAM
fig = figure;
h1 = plot(GA_dev3_fam.times, ...
    mean(DIFF_3_fam(indices(1:length(indices)),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3_fam.times, ...
    mean(GA_dev3_fam.data(indices(1:length(indices)),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev3_fam.times, ...
    mean(GA_stan3_fam.data(indices(1:length(indices)),:)), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-10 10]; 
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
title('Familiar non-training speaker - Familiar voice condition')
subtitle('F3, Fz, F4, F7, F8, FC5, FC6, Cz, C3, C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent background, set both here and one line above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none')
exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
    'S3_FAM_woBLcorr.jpeg'), ...
    'Resolution', 300);

%% SPEAKER 3 UNFAM
fig = figure;
h1 = plot(GA_dev3_unfam.times, ...
    mean(DIFF_3_unfam(indices(1:length(indices)),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev3_unfam.times, ...
    mean(GA_dev3_unfam.data(indices(1:length(indices)),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev3_unfam.times, ...
    mean(GA_stan3_unfam.data(indices(1:length(indices)),:)), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-10 10]; 
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
title('Familiar non-training speaker - Unfamiliar voice condition')
subtitle('F3, Fz, F4, F7, F8, FC5, FC6, Cz, C3, C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent background, set both here and one line above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none')
exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
    'S3_UNFAM_woBLcorr.jpeg'), ...
    'Resolution', 300);


%% SPEAKER 4 FAM
fig = figure;
h1 = plot(GA_dev4_fam.times, ...
    mean(DIFF_4_fam(indices(1:length(indices)),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4_fam.times, ...
    mean(GA_dev4_fam.data(indices(1:length(indices)),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev4_fam.times, ...
    mean(GA_stan4_fam.data(indices(1:length(indices)),:)), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-10 10]; 
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
title('Novel speaker - Familiar voice condition')
subtitle('F3, Fz, F4, F7, F8, FC5, FC6, Cz, C3, C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent background, set both here and one line above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none')
exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
    'S4_FAM_woBLcorr.jpeg'), ...
    'Resolution', 300);


%% SPEAKER 4 UNFAM
fig = figure;
h1 = plot(GA_dev4_unfam.times, ...
    mean(DIFF_4_unfam(indices(1:length(indices)),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev4_unfam.times, ...
    mean(GA_dev4_unfam.data(indices(1:length(indices)),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev4_unfam.times, ...
    mean(GA_stan4_unfam.data(indices(1:length(indices)),:)), ...
    'Color', '#3b8dca', 'Linewidth', 2);
hold on;

% Set axes
ylims = [-10 10]; 
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
title('Novel speaker - Unfamiliar voice condition')
subtitle('F3, Fz, F4, F7, F8, FC5, FC6, Cz, C3, C4')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle
%set(gca,'color','none'); % if you want transparent background, set both here and one line above to 'none'

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none')
exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
    'S4_UNFAM_woBLcorr.jpeg'), ...
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

% Define chanlocs (same everywhere!)
chanlocs = GA_dev12_fam.chanlocs;

% All speakers ACQ --------------------------------------------------------
TIME1   = twstartacq/1000; % time after stimulus onset (in seconds)
TIME2   = twendacq/1000; % time after Stimulus onset (in seconds)
sample1 = round(eeg_lat2point(TIME1,1,GA_dev12_fam.srate,[GA_dev12_fam.xmin GA_dev12_fam.xmax]));% convert TIME into EEG sampling point:
sample2 = round(eeg_lat2point(TIME2,1,GA_dev12_fam.srate,[GA_dev12_fam.xmin GA_dev12_fam.xmax])); % convert TIME into EEG sampling point:

DIFF1 = DIFF_all_acq; % difference across mean of all subjects
DIFF_T1 = DIFF1(:,sample1:sample2); % new matrix with values from TIME1-TIME2 ms
DIFF_TW1 = mean(DIFF_T1,2); % calculate average

fig = figure;
%topoplot(DIFF_TW1(:,:), chanlocs, 'maplimits',[-5 5], 'style', 'fill', 'nosedir', '+X');
EEG.chaninfo.plotrad = 0.5;
topoplot(DIFF_TW1(:,:), chanlocs, 'maplimits',[-8 8], 'style', 'straight', 'nosedir', '+X', ...
    'electrodes', 'labels', 'plotrad', 0.5);

colorbar
title(strcat('All speakers ACQ (Difference): ', int2str(twstartacq), '-', int2str(twendacq), ' ms'));
exportgraphics(gcf, strcat(DIR.plotsERPproc, 'AllspeakersACQ_topo_woBLcorr.jpeg'), 'Resolution', 300);


% All speakers REC --------------------------------------------------------
TIME1   = twstartrec/1000; % time after stimulus onset (in seconds)
TIME2   = twendrec/1000; % time after Stimulus onset (in seconds)
sample1 = round(eeg_lat2point(TIME1,1,GA_dev12_fam.srate,[GA_dev12_fam.xmin GA_dev12_fam.xmax]));% convert TIME into EEG sampling point:
sample2 = round(eeg_lat2point(TIME2,1,GA_dev12_fam.srate,[GA_dev12_fam.xmin GA_dev12_fam.xmax])); % convert TIME into EEG sampling point:

DIFF1 = DIFF_all_rec; % difference across mean of all subjects
DIFF_T1 = DIFF1(:,sample1:sample2); % new matrix with values from TIME1-TIME2 ms
DIFF_TW1 = mean(DIFF_T1,2); % calculate average

fig = figure;
%topoplot(DIFF_TW1(:,:), chanlocs, 'maplimits',[-5 5], 'style', 'fill', 'nosedir', '+X');
topoplot(DIFF_TW1(:,:), chanlocs, 'maplimits',[-8 8], 'style', 'straight', 'nosedir', '+X', ...
    'electrodes', 'labels');
colorbar
title(strcat('All speakers REC (Difference): ', int2str(twstartrec), '-', int2str(twendrec), ' ms'));
exportgraphics(gcf, strcat(DIR.plotsERPproc, 'AllspeakersREC_topo_woBLcorr.jpeg'), 'Resolution', 300);

% You can add the rest of the topoplots later, if needed.


%% Make empty head plot for legend
% to make this plot, I increased the fontsize in topoplot.m:
% p_02453/packages/eeglab2021.0/functions/sigprocfunctions, change line 257
% to EFSIZE = 15; % use current default fontsize for electrode labels

% % remove functional electrodes (watch out: the numbers change after
% removing one:)
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
% exportgraphics(gcf, strcat(DIR.plotsERPproc, 'EmptyHead.jpeg'), 'Resolution', 300);

%% To add legend to the ERP plots, make one plot with this added, and copy to the other plots:
% legend([h1, h2, h3], ...
%     {'Difference', ...
%     'Deviant (fɪ)', ...
%     'Standard (fɛ)'}, ...
%     'Location','northeast');




end



function plot_averagedData_woBLcor(DIR)


%% Set up
ROI_labels = {'Fz', 'F3', 'F4', 'FC5', 'FC6', 'Cz', 'C3', 'C4'};
maybeROI_labels = {'F7', 'F8', 'F9', 'F10', 'V2', 'Fp2'};


%% Collapsed localizer for ACQUISITION RQ
% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

cd(DIR.grandaverage_woBLcorr);

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

% find indices of ROI channels
indices = zeros(1, numel(ROI_labels));

% loop over labels and find indices
for i = 1:numel(ROI_labels)
    label = ROI_labels{i};
    for j = 1:numel(GA_dev_all.chanlocs)
        if strcmp(GA_dev_all.chanlocs(j).labels, label)
            indices(i) = j;
            break;
        end
    end
end

%% ACQ ALL 
fig = figure;
h1 = plot(GA_dev_all.times, ...
    mean(DIFF(indices(1:8),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    mean(GA_dev_all.data(indices(1:8),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    mean(GA_stan_all.data(indices(1:8),:)), ...
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
title('Collapsed localizer ACQ All - Without BL Correction')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_ACQ_all_woBLcorr.jpeg'), ...
    'Resolution', 300);



%% Collapsed localizer for RECOGNITION RQ
% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

cd(DIR.grandaverage_woBLcorr);

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



%% REC ALL
fig = figure;
h1 = plot(GA_dev_all.times, ...
    mean(DIFF(indices(1:8),:)), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev_all.times, ...
    mean(GA_dev_all.data(indices(1:8),:)), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev_all.times, ...
    mean(GA_stan_all.data(indices(1:8),:)), ...
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
title('Collapsed localizer REC - Without BL Correction')
xlabel('msec')
ylabel('µV')

% General make prettier
ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure. 
box(ax, 'off'); % remove box
ax.FontSize = 10; 
%daspect([100 5 2]); % change ratio
set(gcf,'color','white'); % white background. gcf = current figure handle

% Ticks
ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
ax.XTickLabel = {'-100','0','','','','','','600',''};
ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15'};

% mchange orientation and location y-label
hYLabel = get(gca,'YLabel'); % gca = current axes
set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

set(gca,'LineWidth',1)

% Save figure (for transparent figure, add 'BackgroundColor', 'none'
exportgraphics(gcf, strcat(DIR.plotsCL, ...
    'ERP_Colloc_REC_all_woBLcorr.jpeg'), ...
    'Resolution', 300);


end



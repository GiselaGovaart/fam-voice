function plot_ERP_proc_perelectrodeROI(DIR)

% Plot the ERPs for each electrode seperately, collapsed over Group and
% Testspeaker, per RQ 


%% Set up
ROI_labels = {'Fz', 'F3', 'F4', 'FC5', 'FC6', 'Cz', 'C3', 'C4', 'F7', 'F8'};


%% ACQUISITION RQ
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



%% ACQ per electrode
for chan = 1:length(ROI_labels)
    fig = figure;
    h1 = plot(GA_dev_all.times, ...
        DIFF(indices(chan),:), ...
        'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
    hold on;
    h2 = plot(GA_dev_all.times, ...
        GA_dev_all.data(indices(chan),:), ...
        'Color', '#f78d95', 'Linewidth', 2);
    hold on;
    h3 = plot(GA_dev_all.times, ...
        GA_stan_all.data(indices(chan),:), ...
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
    titleText = strcat("ACQ: ",ROI_labels(chan));
    title(titleText)
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
    ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15', '20'};

    % mchange orientation and location y-label
    hYLabel = get(gca,'YLabel'); % gca = current axes
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

    set(gca,'LineWidth',1)

    % Save figure (for transparent figure, add 'BackgroundColor', 'none'
    fileName = strcat("ERP_ACQ_", ROI_labels(chan),".jpeg");
    exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
        fileName), ...
        'Resolution', 300);
end

%% once seperately for Fz to compare with SD plot

 fig = figure;
    h1 = plot(GA_dev_all.times, ...
        DIFF(14,:), ...
        'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
    hold on;
    h2 = plot(GA_dev_all.times, ...
        GA_dev_all.data(14,:), ...
        'Color', '#f78d95', 'Linewidth', 2);
    hold on;
    h3 = plot(GA_dev_all.times, ...
        GA_stan_all.data(14,:), ...
        'Color', '#3b8dca', 'Linewidth', 2);
    hold on;

    % Set axes
    ylims = [-5 5];
    xlims = [-200 700];
    ylim(ylims);
    xlim(xlims);
    %set(gca,'YDir','reverse'); % reverse axes

    % Add lines
    hline = line(xlim, [0,0],'LineWidth',1);
    hline.Color = 'black';
    vline = line([0 0], ylim,'LineWidth',1);
    vline.Color = 'black';

    % Title, labels, legend
    titleText = ("ACQ: Fz - flipped");
    title(titleText)
    xlabel('msec')
    ylabel('µV')

    % General make prettier
    ax = gca; % ax = gca returns the current axes (or standalone visualization) in the current figure.
    box(ax, 'off'); % remove box
    ax.FontSize = 10;
    %%daspect([100 5 2]); % change ratio
    set(gcf,'color','white'); % white background. gcf = current figure handle

    % Ticks
    ax.XTick = [-100 0 100 200 300 400 500 600 650]; % starting point, steps, end point
    ax.XTickLabel = {'-100','0','','','','','','600',''};
    ax.YTick = [-20 -15 -10 -5 0 5 10 15 20];
    ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15', '20'};

    % mchange orientation and location y-label
    hYLabel = get(gca,'YLabel'); % gca = current axes
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

    set(gca,'LineWidth',1)

    % Save figure (for transparent figure, add 'BackgroundColor', 'none'
    fileName = "ERP_ACQ_Fz_flipped.jpeg";
    exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
        fileName), ...
        'Resolution', 300);
%% RECOGNITION RQ
% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

cd(DIR.grandaverage);
% Make GAs for RQ:
GA_dev12_fam = pop_loadset('ga_fam_S12_Dev.set');
GA_dev12_unfam = pop_loadset('ga_unfam_S12_Dev.set');
GA_dev4_unfam = pop_loadset('ga_unfam_S4_Dev.set');
GA_dev3_unfam = pop_loadset('ga_unfam_S3_Dev.set');

GA_dev_all = pop_mergeset(GA_dev12_fam, GA_dev12_unfam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev4_unfam);
GA_dev_all = pop_mergeset(GA_dev_all, GA_dev3_unfam); 
GA_dev_all.data = mean(GA_dev_all.data(:,:,:),3);

GA_stan12_fam = pop_loadset('ga_fam_S12_Stan.set');
GA_stan12_unfam = pop_loadset('ga_unfam_S12_Stan.set');
GA_stan4_unfam = pop_loadset('ga_unfam_S4_Stan.set');
GA_stan3_unfam = pop_loadset('ga_unfam_S3_Stan.set');

GA_stan_all = pop_mergeset(GA_stan12_fam, GA_stan12_unfam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan4_unfam);
GA_stan_all = pop_mergeset(GA_stan_all, GA_stan3_unfam); 
GA_stan_all.data = mean(GA_stan_all.data(:,:,:),3);

DIFF = GA_dev_all.data - GA_stan_all.data;

rmpath(genpath(DIR.EEGLAB_PATH)); 



%% REC per electrode
for chan = 1:length(ROI_labels)
    fig = figure;
    h1 = plot(GA_dev_all.times, ...
        DIFF(indices(chan),:), ...
        'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
    hold on;
    h2 = plot(GA_dev_all.times, ...
        GA_dev_all.data(indices(chan),:), ...
        'Color', '#f78d95', 'Linewidth', 2);
    hold on;
    h3 = plot(GA_dev_all.times, ...
        GA_stan_all.data(indices(chan),:), ...
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
    titleText = strcat("REC: ",ROI_labels(chan));
    title(titleText)
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
    ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15', '20'};

    % mchange orientation and location y-label
    hYLabel = get(gca,'YLabel'); % gca = current axes
    set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')

    set(gca,'LineWidth',1)

    % Save figure (for transparent figure, add 'BackgroundColor', 'none'
    fileName = strcat("ERP_REC_",ROI_labels(chan),".jpeg");
    exportgraphics(gcf, strcat(DIR.plotsERPproc, ...
        fileName), ...
        'Resolution', 300);
end







end
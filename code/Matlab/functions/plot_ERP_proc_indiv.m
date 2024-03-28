function plot_ERP_proc_indiv(Subj, DIR)
% Get ERP per subject per testspeaker

% NB: if you add F7 anf F8 to the ROI, add it here!


% load EEGlab 
% DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
% rmpath(genpath(DIR.EEGLAB_PATH)); 
% cd(DIR.EEGLAB_PATH);
% eeglab; close;

DIR.processed = convertStringsToChars(DIR.processed);
DIR.grandaverage = convertStringsToChars(DIR.grandaverage);

%% Set up ADAPT based on final ROI

ROI_labels = {'Fz', 'F3', 'F4', 'FC5', 'FC6', 'Cz', 'C3', 'C4'};
   
% open mock set
cd(DIR.EEGLAB_PATH);
eeglab; close;

mocksetname = strcat(Subj(1),"_processed_103.set");
mockset = pop_loadset(convertStringsToChars(mocksetname));

% find indices of ROI channels
indices = zeros(1, numel(ROI_labels));

% loop over labels and find indices
for i = 1:numel(ROI_labels)
    label = ROI_labels{i};
    for j = 1:numel(mockset.chanlocs)
        if strcmp(mockset.chanlocs(j).labels, label)
            indices(i) = j;
            break;
        end
    end
end

%% Make individual plot for training speaker (1 or 2)
cd(DIR.processed)

for ipp = 1:length(Subj)

    cd(DIR.EEGLAB_PATH);
    eeglab; close;

    setNameD1 = strcat(Subj(ipp),"_processed_101.set");
    setNameD2 = strcat(Subj(ipp),"_processed_102.set");
    if isfile(strcat(DIR.processed,setNameD1))
    setNameD = setNameD1;
    elseif isfile(strcat(DIR.processed,setNameD2))
    setNameD = setNameD2;
    end

    setNameS11 = strcat(Subj(ipp),"_processed_221.set");
    setNameS12 = strcat(Subj(ipp),"_processed_222.set");
    if isfile(strcat(DIR.processed,setNameS11))
    setNameS1 = setNameS11;
    elseif isfile(strcat(DIR.processed,setNameS12))
    setNameS1 = setNameS12;
    end

    setNameS21 = strcat(Subj(ipp),"_processed_231.set");
    setNameS22 = strcat(Subj(ipp),"_processed_232.set");
    if isfile(strcat(DIR.processed,setNameS21))
    setNameS2 = setNameS21;
    elseif isfile(strcat(DIR.processed,setNameS22))
    setNameS2 = setNameS22;
    end

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
        setD.data = mean(setD.data(:,:,:),3);

    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;

    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
        setS = pop_mergeset(setS1, setS2);
        setS.data = mean(setS.data(:,:,:),3);

    end
    
     % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"

        % PLOT
        DIFF = setD.data - setS.data;

        rmpath(genpath(DIR.EEGLAB_PATH));

        fig = figure;
        h1 = plot(setS.times, ...
            mean(DIFF(indices(1:8),:)), ...
            'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
        hold on;
        h2 = plot(setS.times, ...
            mean(setD.data(indices(1:8),:)), ...
            'Color', '#f78d95', 'Linewidth', 2);
        hold on;
        h3 = plot(setS.times, ...
            mean(setS.data(indices(1:8),:)), ...
            'Color', '#3b8dca', 'Linewidth', 2);
        hold on;

        % Set axes
        ylims = [-20 20];
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
        ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15','20'};
        % mchange orientation and location y-label
        hYLabel = get(gca,'YLabel'); % gca = current axes
        set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
        set(gca,'LineWidth',1)
        % Save figure (for transparent figure, add 'BackgroundColor', 'none'
        exportgraphics(gcf, strcat(DIR.plotsERPindiv, ...
            strcat(Subj(ipp),'_Trainingspeaker_ROI.jpeg')), ...
            'Resolution', 300);

    end
end


%% Make individual plot for speaker 3
cd(DIR.processed)

for ipp = 1:length(Subj)

    cd(DIR.EEGLAB_PATH);
    eeglab; close;

    setNameD = strcat(Subj(ipp),"_processed_103.set");
    setNameS1 = strcat(Subj(ipp),"_processed_223.set");
    setNameS2 = strcat(Subj(ipp),"_processed_233.set");

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
        setD.data = mean(setD.data(:,:,:),3);

    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;

    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
        setS = pop_mergeset(setS1, setS2);
        setS.data = mean(setS.data(:,:,:),3);

    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"

        % PLOT
        DIFF = setD.data - setS.data;

        rmpath(genpath(DIR.EEGLAB_PATH));

        fig = figure;
        h1 = plot(setS.times, ...
            mean(DIFF(indices(1:8),:)), ...
            'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
        hold on;
        h2 = plot(setS.times, ...
            mean(setD.data(indices(1:8),:)), ...
            'Color', '#f78d95', 'Linewidth', 2);
        hold on;
        h3 = plot(setS.times, ...
            mean(setS.data(indices(1:8),:)), ...
            'Color', '#3b8dca', 'Linewidth', 2);
        hold on;

        % Set axes
        ylims = [-20 20];
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
        ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15','20'};
        % mchange orientation and location y-label
        hYLabel = get(gca,'YLabel'); % gca = current axes
        set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
        set(gca,'LineWidth',1)
        % Save figure (for transparent figure, add 'BackgroundColor', 'none'
        exportgraphics(gcf, strcat(DIR.plotsERPindiv, ...
            strcat(Subj(ipp),'_Speaker3_ROI.jpeg')), ...
            'Resolution', 300);

    end
end

%% Make individual plot for speaker 4  
cd(DIR.processed)

for ipp = 1:length(Subj)

    cd(DIR.EEGLAB_PATH);
    eeglab; close;

    setNameD = strcat(Subj(ipp),"_processed_104.set");
    setNameS1 = strcat(Subj(ipp),"_processed_224.set");
    setNameS2 = strcat(Subj(ipp),"_processed_234.set");
    
    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
        setD.data = mean(setD.data(:,:,:),3);

    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;

    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
        setS = pop_mergeset(setS1, setS2);
        setS.data = mean(setS.data(:,:,:),3);

    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"

        % PLOT
        DIFF = setD.data - setS.data;

        rmpath(genpath(DIR.EEGLAB_PATH));

        fig = figure;
        h1 = plot(setS.times, ...
            mean(DIFF(indices(1:8),:)), ...
            'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
        hold on;
        h2 = plot(setS.times, ...
            mean(setD.data(indices(1:8),:)), ...
            'Color', '#f78d95', 'Linewidth', 2);
        hold on;
        h3 = plot(setS.times, ...
            mean(setS.data(indices(1:8),:)), ...
            'Color', '#3b8dca', 'Linewidth', 2);
        hold on;

        % Set axes
        ylims = [-20 20];
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
        ax.YTickLabel = {'-20','-15', '-10','-5','0','5', '10', '15','20'};
        % mchange orientation and location y-label
        hYLabel = get(gca,'YLabel'); % gca = current axes
        set(hYLabel,'rotation',0,'VerticalAlignment','middle', 'HorizontalAlignment', 'right')
        set(gca,'LineWidth',1)
        % Save figure (for transparent figure, add 'BackgroundColor', 'none'
        exportgraphics(gcf, strcat(DIR.plotsERPindiv, ...
            strcat(Subj(ipp),'_Speaker4_ROI.jpeg')), ...
            'Resolution', 300);

    end
end


end
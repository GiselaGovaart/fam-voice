function plot_ERP_raw_plot(Subj, DIR)
% This script basically combines computeGA.m & the plotting code from
% plot_colloc.m, for the raw data.

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

% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

DIR.processed = convertStringsToChars(DIR.processed);
DIR.grandaverage = convertStringsToChars(DIR.grandaverage);

%% Make GA for training speaker (1 or 2)
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD1 = strcat(Subj(ipp),"_RAW_101.set");
    setNameD2 = strcat(Subj(ipp),"_RAW_102.set");
    if isfile(strcat(DIR.processed,setNameD1))
    setNameD = setNameD1;
    elseif isfile(strcat(DIR.processed,setNameD2))
    setNameD = setNameD2;
    end

    setNameS11 = strcat(Subj(ipp),"_RAW_221.set");
    setNameS12 = strcat(Subj(ipp),"_RAW_222.set");
    if isfile(strcat(DIR.processed,setNameS11))
    setNameS1 = setNameS11;
    elseif isfile(strcat(DIR.processed,setNameS12))
    setNameS1 = setNameS12;
    end

    setNameS21 = strcat(Subj(ipp),"_RAW_231.set");
    setNameS22 = strcat(Subj(ipp),"_RAW_232.set");
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
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_1012 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_2212 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_2312 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_2212, ga_2312);
pop_saveset(GA_merged, 'filename', 'ga_S12_Stan_RAW.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_1012, 'filename', 'ga_S12_Dev_RAW.set', ...
        'filepath', DIR.grandaverage);

%% Make GA for Speaker 3
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_RAW_103.set");
    setNameS1 = strcat(Subj(ipp),"_RAW_223.set");
    setNameS2 = strcat(Subj(ipp),"_RAW_233.set");

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
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
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_103 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_223 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_233 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_223, ga_233);
pop_saveset(GA_merged, 'filename', 'ga_S3_Stan_RAW.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_103, 'filename', 'ga_S3_Dev_RAW.set', ...
        'filepath', DIR.grandaverage);

%% Make GA for Speaker 4
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_RAW_104.set");
    setNameS1 = strcat(Subj(ipp),"_RAW_224.set");
    setNameS2 = strcat(Subj(ipp),"_RAW_234.set");

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
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
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_104 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_224 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_234 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_224, ga_234);

pop_saveset(GA_merged, 'filename', 'ga_S4_Stan_RAW.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_104, 'filename', 'ga_S4_Dev_RAW.set', ...
        'filepath', DIR.grandaverage);

%% PLOT
cd(DIR.grandaverage);

GA_dev12 = pop_loadset('ga_S12_Dev_RAW.set');
GA_dev12.data = mean(GA_dev12.data(:,:,:),3);
GA_dev3 = pop_loadset('ga_S3_Dev_RAW.set');
GA_dev3.data = mean(GA_dev3.data(:,:,:),3);
GA_dev4 = pop_loadset('ga_S4_Dev_RAW.set');
GA_dev4.data = mean(GA_dev4.data(:,:,:),3);

GA_stan12 = pop_loadset('ga_S12_Stan_RAW.set');
GA_stan12.data = mean(GA_stan12.data(:,:,:),3);
GA_stan3 = pop_loadset('ga_S3_Stan_RAW.set');
GA_stan3.data = mean(GA_stan3.data(:,:,:),3);
GA_stan4 = pop_loadset('ga_S4_Stan_RAW.set');
GA_stan4.data = mean(GA_stan4.data(:,:,:),3);

DIFF_12 = GA_dev12.data - GA_stan12.data;
DIFF_3 = GA_dev3.data - GA_stan3.data;
DIFF_4 = GA_dev4.data - GA_stan4.data;

GA_dev_all.data = (GA_dev12.data + GA_dev3.data  + GA_dev4.data)/3 ;
GA_stan_all.data = (GA_stan12.data + GA_stan3.data  + GA_stan4.data)/3 ;
DIFF_all = GA_dev_all.data - GA_stan_all.data;

rmpath(genpath(DIR.EEGLAB_PATH)); 


fig = figure;
h1 = plot(GA_dev12.times, ...
    ((DIFF_all(Fz,:,:)+DIFF_all(F3,:,:)+DIFF_all(F4,:,:)+ ...
    DIFF_all(FC5,:,:)+DIFF_all(FC6,:,:)) ...
    /6), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    ((GA_dev_all.data(Fz,:,:)+GA_dev_all.data(F3,:,:)+GA_dev_all.data(F4,:,:)+ ...
    GA_dev_all.data(FC5,:,:)+GA_dev_all.data(FC6,:,:)) ...
    /6), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev12.times, ...
    ((GA_stan_all.data(Fz,:,:)+GA_stan_all.data(F3,:,:)+GA_stan_all.data(F4,:,:)+ ...
    +GA_stan_all.data(FC5,:,:)+GA_stan_all.data(FC6,:,:)) ...
    /6), ...
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
subtitle('F3, Fz, F4, C3, C4')
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
exportgraphics(gcf, strcat(DIR.plotsERPraw, ...
    'AllSpeakers_F3FzF4FC5FC6_RAW_waveletted.jpeg'), ...
    'Resolution', 300);


end


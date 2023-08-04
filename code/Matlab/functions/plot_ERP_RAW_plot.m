function plot_ERP_RAW_plot(Subj, DIR)

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

    setD = pop_loadset(convertStringsToChars(setNameD));
    setS1 = pop_loadset(convertStringsToChars(setNameS1));
    setS2 = pop_loadset(convertStringsToChars(setNameS2));
    trialsD = setD.trials;
    trialsS1 = setS1.trials;
    trialsS2 = setS2.trials;

    if trialsD > 9 && trialsS1 > 9 && trialsS2 > 9
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


%test
% EG1 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/01_RAW_221.set')
% EG2 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/02_RAW_221.set')
% EG4 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/04_RAW_222.set')
% EG5 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/05_RAW_221.set')
% EG6 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/06_RAW_221.set')
% EG7 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/07_RAW_222.set')
% EG8 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/08_RAW_222.set')
% EG9 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/09_RAW_221.set')
% EG10 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/10_RAW_221.set')
% EG11 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/11_RAW_222.set')
% EG12 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/12_RAW_222.set')
% EG13 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/13_RAW_221.set')
% EG15 = pop_loadset('/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/finalParams_linenoise2.5_lineFrequencies50-100/05-processed/15_RAW_222.set')
% 

% Deviants
EEG = pop_grandaverage(GAargD, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_101-102');
EEG = pop_saveset(EEG, 'filename', 'ga_101-102_RAW.set', ...
    'filepath', DIR.grandaverage);
% S1
EEG = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_221-222');
EEG = pop_saveset(EEG, 'filename', 'ga_221-222_RAW.set', ...
    'filepath', DIR.grandaverage);
% S2
EEG = pop_grandaverage(GAargS2, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_231-232');
EEG = pop_saveset(EEG, 'filename', 'ga_231-232_RAW.set', ...
    'filepath', DIR.grandaverage);

cd(DIR.grandaverage);
ga_1012 = pop_loadset('ga_101-102_RAW.set');
ga_2212 = pop_loadset('ga_221-222_RAW.set');
ga_2312 = pop_loadset('ga_231-232_RAW.set');

GA_merged = pop_mergeset(ga_2212, ga_2312);
EEG = pop_saveset(GA_merged, 'filename', 'ga_S12_Stan_RAW.set', ...
        'filepath', DIR.grandaverage);
EEG = pop_saveset(ga_1012, 'filename', 'ga_S12_Dev_RAW.set', ...
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
    setD = pop_loadset(convertStringsToChars(setNameD));
    setS1 = pop_loadset(convertStringsToChars(setNameS1));
    setS2 = pop_loadset(convertStringsToChars(setNameS2));
    trialsD = setD.trials;
    trialsS1 = setS1.trials;
    trialsS2 = setS2.trials;

    if trialsD > 9 && trialsS1 > 9 && trialsS2 > 9
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
EEG = pop_grandaverage(GAargD, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_103');
EEG = pop_saveset(EEG, 'filename', 'ga_103_RAW.set', ...
    'filepath', DIR.grandaverage);
% S1
EEG = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_223');
EEG = pop_saveset(EEG, 'filename', 'ga_223_RAW.set', ...
    'filepath', DIR.grandaverage);
% S2
EEG = pop_grandaverage(GAargS2, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_233');
EEG = pop_saveset(EEG, 'filename', 'ga_233_RAW.set', ...
    'filepath', DIR.grandaverage);

cd(DIR.grandaverage);
ga_103 = pop_loadset('ga_103_RAW.set');
ga_223 = pop_loadset('ga_223_RAW.set');
ga_233 = pop_loadset('ga_233_RAW.set');

GA_merged = pop_mergeset(ga_223, ga_233);
EEG = pop_saveset(GA_merged, 'filename', 'ga_S3_Stan_RAW.set', ...
        'filepath', DIR.grandaverage);
EEG = pop_saveset(ga_103, 'filename', 'ga_S3_Dev_RAW.set', ...
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
    setD = pop_loadset(convertStringsToChars(setNameD));
    setS1 = pop_loadset(convertStringsToChars(setNameS1));
    setS2 = pop_loadset(convertStringsToChars(setNameS2));
    trialsD = setD.trials;
    trialsS1 = setS1.trials;
    trialsS2 = setS2.trials;

    if trialsD > 9 && trialsS1 > 9 && trialsS2 > 9
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
EEG = pop_grandaverage(GAargD, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_104');
EEG = pop_saveset(EEG, 'filename', 'ga_104_RAW.set', ...
    'filepath', DIR.grandaverage);
% S1
EEG = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_224');
EEG = pop_saveset(EEG, 'filename', 'ga_224_RAW.set', ...
    'filepath', DIR.grandaverage);
% S2
EEG = pop_grandaverage(GAargS2, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_234');
EEG = pop_saveset(EEG, 'filename', 'ga_234_RAW.set', ...
    'filepath', DIR.grandaverage);

cd(DIR.grandaverage);
ga_104 = pop_loadset('ga_104_RAW.set');
ga_224 = pop_loadset('ga_224_RAW.set');
ga_234 = pop_loadset('ga_234_RAW.set');

GA_merged = pop_mergeset(ga_224, ga_234);

EEG = pop_saveset(GA_merged, 'filename', 'ga_S4_Stan_RAW.set', ...
        'filepath', DIR.grandaverage);
EEG = pop_saveset(ga_104, 'filename', 'ga_S4_Dev_RAW.set', ...
        'filepath', DIR.grandaverage);




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

Fz = 4;
F3 = 5;
F4 = 6;
%Cz = 28; this is the raw data so Cz is not there
C3 = 13;
C4 = 14;

%% ALL SPEAKERS Fz, F3, F4
fig = figure;
h1 = plot(GA_dev12.times, ...
    ((DIFF_all(Fz,:,:)+DIFF_all(F3,:,:)+DIFF_all(F4,:,:)+ ...
    DIFF_all(C3,:,:)+DIFF_all(C4,:,:)) ...
    /6), ...
    'Color', 'black', 'Linewidth', 3, 'LineStyle',':');
hold on;
h2 = plot(GA_dev12.times, ...
    ((GA_dev_all.data(Fz,:,:)+GA_dev_all.data(F3,:,:)+GA_dev_all.data(F4,:,:)+ ...
    GA_dev_all.data(C3,:,:)+GA_dev_all.data(C4,:,:)) ...
    /6), ...
    'Color', '#f78d95', 'Linewidth', 2);
hold on;
h3 = plot(GA_dev12.times, ...
    ((GA_stan_all.data(Fz,:,:)+GA_stan_all.data(F3,:,:)+GA_stan_all.data(F4,:,:)+ ...
    +GA_stan_all.data(C3,:,:)+GA_stan_all.data(C4,:,:)) ...
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
exportgraphics(gcf, strcat(DIR.grandaverage, ...
    'AllSpeakers_F3FzF4C3C4_RAW_reref.jpeg'), ...
    'Resolution', 300);


end


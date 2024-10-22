%% Paths you need

cd('/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab')

clear all; path(pathdef); clc; %reset session to clean

DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';

DIR.RAWEEG_PATH = '/data/p_02453/raw_eeg/pilot';
DIR.SET_PATH = '/data/p_02453/raw_eeg/pilot/raw-data-sets/';
% DIR.intermediateProcessing =  strcat(DIR.SET_PATH,"01-output/01-intermediate_processing/");
% DIR.waveletCleaned =  strcat(DIR.SET_PATH,"01-output/02-wavelet_cleaned_continuous/");
% DIR.ERPfiltered =  strcat(DIR.SET_PATH,"01-output/03-ERP_filtered/");
% DIR.segmenting =  strcat(DIR.SET_PATH,"01-output/04-segmenting/");
% DIR.processed =  strcat(DIR.SET_PATH,"01-output/05-processed/");
% DIR.qualityAssessment =  strcat(DIR.SET_PATH,"01-output/06-quality_assessment_outputs/");

DIR.REFA_PATH = '/data/p_02453/packages/eeglab2021.0/plugins/refa8import_v1.3/';
DIR.SCRIPTS = '/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab/functions';

% addpath(genpath(DIR.EEGLAB_PATH));  % this gives a warning
cd(DIR.EEGLAB_PATH);
eeglab; close;

addpath(genpath(DIR.RAWEEG_PATH));

addpath(DIR.REFA_PATH);
addpath(DIR.SCRIPTS);

cd(DIR.RAWEEG_PATH);

% load fieldtrip
addpath /data/p_02453/packages/fieldtrip-20230422
ft_defaults


%% Set subjects
% Subj = ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15"];
% Subj = ["02"];

Subj = ["01" "02" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "15"];

%% params to play with

% % STANDARD
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);
% 
% 
% % Filter2
% hptrans = 0.3;
% hpcutoff = 0.15;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);
% 
% % no baseline
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "no"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);
% 
% % 250 baseline
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -250;
% muscIL = "off"; % can be on or off
% detr = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);
% 
% 
% % threshold200
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 200;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);
% 
% 
% % soft
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Soft'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage_small(DIR); % exclude pp 6
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);
% 
% % Soft + 200
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 200;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Soft'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);

% version 2
hptrans = 0.4;
hpcutoff = 0.2;
hptransStr=sprintf('%.2f',hptrans);
hpcutoffStr=sprintf('%.2f',hpcutoff);
window = 'hamming'; % hamming or kaiser
beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
betaStr=sprintf('%.2f',beta);
threshold = 150;
minAmpValue = -threshold;
maxAmpValue = threshold;
wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
version = 2; % HAPPE2 or HAPPE 3
baseline = "yes"; % can be yes or no
blvalue = -200;
muscIL = "off"; % can be on or off
detr = "off"; % can be on or off

%if dir does not exist, create new one
if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
        "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
        "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
        "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
    DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
        baseline, blvalue, muscIL, detr);
else
    DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
        baseline, blvalue, muscIL, detr);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end


for pp = Subj
    makeSetsEEG(pp,DIR)
    HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
        wavThreshold, version, baseline, blvalue, muscIL, detr)
end

computeGrandAverage_small(DIR); % exclude pp 6
plotERPs(DIR);
plotERPs_withSD(DIR);
write_output_tables(Subj, DIR);

% % detrend on (with filter)
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "on"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);
% 
% 
% % detrend on (without filter)
% hptrans = 0.4;
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'nofilter'; % hamming or kaiser (or no filter)
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detr = "on"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% plotERPs_withSD(DIR);
% write_output_tables(Subj, DIR);


% muscl on
% hptrans = 0.4; l,─
% hpcutoff = 0.2;
% hptransStr=sprintf('%.2f',hptrans);
% hpcutoffStr=sprintf('%.2f',hpcutoff);
% window = 'hamming'; % hamming or kaiser (or no filter)
% beta = 0; % 7.857 or 5.653, or 0 for hamming (not relevant)
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "on"; % can be on or off
% detr = "off"; % can be on or off
% 
% if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR,  hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hptransStr, hpcutoffStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     to make sure that the DIR variable is also correct if the directory
%     previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hptrans, hpcutoff, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);











%% analysis
% Subj = (defined above)
% write a new function for the analysis, call that function here.

% Step 1: Collapsed localizer



%% Vizualization

% open filter figs
% fig1 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/hamming_015_5500_all.fig');
% fig2 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/hamming_02_8250_all.fig');
% fig3 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_56_015_6038_all.fig');
% fig4 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_56_02_9056_all.fig');
% fig5 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_78_015_8360_all.fig');
% fig6 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_78_02_12540_all.fig');





%% Reminder for the trigger codes
% For the test phase:
% •        First digit: 1 for dev, 2 for stan
% •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% •        Third digit: speakers: 1,2,3,4
% For the training phase:
% •        First digit: 1 for fe, 2 for fi
% •        Second digit: for speaker: 1 for S1, 2 for S2




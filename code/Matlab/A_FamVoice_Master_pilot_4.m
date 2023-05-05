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

% Subj = ["01" "02" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "15"];

Subj = ["01" "02" "04" "05" "07" "08" "09" "10" "11" "13" "15"];


%% params to play with

% % STANDARD
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
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
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detr);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detr)
% end
% 
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);

% filter 2
% hpFreqValue = 0.2;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);

% filter 3
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = "kaiser"; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);

% filter 4
% hpFreqValue = 0.2;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'kaiser'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);

% % filter 5
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'kaiser'; % hamming or kaiser
% beta = 5.653; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % filter 6
% hpFreqValue = 0.2;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'kaiser'; % hamming or kaiser
% beta = 5.653; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % threshold 200
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 200;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % threshold 100
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 100;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);

% soft
hpFreqValue = 0.3;
hpStr=sprintf('%.2f',hpFreqValue);
window = 'hamming'; % hamming or kaiser
beta = 7.857; % 7.857 or 5.653
betaStr=sprintf('%.2f',beta);
threshold = 150;
minAmpValue = -threshold;
maxAmpValue = threshold;
wavThreshold = 'Soft'; %can bse 'Hard' or 'Soft'
version = 3; % HAPPE2 or HAPPE 3
baseline = "yes"; % can be yes or no
blvalue = -200;
muscIL = "off"; % can be on or off
detrend = "off"; % can be on or off

%if dir does not exist, create new one
if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
        "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
        "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
    DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
        baseline, blvalue, muscIL, detrend);
else
    DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
        baseline, blvalue, muscIL, detrend);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end

for pp = Subj
    makeSetsEEG(pp,DIR)
    HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
        wavThreshold, version, baseline, blvalue, muscIL, detrend)
end

computeGrandAverage(DIR);
plotERPs(DIR);
write_output_tables(Subj, DIR);

% % soft + 200
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 200;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Soft'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % version 2
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 2; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % no baseline
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "no"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % baseline 150
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -150;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % baseline 100
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -100;
% muscIL = "off"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % muscil on
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "on"; % can be on or off
% detrend = "off"; % can be on or off
% 
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% % detrend on
% hpFreqValue = 0.3;
% hpStr=sprintf('%.2f',hpFreqValue);
% window = 'hamming'; % hamming or kaiser
% beta = 7.857; % 7.857 or 5.653
% betaStr=sprintf('%.2f',beta);
% threshold = 150;
% minAmpValue = -threshold;
% maxAmpValue = threshold;
% wavThreshold = 'Hard'; %can bse 'Hard' or 'Soft'
% version = 3; % HAPPE2 or HAPPE 3
% baseline = "yes"; % can be yes or no
% blvalue = -200;
% muscIL = "off"; % can be on or off
% detrend = "on"; % can be on or off
%  
% %if dir does not exist, create new one
% if ~exist(strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend), 'dir')
%     DIR = makeSubDirectory(DIR, hpStr, window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
% else
%     DIR = changeSubDirectoryPaths(DIR, hpStr,window, betaStr, threshold, wavThreshold, version, ...
%         baseline, blvalue, muscIL, detrend);
%     % to make sure that the DIR variable is also correct if the directory
%     % previously existed.
% end
% 
% for pp = Subj
%     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR, hpFreqValue, window, beta, minAmpValue, maxAmpValue, ...
%         wavThreshold, version, baseline, blvalue, muscIL, detrend)
% end
% 
% computeGrandAverage(DIR);
% plotERPs(DIR);
% write_output_tables(Subj, DIR);
% 
% 
% 
% 
% 
% 
% %% analysis
% % Subj = (defined above)
% % write a new function for the analysis, call that function here.
% 
% % Step 1: Collapsed localizer
% 
% 
% 
% %% Vizualization
% 
% % open filter figs
% % fig1 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/hamming_015_5500_all.fig');
% % fig2 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/hamming_02_8250_all.fig');
% % fig3 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_56_015_6038_all.fig');
% % fig4 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_56_02_9056_all.fig');
% % fig5 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_78_015_8360_all.fig');
% % fig6 = openfig('/data/p_02453/raw_eeg/pilot/Filter pics/kaiser_78_02_12540_all.fig');
% 
% 
% 
% 
% 
% %% Reminder for the trigger codes
% % For the test phase:
% % •        First digit: 1 for dev, 2 for stan
% % •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% % •        Third digit: speakers: 1,2,3,4
% % For the training phase:
% % •        First digit: 1 for fe, 2 for fi
% % •        Second digit: for speaker: 1 for S1, 2 for S2
% 
% 
% 

%% README
% This is the main script for the preprocessing of the EEG data for the
% papers:
% 1. Govaart, G. H., Chladkova, K., Schettino, A., & Männel, C. The Influence of Voice Information on Phoneme Learning in Infancy
% 2. Govaart, G. H., Chladkova, K., Schettino, A., & Männel, C. Is there a Voice-Familiarity Benefit for Phoneme Recognition in Infancy?

% Most of the analysis steps are equal between the papers. For the steps
% that are different:
% For paper 1, the analyses are marked with "acq".
% For paper 2, the analyses are marked with "rec" and "recfam" (reqfam is
% exploratory).

%% Paths 
cd('/data/tu_govaart_cloud/owncloud-gwdg/PhD_owncloud/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab')
clear all; path(pathdef); clc; %reset session to clean

DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
DIR.RAWEEG_PATH = '/data/p_02453/raw_eeg/exp/';
DIR.REFA_PATH = '/data/p_02453/packages/eeglab2021.0/plugins/refa8import_v1.3/';
DIR.SCRIPTS = '/data/tu_govaart_cloud/owncloud-gwdg/PhD_owncloud/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab/functions';

% Add paths
addpath(genpath(DIR.RAWEEG_PATH));
addpath(DIR.REFA_PATH);
addpath(DIR.SCRIPTS);

% Load fieldtrip
addpath /data/p_02453/packages/fieldtrip-20230422
ft_defaults

%% Set subjects & values
Subj = ["19","20","21","24","25","26","28","29","30","32","48","50","52","57","62","64","68","69", ... % CBS
    "01","02","03","04","05","06","07","08","09","10","11","12","14","15",... %Charite
    "16","22","31","33","34","35","36","37","38","39","40","41","42","43",... %Charite
    "44","45","46","47","49","51","53","54","55","56","58","59","60","63",... %Charite
    "65","66","67","71","72","73","74","75","76","77","78","79","80","81",... %Charite
    "82","83","84","85","86","87"]; %Charite

Subj_cbs = ["19","20","21","24","25","26","28","29","30","32","48","50","52","57","62","64","68","69"];

Subj_char = ["01","02","03","04","05","06","07","08","09","10","11","12","14","15",... 
    "16","22","31","33","34","35","36","37","38","39","40","41","42","43",... 
    "44","45","46","47","49","51","53","54","55","56","58","59","60","63",... 
    "65","66","67","71","72","73","74","75","76","77","78","79","80","81",... 
    "82","83","84","85","86","87"];

Subj_Fam = ["21","28","32","50","52","57","62",... % CBS
    "01","02","05","06","11","12","15","16","22","31","33","34","35","36",... %Charite
    "37","40","41","46","47","51","53","56","63","66","67","72",... %Charite
    "74","77","78","79","81","84","86"]; %Charite

Subj_Unfam = ["19","20","24","25","26","29","30","48","64","68","69",... % CBS
    "03","04","07","08","09","10","14","38","39","42","43","44","45","49","54",... % Charite
    "55","58","59","60","65","71","73","75","76","80","82","83","85","87"]; % Charite

blvalue = -200; % this is just set here because it is needed in both HAPPE_FamVoice and write_amp_table

%% Create DIRs 
manualInfoFolder = "Analysis_251024_orig";

% if dir does not exist, create new one
if ~exist(strcat(DIR.RAWEEG_PATH,"01-output/", manualInfoFolder), 'dir')
    DIR = makeSubDirectory(DIR,manualInfoFolder);
else
    DIR = changeSubDirectoryPaths(DIR, manualInfoFolder);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end

%% Run preprocessing functions
for pp = Subj
    HAPPE_FamVoice(pp, DIR, blvalue, Subj_cbs, Subj_char)
end

write_output_tables(Subj, DIR);
computeGA(DIR, Subj_Fam, Subj_Unfam); 

% For both RQs seperately, look at f7 and f8 and compare to f9-f10 & V2-Fp2 to check for
% eye contamination. If no eye contamination, add to ROI in
% write_amp_table.m
roi = "normal";   %"normal" or "frontal"

plot_colloc(DIR,roi);

% After looking at ERP_Colloc_ACQ_all and ERP_Colloc_REC_all (DON'T look at seperate plots per electrode):
% Decide time-window:
if roi == "normal"
    twstartacq = 334; % CHANGE based on coll loc. HAS TO BE EVEN
    twendacq = 534; % CHANGE based on coll loc. HAS TO BE EVEN
    twstartrec = 332; % CHANGE based on coll loc. HAS TO BE EVEN
    twendrec = 532; % CHANGE based on coll loc. HAS TO BE EVEN
    twstartrecfam = 344; % CHANGE based on coll loc. HAS TO BE EVEN
    twendrecfam = 544; % CHANGE based on coll loc. HAS TO BE EVEN
elseif roi == "frontal"
    twstartacq = 0; % placeholder (the analysis for Frontal is only used 
    twendacq = 50; % placeholder
    twstartrec = 0; % placeholder
    twendrec = 50; % placeholder
    twstartrecfam = 344; % CHANGE based on coll loc. HAS TO BE EVEN
    twendrecfam = 544; % CHANGE based on coll loc. HAS TO BE EVEN
end

write_amp_table(Subj, DIR, blvalue, twstartacq, twendacq, ...
    twstartrec, twendrec, twstartrecfam, twendrecfam, roi); % adapt the electrodes based on Colloc

plot_ERP_proc_MS(DIR, roi, twstartacq, twendacq, twstartrec, twendrec, twstartrecfam, twendrecfam)
plot_ERP_proc_MS_eps(DIR, roi, twstartacq, twendacq, twstartrec, twendrec, twstartrecfam, twendrecfam)


%% Quality checks & vizualize
% NB for all these functions: adapt the electrodes based on Colloc

% Quality check: without BLcorr.
% As specified in Prereg: 
% "We will inspect the data without baseline correction. If the baseline period shows two parallel lines 
% (the ERPs to standards and deviants) which the baseline correction would need to align, we will apply 
% the baseline correction. If, on the other hand, the ERPs in response to the standards and deviants cross 
% each other in the baseline time window before applying baseline correction, then the baseline correction 
% introduces artificial effects in the data." 
for pp = Subj
    save_sets_woBLcorr(pp, DIR)
end
computeGA_withoutBLcorr(DIR, Subj_Fam, Subj_Unfam);
plot_colloc_woBLcor(DIR,roi);
plot_ERP_proc_woBLcorr(DIR, twstartacq, twendacq, twstartrec, twendrec);

plot_ERP_proc(DIR, twstartacq, twendacq, twstartrec, twendrec); 
plot_ERP_proc_withSD(DIR); 
plot_ERP_proc_perelectrodeROI(DIR);
plot_ERP_proc_indiv(Subj, DIR);

% We also performed two other checks specified in the prereg:
% •	Trial length: We have a preset trial length of -200 to 650 ms (based on the length of the vowels and the 
% expected evoked responses). We will visually inspect the ERPs after preprocessing, and if we observe no 
% effects after 600 ms, and we moreover retain more trials with a trial length of -200 to 600 ms, we will 
% use the shorter trial length, in order to increase statistical power.
% --> We observed effects after 600 ms and thus kept our preset trial
% length of -200 to 650 ms.
% •	Threshold value (amplitude criterium) for artifact rejection: We will compare an absolute threshold of 
% -150 µV/150 µV with a threshold of -200 µV to 200 µV for artifact rejection. If we see an increase of 
% >10% in the number of individual datasets (infants) that can enter the analysis, and moreover this change 
% does not affect our data “cleanliness” criteria, we will change the threshold to -200 µV to 200 µV. Our 
% data “cleanliness” criteria are:
% o	The ERPs in the baseline time window before applying the baseline correction run in parallel or are directly overlapping 
% o	There a no large drifts at the end of the trials
% o	The SD of the ERP does not increase linearly over the course of the trial
% --> This analysis was run, and can be replicated with
% FamVoice_Main_amp200.m
% The increase was less than 10%, so we kept the original cirterion of -150
% µV/150 µV.


% Quality check with raw data
for pp = Subj
    save_sets_raw(pp, DIR)
end
computeGA_raw(DIR, Subj_Fam, Subj_Unfam);
plot_averagedData_raw(DIR);
plot_ERP_proc_raw(DIR, twstartacq, twendacq, twstartrec, twendrec);



%% Reminder for the trigger codes
% % For the test phase:
% % •        First digit: 1 for dev, 2 for stan
% % •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% % •        Third digit: speakers: 1,2,3,4
% % For the training phase:
% % •        First digit: 1 for fe, 2 for fi
% % •        Second digit: for speaker: 1 for S1, 2 for S2

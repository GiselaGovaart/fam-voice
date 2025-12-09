
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


Subj = ["53"]; %Charite
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
manualInfoFolder = "Analysis_251024_amp200";

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
    HAPPE_FamVoice_amp200(pp, DIR, blvalue, Subj_cbs, Subj_char)
end

write_output_tables(Subj, DIR);
computeGA(DIR, Subj_Fam, Subj_Unfam); %KM only checked first 2 parts
plot_colloc(DIR);

% % After looking at ERP_Colloc_ACQ_all and ERP_Colloc_REC_all (DON'T look at seperate plots per electrode):
% % Decide time-window:
% twstartacq = 334; % CHANGE based on coll loc. HAS TO BE EVEN
% twendacq = 534; % CHANGE based on coll loc. HAS TO BE EVEN
% twstartrec = 330; % CHANGE based on coll loc. HAS TO BE EVEN
% twendrec = 530; % CHANGE based on coll loc. HAS TO BE EVEN
% 
% % For both RQs seperately, look at f7 and f8 and compare to f9-f10 & V2-Fp2 to check for
% % eye contamination. If no eye contamination, add to ROI in
% % write_amp_table.m
% write_amp_table(Subj, DIR, blvalue, twstartacq, twendacq, twstartrec, twendrec); % adapt the electrodes based on Colloc
% 
% %% Quality checks & vizualize
% % NB for all these functions: adapt the electrodes based on Colloc
% 
% % without BLcorr
% for pp = Subj
%     save_sets_woBLcorr(pp, DIR)
% end
% computeGA_withoutBLcorr(DIR, Subj_Fam, Subj_Unfam);
% plot_averagedData_woBLcor(DIR);
% plot_ERP_proc_woBLcorr(DIR, twstartacq, twendacq, twstartrec, twendrec);
% 
% plot_ERP_proc(DIR, twstartacq, twendacq, twstartrec, twendrec); 
% plot_ERP_proc_withSD(DIR); 
% plot_ERP_proc_perelectrodeROI(DIR);
% plot_ERP_proc_indiv(Subj, DIR);
% 
% for pp = Subj
%     save_sets_raw(pp, DIR)
% end
% computeGA_raw(DIR, Subj_Fam, Subj_Unfam);
% plot_averagedData_raw(DIR);
% plot_ERP_proc_raw(DIR, twstartacq, twendacq, twstartrec, twendrec);
% 
% %% Reminder for the trigger codes
% % % For the test phase:
% % % •        First digit: 1 for dev, 2 for stan
% % % •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% % % •        Third digit: speakers: 1,2,3,4
% % % For the training phase:
% % % •        First digit: 1 for fe, 2 for fi
% % % •        Second digit: for speaker: 1 for S1, 2 for S2

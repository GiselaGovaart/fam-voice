
%% Paths 
cd('/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab')
clear all; path(pathdef); clc; %reset session to clean

DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
DIR.RAWEEG_PATH = '/data/p_02453/raw_eeg/exp/';
DIR.REFA_PATH = '/data/p_02453/packages/eeglab2021.0/plugins/refa8import_v1.3/';
DIR.SCRIPTS = '/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab/functions';

% Add paths
addpath(genpath(DIR.RAWEEG_PATH));
addpath(DIR.REFA_PATH);
addpath(DIR.SCRIPTS);

% Load fieldtrip
addpath /data/p_02453/packages/fieldtrip-20230422
ft_defaults

%% Set subjects & values
Subj = ["23" "27_1" "57" "FamVoice98"];
Subj_cbs = ["23" "27_1" "57"];
Subj_char = ["FamVoice98" ];
Subj_Fam = ["23" "57" "27_1" "FamVoice98"];
Subj_Unfam = ["23" "57" "27_1" "FamVoice98"];
 
blvalue = -200; % this is just set here because it is needed in both HAPPE_FamVoice and write_amp_table
filtervalue = "low";

%% Create DIRs 
manualInfoFolder = "AnalysisTestSubjects";

% if dir does not exist, create new one
if ~exist(strcat(DIR.RAWEEG_PATH,"01-output/", manualInfoFolder, "_filter", filtervalue), 'dir')
    DIR = makeSubDirectory(DIR,manualInfoFolder);
else
    DIR = changeSubDirectoryPaths(DIR, manualInfoFolder);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end

%% Run preprocessing functions
for pp = Subj
    HAPPE_FamVoice(pp, DIR, blvalue, Subj_cbs, Subj_char, filtervalue)
end

write_output_tables(Subj, DIR);
computeGA(DIR, Subj_Fam, Subj_Unfam);
plot_colloc(DIR);

% After looking at ERP_Colloc_ACQ_all and ERP_Colloc_REC_all (DON'T look at seperate plots per electrode):
% Decide time-window:
% For low filter:
if filtervalue == "low"
    twstartacq = 200; % CHANGE based on coll loc. HAS TO BE EVEN
    twendacq = 600; % CHANGE based on coll loc. HAS TO BE EVEN
    twstartrec = 200; % CHANGE based on coll loc. HAS TO BE EVEN
    twendrec = 600; % CHANGE based on coll loc. HAS TO BE EVEN

    % After looking at ERP_Colloc_ACQ_.. and ERP_Colloc_REC_.. per electrode:
    % Decide on electrodes (per RQ)
    write_amp_table_filtlow(Subj, DIR, blvalue, twstartacq, twendacq, twstartrec, twendrec); % adapt the electrodes based on Colloc

elseif filtervalue == "high"
    twstartacq = 200; % CHANGE based on coll loc. HAS TO BE EVEN
    twendacq = 600; % CHANGE based on coll loc. HAS TO BE EVEN
    twstartrec = 250; % CHANGE based on coll loc. HAS TO BE EVEN
    twendrec = 600; % CHANGE based on coll loc. HAS TO BE EVEN

    % After looking at ERP_Colloc_ACQ_.. and ERP_Colloc_REC_.. per electrode:
    % Decide on electrodes (per RQ)
    write_amp_table_filthigh(Subj, DIR, blvalue, twstartacq, twendacq, twstartrec, twendrec); % adapt the electrodes based on Colloc
end
%% Quality checks & vizualize
% NB for all these functions: adapt the electrodes based on Colloc

for pp = Subj
    plot_ERP_raw_loop(pp,DIR, blvalue, Subj_cbs, Subj_char);
end
plot_ERP_raw_plot(Subj,DIR);

plot_ERP_proc_indiv(Subj, DIR);
% for plot_ERP_proc_indiv, you might want to make 2 versions, one with the
% electrodes for ACQ and one with the electrodes for REC

plot_ERP_proc(DIR, twstartacq, twendacq, twstartrec, twendrec); 
% for plot_ERP_proc, you also might want to make seperate versions with 
% different electrodes for ACQ and REC (only the conditions that are used 
% double need to be plotted twice then). 


%% Reminder for the trigger codes
% For the test phase:
% •        First digit: 1 for dev, 2 for stan
% •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% •        Third digit: speakers: 1,2,3,4
% For the training phase:
% •        First digit: 1 for fe, 2 for fi
% •        Second digit: for speaker: 1 for S1, 2 for S2

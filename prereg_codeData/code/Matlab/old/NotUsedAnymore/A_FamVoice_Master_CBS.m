
%% Paths 

cd('/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab')
clear all; path(pathdef); clc; %reset session to clean

DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
DIR.RAWEEG_PATH = '/data/p_02453/raw_eeg/exp_CBS/';
DIR.REFA_PATH = '/data/p_02453/packages/eeglab2021.0/plugins/refa8import_v1.3/';
DIR.SCRIPTS = '/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab/functions';

% Add paths
% addpath(genpath(DIR.EEGLAB_PATH));  %this gives a warning
% cd(DIR.EEGLAB_PATH);
% % [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% % close;
% eeglab; close;

addpath(genpath(DIR.RAWEEG_PATH));
addpath(DIR.REFA_PATH);
addpath(DIR.SCRIPTS);
cd(DIR.RAWEEG_PATH);

% load fieldtrip
addpath /data/p_02453/packages/fieldtrip-20230422
ft_defaults

%% Set subjects
Subj = ["23" "17" "13"  "27" "27_1" "57" "test"];


%% Create DIRs 
manualInfoFolder = "finalParams";

%if dir does not exist, create new one
if ~exist(strcat(DIR.RAWEEG_PATH,"01-output/", manualInfoFolder), 'dir')
    DIR = makeSubDirectory(DIR,manualInfoFolder);
else
    DIR = changeSubDirectoryPaths(DIR, manualInfoFolder);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end

%% Run preprocessing functions
for pp = Subj
    HAPPE_FamVoice_CBS(pp, DIR)
end

computeGA(Subj, DIR);
plotERPs(DIR);
plotERPs_withSD(DIR);
write_output_tables(Subj, DIR);

for pp = Subj
    plot_ERP_RAW_loop(pp,DIR);
end
plot_ERP_RAW_plot(Subj,DIR);

plotERPsIndiv(Subj, DIR);


%% Analysis
% Subj = (defined above)
% write a new function for the analysis, call that function here.

% Step 1: Collapsed localizer





%% Reminder for the trigger codes
% For the test phase:
% •        First digit: 1 for dev, 2 for stan
% •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% •        Third digit: speakers: 1,2,3,4
% For the training phase:
% •        First digit: 1 for fe, 2 for fi
% •        Second digit: for speaker: 1 for S1, 2 for S2

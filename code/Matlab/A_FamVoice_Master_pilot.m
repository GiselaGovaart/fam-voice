
%% Paths you need

cd('/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab')

clear all; path(pathdef); clc; %reset session to clean

DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
DIR.RAWEEG_PATH = '/data/p_02453/raw_eeg/pilot';
DIR.SET_PATH = '/data/p_02453/raw_eeg/pilot/raw-data-sets/';
DIR.REFA_PATH = '/data/p_02453/packages/eeglab2021.0/plugins/refa8import_v1.3/';
DIR.SCRIPTS = '/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab/functions';

% Add paths
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
Subj = ["01" "02" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "15"];


%% Create DIRs 

manualInfoFolder = "finalParams";

%if dir does not exist, create new one
if ~exist(strcat(DIR.SET_PATH,"01-output/", manualInfoFolder), 'dir')
    DIR = makeSubDirectory(DIR,manualInfoFolder);
else
    DIR = changeSubDirectoryPaths(DIR, manualInfoFolder);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end



%% Run preprocessing functions
for pp = Subj
    makeSetsEEG(pp,DIR)
    HAPPE_FamVoice_pilot(pp, DIR)
end

computeGA(Subj, DIR);
plotERPs(DIR);
plotERPs_withSD(DIR);
write_output_tables(Subj, DIR);



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




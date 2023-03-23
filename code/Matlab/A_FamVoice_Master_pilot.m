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

addpath(genpath(DIR.EEGLAB_PATH));  % this gives a warning
% cd(DIR.EEGLAB_PATH);
% eeglab; close;

addpath(genpath(DIR.RAWEEG_PATH));
addpath(DIR.REFA_PATH);
addpath(DIR.SCRIPTS);

cd(DIR.RAWEEG_PATH);


%% Set subjects
% Subj = ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15"];
%Subj = ["01"];

Subj = ["01" "02" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "15"];

%% preprocess EEG

% params to play with
hpFreqValue = 0.3;
hpStr=sprintf('%.2f',hpFreqValue);
threshold = 200;
minAmpValue = -threshold; 
maxAmpValue = threshold; 
wavThreshold = 'Hard'; %can be 'Hard' or 'Soft'
version = 3; % HAPPE2 or HAPPE 3
baseline = "yes";

%if dir does not exist, create new one-+*
if ~exist(strcat(DIR.SET_PATH,"01-output/hp",hpStr,"_Amp",int2str(threshold),...
        "_wavThreshold", wavThreshold, "_version",int2str(version),"_baseline-", baseline), 'dir')
    DIR = makeSubDirectory(DIR,hpStr,threshold,wavThreshold,version, baseline);
else
    DIR = changeSubDirectoryPaths(DIR,hpStr,threshold,wavThreshold,version, baseline);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end

%for pp = Subj(1)
for pp = Subj
    makeSetsEEG(pp,DIR)
    HAPPE_FamVoice_pilot(pp,DIR,hpFreqValue, minAmpValue, maxAmpValue,wavThreshold,version, baseline)

end

computeGrandAverage(DIR);
plotERPs(DIR);
write_output_tables(Subj, DIR);

%% analysis
% Subj = (defined above)
% write a new function for the analysis, call that function here.

% Step 1: Collapsed localizer



%% Vizualization



%% Reminder for the trigger codes
% For the test phase:
% •        First digit: 1 for dev, 2 for stan
% •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% •        Third digit: speakers: 1,2,3,4
% For the training phase:
% •        First digit: 1 for fe, 2 for fi
% •        Second digit: for speaker: 1 for S1, 2 for S2




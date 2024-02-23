
%% Paths 

cd('/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab')
clear all; path(pathdef); clc; %reset session to clean

DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
DIR.RAWEEG_PATH = '/data/p_02453/raw_eeg/pilot/raw-data-sets/';
% these two paths are now the same, because for the active data, we dont
% need to make sets. I adapted scripts to set the directories such that
% they fit the _CBS and _Charite scripts. For that, I needed to add
% '/raw-data-sets/' to the RAWEEG path. Because of this,
% makeSetsEEG(pp,DIR) now does not work. It would work again if
% DIR.RAWEEG_PATH = '/data/p_02453/raw_eeg/pilot/'; However, I currently
% don't need the makeSetsEEG function anymore, so I leave it as is
DIR.SET_PATH = '/data/p_02453/raw_eeg/pilot/raw-data-sets/';
DIR.REFA_PATH = '/data/p_02453/packages/eeglab2021.0/plugins/refa8import_v1.3/';
DIR.SCRIPTS = '/data/tu_govaart/Experiment1_FamVoice/FamVoiceWORCS/code/Matlab/functions';

% Add paths
% addpath(genpath(DIR.EEGLAB_PATH));  %this gives a warning
cd(DIR.EEGLAB_PATH);
eeglab; close;

addpath(genpath(DIR.RAWEEG_PATH));
addpath(DIR.REFA_PATH);
addpath(DIR.SCRIPTS);
cd(DIR.RAWEEG_PATH);

% load fieldtrip
addpath /data/p_02453/packages/fieldtrip-20230422
ft_defaults

%% Set subjects & values
Subj = ["01" "02" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "15"];

blvalue = -200; % this is just set here because it is needed in both HAPPE_FamVoice and write_amp_table
filtervalue = "high"; 

%% Create DIRs 
manualInfoFolder = "final_usedForBA";


%if dir does not exist, create new one
if ~exist(strcat(DIR.SET_PATH,"01-output/", manualInfoFolder, "_filter-", filtervalue), 'dir')
    DIR = makeSubDirectory(DIR,manualInfoFolder,filtervalue);
else
    DIR = changeSubDirectoryPaths(DIR, manualInfoFolder,filtervalue);
    % to make sure that the DIR variable is also correct if the directory
    % previously existed.
end

%% Run preprocessing functions
% 
% for pp = Subj
% %     makeSetsEEG(pp,DIR)
%     HAPPE_FamVoice_pilot(pp, DIR,filtervalue)
% end
% 
% computeGA_pilot(Subj, DIR);
% plot_ERP_proc_pilot(DIR);
% plot_ERP_proc_withSD_pilot(DIR);
% write_output_tables_pilot(Subj, DIR);
% 
% for pp = Subj
%     plot_ERP_raw_loop_pilot(pp,DIR);
% end
% plot_ERP_raw_plot_pilot(Subj,DIR);
% plot_ERP_proc_indiv_pilot(Subj, DIR);



%% Run preprocessing functions
for pp = Subj
    HAPPE_FamVoice_pilot(pp, DIR, filtervalue)
end

write_output_tables_pilot(Subj, DIR);
computeGA_pilot(DIR); % 22-03-24: due to some weird eeglab problem (probably), this function doesn't work if I call it from here. Just go in the function and run the code there
plot_colloc_pilot(DIR);

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
    % For low filter: ACQ: add C4, F7, F8. REC: add C4, F7, F8.
    write_amp_table_pilot_filtlow(Subj, DIR, blvalue, twstartacq, twendacq, twstartrec, twendrec); % adapt the electrodes based on Colloc
elseif filtervalue == "high"
    twstartacq = 200; % CHANGE based on coll loc. HAS TO BE EVEN
    twendacq = 600; % CHANGE based on coll loc. HAS TO BE EVEN
    twstartrec = 250; % CHANGE based on coll loc. HAS TO BE EVEN
    twendrec = 600; % CHANGE based on coll loc. HAS TO BE EVEN

    % After looking at ERP_Colloc_ACQ_.. and ERP_Colloc_REC_.. per electrode:
    % Decide on electrodes (per RQ)
    % For high filter: ACQ: add C3, C4, Cz, F7, F8 for both RQs
    write_amp_table_pilot_filthigh(Subj, DIR, blvalue, twstartacq, twendacq, twstartrec, twendrec); % adapt the electrodes based on Colloc

end

%% Quality checks & vizualize
% NB for final_usedForBA_filter-low and final_usedForBA_filter-high, I did
% not run this Section, because it was not needed anymore to inform
% decisions. For completeness, it could be run later
% Then keep in mind, that plot_ERP_proc_indiv_pilot and plot_ERP_proc_pilot
% should probably be adapted to include the same visualizations as for the
% experiment - for the pilot I now use different electrodes for plotting.
% that's still a bit of work, and not necessary for now (22-02-24)

for pp = Subj
    plot_ERP_raw_loop_pilot(pp,DIR);
end
plot_ERP_raw_plot_pilot(Subj,DIR);

% NB for those two functions: adapt the electrodes based on Colloc
plot_ERP_proc_indiv_pilot(Subj, DIR);
% for plot_ERP_proc_indiv, you might want to make 2 versions, one with the
% electrodes for ACQ and one with the electrodes for REC

plot_ERP_proc_pilot(DIR);
% for plot_ERP_proc, you also might want to make seperate versions with 
% different electrodes for ACQ and REC (only the conditions that are used 
% double need to be plotted twice then). 

%plot_ERP_proc_withSD_pilot(DIR); % included already in colloc now




%% Reminder for the trigger codes
% For the test phase:
% •        First digit: 1 for dev, 2 for stan
% •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% •        Third digit: speakers: 1,2,3,4
% For the training phase:
% •        First digit: 1 for fe, 2 for fi
% •        Second digit: for speaker: 1 for S1, 2 for S2

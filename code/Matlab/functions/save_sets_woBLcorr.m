function save_sets_woBLcorr(pp, DIR)
Fz = 14;

%% Load the data
cd(DIR.EEGLAB_PATH);
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% Preprocessing for the FamVoice data, based on HAPPE 3.3 

EEG = pop_loadset('filename', convertStringsToChars(strcat(pp,'_segmented.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));


%% Artifact rejection
ROI = {'F7','F3','Fz','F4','F8',...
    'FC5','FC6','C3','C4', 'TP9', 'TP10'};  

ROI_indxs = [] ;
for i=1:size(ROI,2)
    ROI_indxs = [ROI_indxs find(strcmpi({EEG.chanlocs.labels}, ...
       ROI{i}))] ;
end

% AMPLITUDE CRITERIA
% HAPPE suggests 200 for infants and 150 for children and adults, MADE uses
% 150 for infants. We use 150.
minAmp = -150; 
maxAmp = 150; 

EEG = pop_eegthresh(EEG, 1, ...
                      ROI_indxs, [minAmp], [maxAmp], ...
                      [EEG.xmin], [EEG.xmax], 2, 1); %last 1: reject labeled trials

% SIMILARITY CRITERIA
num = 2; % because we have low density data
EEG = pop_jointprob(EEG, 1, ...
            ROI_indxs, num, num, 0, 1,0) ;% second-to-last 1: reject labeled trials

% Save the post-artifact rejection data as an intermediate output
EEG = eeg_checkset(EEG);
% pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_segmented_postrej.set')), ...
%     'filepath', convertStringsToChars(DIR.segmenting));


%% Bad channel interpolation
EEG = happe_interpChan(EEG,pp,DIR);

% Save the interpolated data as an intermediate output
EEG = eeg_checkset(EEG);
% pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_interpolated.set')), ...
%     'filepath', convertStringsToChars(DIR.segmenting));


%% Rereferencing
% add Cz
[EEG,com] = famvoice_add_reference_channel(EEG);
EEG = eeg_hist(EEG,com);

% Reref
[~,refchan] = intersect({EEG.chanlocs.labels},{'TP9','TP10'});
EEG = pop_reref(EEG,refchan,'keepref','on');
EEG.setname = strcat(pp,' reref');

% Save the rereferenced data as an intermediate output
EEG = eeg_checkset(EEG);
% pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_reref.set')), ...
%     'filepath', convertStringsToChars(DIR.segmenting));




%% Split by onset tags
onsetTags = {11, 12, 21, 22, ... %training
    101, 211, 221, 231, 241,... %testS1
    102, 212, 222, 232, 242,... %testS2
    103, 213, 223, 233, 243,...%testS3
    104, 214, 224, 234, 244}; %testS4

fprintf('Creating EEGs by tags...\n') ;
eegByTags = [] ;
usedTags = [];
for i=1:length(onsetTags)
    try
        eegByTags = [eegByTags pop_selectevent(EEG, 'type',onsetTags{i})];
        usedTags = [usedTags onsetTags{i}];
    end
end

%% Save dataset
for i=1:length(eegByTags)
    fileName = convertStringsToChars(strcat(DIR.processed,'withoutBLcorr/',pp,'_processed_', ...
        int2str(usedTags(i)),'.set'));
    pop_saveset(eegByTags(i), 'filename', ...
         fileName);
end

end

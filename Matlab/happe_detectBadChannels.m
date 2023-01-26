function EEG = happe_detectBadChannels(EEG,pp,DIR,ROI)
%EEG = happe_detectBadChannels(EEG,pp)

%   This code is adapted from HAPPE by Katharina, and then adapted by
%   Gisela
%   Detects bad channels in the recording according to the algorithm 
%   introduced in HAPPE 2.1. It does so by first checking for flat channels,
%   then assessing the Hurst gradient

original = EEG.chanlocs; %save names of original channels
dataOrig = EEG.data; % original data

%% Hack to make sure some crucial electrodes are not removed
% Find indices of EOG and mastoids

% Copy indices of original channels in a string variable
elecName = strings([1,length(EEG.chanlocs)]);
for i = 1:length(EEG.chanlocs)
    elecName(i) = convertCharsToStrings(EEG.chanlocs(i).labels);
end

% Find index of crucial electrodes (eyes and mastoids) 
% NB why include F9 and F10 here? (they are used as horizonatal eye
% electrodes)
% you need the eye electrodes for the WICA (because that takes out the
% parts with peaks)
crucialNames = {'Fp2','EOG1','TP9','TP10','F9','F10'};
for i = 1:length(crucialNames)
    if ismember(crucialNames(i),elecName)
        idxCruc(i) = find(elecName == crucialNames(i));
    end
end


%% channel removal according to HAPPE 2.1

%remove channels flat more than 300 seconds (changed from HAPPE, who used
%5sec which was way too little for us)
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion', 300, ...
    'ChannelCriterion', .1, 'LineNoiseCriterion', ...
    20, 'Highpass', 'off', 'BurstCriterion', 'off', ...
    'WindowCriterion', 'off', 'BurstRejection', 'off', ...
    'Distance', 'Euclidian');

% Since we have low-density data, detect bad channels using the
% methods optimized in HAPPILEE.

%remove channels that do not correlate with other channels
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion', ...
    'off', 'ChannelCriterion', .7, 'LineNoiseCriterion', ...
    'off', 'Highpass', 'off', 'BurstCriterion', 'off', ...
    'WindowCriterion', 'off', 'BurstRejection', ...
    'off', 'Distance', 'Euclidian');

%remove channels with abnormal power
EEG = pop_rejchan(EEG, 'elec', [1:EEG.nbchan], ...
    'threshold', [-2.75 2.75], 'norm', 'on', 'measure', ...
    'spec', 'freqrange', [1 100]) ;


%% add crucial electrodes again in case they were removed

for i = 1:length(EEG.chanlocs)
    goodElecs(i) = convertCharsToStrings(EEG.chanlocs(i).labels);
    % goodElecs are the selected electrodes BEFORE the crucial elecs
    % are added again
end
removedCrucial = ~ismember(crucialNames,goodElecs);

idxAdd = idxCruc(removedCrucial);

for chan = 1:length(idxAdd)
    if idxAdd > 0
        EEG.data(end+1,:) = dataOrig(idxAdd(chan),:);
        EEG.chanlocs(end+1) = original(idxAdd(chan));
        EEG.nbchan = EEG.nbchan +1;
    end
end

% Go from index numbers to the electrode names
crucialRemovedNames = crucialNames(removedCrucial); 

%% save the selected and original channel names for later interpolation
%out = eeg_checkset(EEG);
selected = EEG.chanlocs;
% selected contains the "good elecs" plus the crucial electrodes that might
% have been marked for removal.
selected_array = {selected(1:length(selected)).labels}; %take cell array with names out of structure
original_array = {original(1:length(original)).labels}; %take cell array with names out of structure

% I probably don't need this (if I get an error, this might be the problem)
% sCha = struct2cell(selected);
% sLab = squeeze(sCha(1,:,:)); 
% % squeeze: just drops all dimensions that are 1, such that your matrix is
% % not multidimensional
% 
% out = pop_select(out,'channel',sLab); % goes as output back to script

save(strcat(DIR.intermediateProcessing,'channelInfo_', pp),'original','selected','crucialRemovedNames');

%% Save information 

% ROI = {'F7','F3','Fz','F4','F8',...
%    'FC5','FC6','C3','C4','TP9', 'TP10'}; 

selected_long = cell(1,length(original_array));
selected_long(1:length(selected_array)) = selected_array;

totalRemoved = ~ismember(original_array,selected_array);
totalRemovedNames = original_array(totalRemoved);
totalRemovedNames_long = cell(1,length(original_array));
totalRemovedNames_long(1:length(totalRemovedNames)) = totalRemovedNames;

removedROI = ~ismember(ROI,selected_array);
if removedROI > 3
    moreThan3RemovedRoi = {'yes'};
else
    moreThan3RemovedRoi = {'no'};
end
moreThan3RemovedRoi_long = cell(1,length(original_array));
moreThan3RemovedRoi_long(1,length(moreThan3RemovedRoi)) = moreThan3RemovedRoi;

removedROINames = ROI(removedROI);
removedROINames_long = cell(1,length(original_array));
removedROINames_long(1:length(removedROINames)) = removedROINames;

crucialRemovedNames_long = cell(1,length(original_array));
crucialRemovedNames_long(1:length(crucialRemovedNames)) = crucialRemovedNames;

% DIR.SET_PATH = '/data/p_02453/raw_eeg/pilot/raw-data-sets/';
% DIR.intermediateProcessing =  strcat(DIR.SET_PATH,"01-output/01-intermediate_processing/");

T = table(original_array', selected_long', totalRemovedNames_long', ...
    crucialRemovedNames_long', removedROINames_long', moreThan3RemovedRoi_long', ...
    'VariableNames', { 'original', 'selected', 'totalRemoved', 'crucialRemoved', 'removedROI', 'moreThan3RemovedRoi'} );
writetable(T,strcat(DIR.intermediateProcessing,'InfoChannels_', pp, '.txt'),'Delimiter','\t');


end


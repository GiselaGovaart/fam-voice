function plot_ERP_raw_loop_pilot(pp, DIR)
%   Preprocessing for the FamVoice data, based on HAPPE 3.3 


% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;
%% Load the data
[EEG] = pop_loadset(convertStringsToChars(strcat(pp, ".set")), DIR.SET_PATH);

%% Remove online ref Cz

EEG = pop_select(EEG, 'nochannel', {'Cz'}); %remove online Ref Cz from data
EEG = eeg_checkset(EEG);

%% Filter data 
% These  filters help the artifact correction later on.
% remove line noise 
lineNoiseIn = struct('lineNoiseMethod', 'clean', 'lineNoiseChannels', ...
    1:EEG.nbchan, 'Fs', EEG.srate, 'lineFrequencies', ...
    [50,100], 'p', 0.01, 'fScanBandWidth', 2, ...
    'taperBandWidth', 2, 'taperWindowSize', 4, 'taperWindowStep', 4, ...
    'tau', 100, 'pad', 2, 'fPassBand', [0 EEG.srate/2], ...
    'maximumIterations', 10) ;
[EEG, ~] = cleanLineNoise(EEG, lineNoiseIn) ;

%% Detect bad channels
% find ROI channels
% ROI = {'F7','F3','Fz','F4','F8',...
%     'FC5','FC6','C3','C4', 'TP9', 'TP10'};  
% % Here I cannot add Cz, that's a consequence of choosing to reref in the end
% 
% EEG = happe_detectBadChannels(EEG,pp,DIR,ROI);


%% Wavelet thresholding
EEG = happe_waveletThreshold(EEG,'Hard',3);

% Save the wavelet-thresholded EEG as an intermediate output
EEG = eeg_checkset(EEG);


%% HP filter
% MADE filter 
% Calculate filter order using the formula: m = dF / (df / fs), where m = filter order,
% df = transition band width, dF = normalized transition width, fs = sampling rate
% dF is specific for the window type. Hamming window dF = 3.3

% params:
hptrans = 0.4;
hpcutoff = 0.2;
% hpfreq = 0.4; % MADE uses 0.1, HAPPE 0.3, we use 0.4 (but
% calculated manually)
lpfreq = 30;

high_transband = hptrans; % high pass transition band. 
low_transband = 10; % low pass transition band

hp_fl_order = 3.3 / (high_transband / EEG.srate);
lp_fl_order = 3.3 / (low_transband / EEG.srate);
% the value of 3.3 for the filter order is based on the hamming window

% Round filter order to next higher even integer. Filter order is always even integer.
if mod(floor(hp_fl_order),2) == 0
    hp_fl_order=floor(hp_fl_order);
elseif mod(floor(hp_fl_order),2) == 1
    hp_fl_order=floor(hp_fl_order)+1;
end

if mod(floor(lp_fl_order),2) == 0
    lp_fl_order=floor(lp_fl_order)+2;
elseif mod(floor(lp_fl_order),2) == 1
    lp_fl_order=floor(lp_fl_order)+1;
end

% Calculate cutoff frequency
high_cutoff = hpcutoff;
low_cutoff = lpfreq + (low_transband/2);

% Performing high pass filtering
EEG = eeg_checkset( EEG );
EEG = pop_firws(EEG, 'fcutoff', high_cutoff, 'ftype', 'highpass', 'wtype', ...
    'hamming', 'forder', hp_fl_order, 'minphase', 0);
EEG = eeg_checkset( EEG );

% Performing low pass filtering
EEG = eeg_checkset( EEG );
EEG = pop_firws(EEG, 'fcutoff', low_cutoff, 'ftype', 'lowpass', 'wtype', ...
    'hamming', 'forder', lp_fl_order, 'minphase', 0);
EEG = eeg_checkset( EEG );

%% Segmentation for TEST PURPOSE ONLY

onsetTags = {11, 12, 21, 22, ... %training
    101, 211, 221, 231, 241,... %testS1
    102, 212, 222, 232, 242,... %testS2
    103, 213, 223, 233, 243,...%testS3
    104, 214, 224, 234, 244}; %testS4ss

segmentStart = -0.2; 
segmentEnd = 0.650;

EEG = pop_epoch(EEG, onsetTags, ...
    [segmentStart, segmentEnd], 'verbose', ...
    'no', 'epochinfo', 'yes') ;

% Save the segmented EEG as an intermediate output
EEG = eeg_checkset(EEG);
%pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_segmented_RAW.set')), ...
%    'filepath', convertStringsToChars(DIR.processed));

%% BL CORR

ROI = {'F7','F3','Fz','F4','F8',...
    'FC5','FC6','C3','C4', 'TP9', 'TP10'};  

blvalue = -200;

EEG = pop_rmbase(EEG, [blvalue 0]);
EEG = eeg_checkset(EEG);
ROI_indxs = [] ;
for i=1:size(ROI,2)
    ROI_indxs = [ROI_indxs find(strcmpi({EEG.chanlocs.labels}, ...
       ROI{i}))] ;
end

%% Artifact rejectsion


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


%% Rereferencing
% This code comes from Maren's script "makeSetsEEG.m"

EEG.data(end+1,:,:) = 0;
EEG.nbchan = size(EEG.data,1);
EEG.chanlocs(end+1).labels = 'Cz';

for chan=1:28
    EEG.chanlocs(chan).type = 'EEG';
    EEG.chanlocs(chan).ref = 'Cz';
end

fprintf('Adding electrode positions using spherical template...\n');
EEG = pop_chanedit(EEG, 'lookup','Standard-10-5-Cap385_witheog.elp');
EEG.setname = strcat(pp,' loc');

[~,refchan] = intersect({EEG.chanlocs.labels},{'TP9','TP10'});
EEG = pop_reref(EEG,refchan,'keepref','on');
EEG.setname = strcat(pp,' reref');

EEG = eeg_checkset(EEG);



%% Split by onset tags
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
    fileName = convertStringsToChars(strcat(DIR.processed,pp,'_RAW_', ...
        int2str(usedTags(i)),'.set'));
    pop_saveset(eegByTags(i), 'filename', ...
         fileName);
end



end


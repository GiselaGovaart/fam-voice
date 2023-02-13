function HAPPE_FamVoice_pilot(pp,DIR, hpFreqValue, minAmpValue, maxAmpValue, wavThreshold,version, baseline)
%HAPPE_FamVoice_pilot(pp,DIR)
%   Preprocessing for the FamVoice data, based on HAPPE 2.0 

%% load the data
%addpath(genpath(DIR.EEGLAB_PATH));

%dataFilename = strcat(DIR.SET_PATH,pp,".set");
% EEG = load('-mat', dataFilename);
[EEG] = pop_loadset(convertStringsToChars(strcat(pp, ".set")), DIR.SET_PATH);

%% remove online ref Cz

EEG = pop_select(EEG, 'nochannel', {'Cz'}); %remove online Ref Cz from data
EEG = eeg_checkset(EEG);

%% detrend data --> not necessary, I take a high-pass filter already
% EEGdata = EEG.data;
% EEGdata = detrend(EEGdata')';
% EEG.data = EEGdata;

%% filter data 
% These two filters help the artifact correction later on.
% remove line noise 
lineNoiseIn = struct('lineNoiseMethod', 'clean', 'lineNoiseChannels', ...
    1:EEG.nbchan, 'Fs', EEG.srate, 'lineFrequencies', ...
    50, 'p', 0.01, 'fScanBandWidth', 2, ...
    'taperBandWidth', 2, 'taperWindowSize', 4, 'taperWindowStep', 4, ...
    'tau', 100, 'pad', 2, 'fPassBand', [0 EEG.srate/2], ...
    'maximumIterations', 10) ;
[EEG, ~] = cleanLineNoise(EEG, lineNoiseIn) ;

%100 Hz filter
EEG = pop_eegfiltnew(EEG, [], 100, [], 0, [], 0) ;

% Save the filtered dataset as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_filtered_lnreduced.set')), ...
    'filepath', convertStringsToChars(DIR.intermediateProcessing));



%% detect bad channels
% find ROI channels
% maybe add T7 and T8??? Discuss with Claudia
ROI = {'F7','F3','Fz','F4','F8',...
    'FC5','FC6','C3','C4', 'TP9', 'TP10'};  
% Here I cannot add Cz, that's a consequence of choosing to reref in the end

EEG = happe_detectBadChannels(EEG,pp,DIR,ROI);

%% wavelet thresholding
EEG = happe_waveletThreshold(EEG,wavThreshold,version);

% Save the wavelet-thresholded EEG as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_wavclean.set')), ...
    'filepath', convertStringsToChars(DIR.waveletCleaned));

%% filter for ERP
% This is the HAPPE filter:
% hpfreq = 0.3;
% lpfreq = 30;
% EEG = pop_eegfiltnew(EEG, hpfreq, lpfreq, [], 0, [], 0) ;

% MADE filter 
hpfreq = hpFreqValue; % MADE uses 0.1, but HAPPE 0.3. I use 0.3 because of Burkhardt's arguments
lpfreq = 30;

high_transband = hpfreq; % high pass transition band. 
low_transband = 10; % low pass transition band

hp_fl_order = 3.3 / (high_transband / EEG.srate);
lp_fl_order = 3.3 / (low_transband / EEG.srate);

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
high_cutoff = hpfreq/2;
low_cutoff = lpfreq + (low_transband/2);

% Performing high pass filtering
EEG = eeg_checkset( EEG );
EEG = pop_firws(EEG, 'fcutoff', high_cutoff, 'ftype', 'highpass', 'wtype', 'hamming', 'forder', hp_fl_order, 'minphase', 0);
% MADE uses "hamming"
% Burkhardt recommended to use kaiser, because  Andreas Widmann likes kaiser 
% and he wrote pop_firws. Burkhardt says it filters steeper in combination
% with Widmann's filters.
% But if I exchange 'hamming' for 'kaiser', also need to specify a Beta
% value, and I don't know what to base that choice on.
% Note: Annika & Claudia take beta value = 7.857

EEG = eeg_checkset( EEG );

% Performing low pass filtering
EEG = eeg_checkset( EEG );
EEG = pop_firws(EEG, 'fcutoff', low_cutoff, 'ftype', 'lowpass', 'wtype', 'hamming', 'forder', lp_fl_order, 'minphase', 0);
EEG = eeg_checkset( EEG );

% Save the ERP filtered EEG as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_ERPfiltered.set')), ...
    'filepath', convertStringsToChars(DIR.ERPfiltered));


%% segmentation
% For the test phase:
% •        First digit: 1 for dev, 2 for stan
% •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% •        Third digit: speakers: 1,2,3,4
% For the training phase:
% •        First digit: 1 for fe, 2 for fi
% •        Second digit: for speaker: 1 for S1, 2 for S2

onsetTags = {11, 12, 21, 22, ... %training
    101, 211, 221, 231, 241,... %testS1
    102, 212, 222, 232, 242,... %testS2
    103, 213, 223, 233, 243,...%testS3
    104, 214, 224, 234, 244}; %testS4

% WHY COMMENTED OUT?
% segmentOffset = 0;
%     
% sampOffset = EEG.srate*segmentOffset/1000 ;
% for i = 1:size(EEG.event, 2)
%     EEG.event(i).latency = EEG.event(i).latency + sampOffset;
% end

segmentStart = -0.100; 
segmentEnd = 0.650;

EEG = pop_epoch(EEG, onsetTags, ...
    [segmentStart, segmentEnd], 'verbose', ...
    'no', 'epochinfo', 'yes') ;

% Save the segmented EEG as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_segmented.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));


%% baseline correction
if baseline == "yes"
    EEG = pop_rmbase(EEG, [-100 0]);
    EEG = eeg_checkset(EEG);
    pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_segmented_blcor.set')), ...
        'filepath', convertStringsToChars(DIR.segmenting));
end 

%% bad data interpolation
% lieber rausnehmen. sonst macht es hier schon data interpol within
% segments, and thenit uses that interpolated data for the channel
% interpolation
% fprintf('Interpolating bad data...\n') ;
% eegChans = [1:size(EEG.chanlocs,2)] ;
% rejOps.measure = [1 1 1 1] ;
% rejOps.z = [3 3 3 3] ;
% if length(size(EEG.data)) > 2
%     status = '' ;
%     lengthsEp = cell(1, size(EEG.data, 3)) ;
%     for v=1:size(EEG.data, 3)
%         listProps = single_epoch_channel_properties(EEG, v, eegChans);
%         lengthsEp{v} = eegChans(logical(min_z(listProps, rejOps)));
%         status = [status sprintf('[%d:',v) sprintf(' %d', lengthsEp{v}) ']'] ;
%     end
%     EEG = h_epoch_interp_spl(EEG, lengthsEp, []) ;
%     EEG.saved = 'no' ;
% end

%% artifact rejection
% ROI is set above (at "bad channel detection")
ROI_indxs = [] ;
for i=1:size(ROI,2)
    ROI_indxs = [ROI_indxs find(strcmpi({EEG.chanlocs.labels}, ...
       ROI{i}))] ;
end

% AMPLITUDE CRITERIA
% HAPPE suggests 200 for infants and 150 for children and adults, MADE uses
% 150 for infants. Claudia suggests 100-150
minAmp = minAmpValue; 
maxAmp = maxAmpValue; 

EEG = pop_eegthresh(EEG, 1, ...
                      ROI_indxs, [minAmp], [maxAmp], ...
                      [EEG.xmin], [EEG.xmax], 2, 1); %last 1: reject labeled trials

% SIMILARITY CRITERIA
num = 2; % because we have low density data
EEG = pop_jointprob(EEG, 1, ...
            ROI_indxs, num, num, 0, 1,0) ;% second-to-last 1: reject labeled trials

        
% Save the post-artifact rejection data as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_segmented_postrej.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));


%% bad channel interpolation
EEG = happe_interpChan(EEG,pp,DIR);

% Save the interpolated data as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_interpolated.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));

%% rereferencing
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

% Save the rereferences data as an intermediate output

EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_reref.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));

%% split by onset tags
fprintf('Creating EEGs by tags...\n') ;
eegByTags = [] ;
usedTags = [];
for i=1:length(onsetTags)
    try
        eegByTags = [eegByTags pop_selectevent(EEG, 'type',onsetTags{i})];
        usedTags = [usedTags onsetTags{i}];
    end
end

%% save dataset
for i=1:length(eegByTags)
    fileName = convertStringsToChars(strcat(DIR.processed,pp,'_processed_', ...
        int2str(usedTags(i)),'.set'));
    pop_saveset(eegByTags(i), 'filename', ...
         fileName);
end




end


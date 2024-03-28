function plot_ERP_raw_loop(pp,DIR, blvalue, Subj_cbs, Subj_char)
% Preprocessing for the FamVoice data, based on HAPPE 3.3 
% This is a copy of HAPPE_FamVoice.m, but with most preproc steps commented
% out. Also, all the figures and inbetween data saves are deleted.

% To check what's going on in other steps, you can take these steps in
% again in this script.

% For now, it's only the first linenoise filter, and the waveletting


%% Load the data
cd(DIR.EEGLAB_PATH);
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
close;

[EEG, com] = pop_loadbv(DIR.RAWEEG_PATH, [convertStringsToChars(pp) '.vhdr']);
EEG = eeg_hist(EEG,com);
EEG = eeg_checkset( EEG );


%% Edit channel locations and remove non-used electrodes

[EEG,com] = famvoice_fix_chanlocs(EEG);
EEG = eeg_hist(EEG,com);

if  any(strcmp(Subj_cbs,(pp)))
    % Remove FC1 and FC2, because it is not included in the setup at the
    % Charite
    EEG = pop_select(EEG, 'nochannel', {'FC1'});
    EEG = pop_select(EEG, 'nochannel', {'FC2'});
elseif any(strcmp(Subj_char,(pp)))
    % Remove Fp1, because it is not included in the setup at the CBS
    EEG = pop_select(EEG, 'nochannel', {'Fp1'});
end

% % Now make sure the chanlocs from both locations have the same order:
% Sort the labels and corresponding data
[sortedT, idx] = sortrows(struct2table(EEG.chanlocs), 'labels'); % sort the table and get the indices
sortedEEGdata = EEG.data(idx, :); % rearrange the rows of EEG.data according to the sorted indices
% Update the channel locations in EEG structure
EEG.chanlocs = table2struct(sortedT);
% Update EEG data
EEG.data = sortedEEGdata;

EEG = eeg_checkset(EEG);

%% Detect stimulation pauses (code written by Maren Grigutsch)
longEEG = EEG;

longEEG.setname = [convertStringsToChars(pp)];
[ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG,longEEG);
eeglab redraw;

pauses = famvoice_detect_pauses(longEEG);


%% 
if ~isempty(pauses)
   %%Delete the pauses from the dataset

    fprintf('Deleting n=%d pauses from the dataset.\n',size(pauses,1));
    
    [EEG,com] = pop_select(longEEG,'nopoint',pauses);
    EEG = eeg_hist(EEG,com);
    
    EEG.setname = [convertStringsToChars(pp) ' without pauses'];
    [ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG,EEG);
    eeglab redraw;
    
  
   %% Check consistency between datasets before and after deleting pauses.

    fprintf('Checking consistency between datasets before and after deleting pauses...\n')
    
    trg = famvoice_triggers;
    stimType = trg.stimulus;
    n_long = sum(ismember({longEEG.event.type},stimType));
    n = sum(ismember({EEG.event.type},stimType));
    
    if n_long ~= n
        error('ERROR: Inconsistent number of stimulus events after deleting pauses: got %d; expected %d',n,n_long);
    end
    
    % Cut epochs around each stimulus trigger and compare the data.
    epoch_long = pop_epoch(longEEG,stimType,[-0.5 0.5]);
    epoch = pop_epoch(EEG,stimType,[-0.5 0.5]);
    m = max(abs(epoch.data(:)-epoch_long.data(:))); 

    fprintf('Comparing data matrices...')
    if m ~= 0
        error('Found inconsistent data between datasets; max. diviation: %e uV',m)
    end
    
    fprintf('...ok.\n')
    clear trg stimTrg n_long n m epoch_long epoch
%%
end

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

EEG = eeg_checkset(EEG);

%% Detect bad channels
% % find ROI channels
% ROI = {'F7','F3','Fz','F4','F8',...
%     'FC5','FC6','C3','C4', 'TP9', 'TP10'};  
% % Here I cannot add Cz, that's a consequence of choosing to reref in the end
% 
% EEG = happe_detectBadChannels(EEG,pp,DIR,ROI);

%% Wavelet thresholding
EEG = happe_waveletThreshold(EEG,'Hard',3);

EEG = eeg_checkset(EEG);

%% Filter for ERP
% % This is the HAPPE filter:
% % hpfreq = 0.3;
% % lpfreq = 30;
% % EEG = pop_eegfiltnew(EEG, hpfreq, lpfreq, [], 0, [], 0) ;
% % We use the MADE filter instead 
% 
% % params:
% hptrans = 0.4;
% hpcutoff = 0.2;
% 
% % MADE filter 
% % Calculate filter order using the formula: m = dF / (df / fs), where m = filter order,
% % df = transition band width, dF = normalized transition width, fs = sampling rate
% % dF is specific for the window type. Hamming window dF = 3.3
% 
% % hpfreq = 0.4; % MADE uses 0.1, HAPPE 0.3, we use 0.4 (but
% % calculated manually)
% lpfreq = 30;
% 
% high_transband = hptrans; % high pass transition band
% low_transband = 10; % low pass transition band
% 
% hp_fl_order = 3.3 / (high_transband / EEG.srate);
% lp_fl_order = 3.3 / (low_transband / EEG.srate);
% % the value of 3.3 for the filter order is based on the hamming window
% 
% % Round filter order to next higher even integer. Filter order is always even integer.
% if mod(floor(hp_fl_order),2) == 0
%     hp_fl_order=floor(hp_fl_order);
% elseif mod(floor(hp_fl_order),2) == 1
%     hp_fl_order=floor(hp_fl_order)+1;
% end
% 
% if mod(floor(lp_fl_order),2) == 0
%     lp_fl_order=floor(lp_fl_order)+2;
% elseif mod(floor(lp_fl_order),2) == 1
%     lp_fl_order=floor(lp_fl_order)+1;
% end
% 
% % Calculate cutoff frequency
% high_cutoff = hpcutoff;
% low_cutoff = lpfreq + (low_transband/2);
% 
% % Performing high pass filtering
% EEG = eeg_checkset( EEG );
% EEG = pop_firws(EEG, 'fcutoff', high_cutoff, 'ftype', 'highpass', 'wtype', ...
%     'hamming', 'forder', hp_fl_order, 'minphase', 0);
% EEG = eeg_checkset( EEG );
% 
% % Performing low pass filtering
% EEG = eeg_checkset( EEG );
% EEG = pop_firws(EEG, 'fcutoff', low_cutoff, 'ftype', 'lowpass', 'wtype', ...
%     'hamming', 'forder', lp_fl_order, 'minphase', 0);
% EEG = eeg_checkset( EEG );
% 


%% Segmentation
for trial = 1:length(EEG.event)
    EEG.event(trial).type = strrep(EEG.event(trial).type, 'S  ', '');
    EEG.event(trial).type = strrep(EEG.event(trial).type, 'S ', '');
    EEG.event(trial).type = strrep(EEG.event(trial).type, 'S', '');
end 

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

EEG = eeg_checkset(EEG);


%% Baseline correction
% EEG = pop_rmbase(EEG, [blvalue 0]);
% EEG = eeg_checkset(EEG);
 

%% Artifact rejection
% % ROI is set above (at "bad channel detection")
% ROI_indxs = [] ;
% for i=1:size(ROI,2)
%     ROI_indxs = [ROI_indxs find(strcmpi({EEG.chanlocs.labels}, ...
%        ROI{i}))] ;
% end
% 
% % AMPLITUDE CRITERIA
% % HAPPE suggests 200 for infants and 150 for children and adults, MADE uses
% % 150 for infants. We use 150.
% minAmp = -150; 
% maxAmp = 150; 
% 
% EEG = pop_eegthresh(EEG, 1, ...
%                       ROI_indxs, [minAmp], [maxAmp], ...
%                       [EEG.xmin], [EEG.xmax], 2, 1); %last 1: reject labeled trials
% 
% % SIMILARITY CRITERIA
% num = 2; % because we have low density data
% EEG = pop_jointprob(EEG, 1, ...
%             ROI_indxs, num, num, 0, 1,0) ;% second-to-last 1: reject labeled trials
% 
% EEG = eeg_checkset(EEG);
% 

%% Bad channel interpolation
% EEG = happe_interpChan(EEG,pp,DIR);
% 
% EEG = eeg_checkset(EEG);


%% Rereferencing
% % add Cz
% [EEG,com] = famvoice_add_reference_channel(EEG);
% EEG = eeg_hist(EEG,com);
% 
% % Reref
% [~,refchan] = intersect({EEG.chanlocs.labels},{'TP9','TP10'});
% EEG = pop_reref(EEG,refchan,'keepref','on');
% EEG.setname = strcat(pp,' reref');
% 
% EEG = eeg_checkset(EEG);



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


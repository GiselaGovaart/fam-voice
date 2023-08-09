function plot_ERP_raw_loop(pp,DIR, blvalue, Subj_cbs, Subj_char)
%   Preprocessing for the FamVoice data, based on HAPPE 3.3 

%% Load the data
cd(DIR.EEGLAB_PATH);
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
close;

EEG = pop_loadbv(DIR.RAWEEG_PATH, convertStringsToChars(strcat(pp, ".vhdr")));
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',convertStringsToChars(pp),'gui','off');
[EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,1);
EEG = eeg_checkset( EEG );

%% Remove non used electrodes

if  any(strcmp(Subj_cbs,(pp)))
    % Remove FC1 and FC2, because it is not included in the setup at the
    % Charite
    EEG = pop_select(EEG, 'nochannel', {'FC1'});
    EEG = pop_select(EEG, 'nochannel', {'FC2'});
    EEG=pop_chanedit(EEG, 'changefield',{25 'labels' 'Fp2'}); % is called V1 originally
    EEG=pop_chanedit(EEG, 'changefield',{26 'labels' 'EOG1'}); % is called V2 originally
elseif any(strcmp(Subj_char,(pp)))
    % Remove Fp1, because it is not included in the setup at the CBS
    EEG = pop_select(EEG, 'nochannel', {'Fp1'});
    EEG=pop_chanedit(EEG, 'changefield',{24 'labels' 'EOG1'}); % is called V2 originally

end

% Now make sure the chanlocs from both locations have the same order:
T = struct2table(EEG.chanlocs); % convert the struct array to a table
sortedT = sortrows(T, 'labels'); % sort the table
EEG.chanlocs = table2struct(sortedT); % change it back to struct array 

% Already add new electrode posiitons here, to use those for interpolation
% later on
fprintf('Adding electrode positions using spherical template...\n');
EEG = pop_chanedit(EEG, 'lookup','Standard-10-5-Cap385_witheog.elp');

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


% %% HP filter
% % MADE filter 
% % Calculate filter order using the formula: m = dF / (df / fs), where m = filter order,
% % df = transition band width, dF = normalized transition width, fs = sampling rate
% % dF is specific for the window type. Hamming window dF = 3.3
% 
% % params:
% hptrans = 0.4;
% hpcutoff = 0.2;
% % hpfreq = 0.4; % MADE uses 0.1, HAPPE 0.3, we use 0.4 (but
% % calculated manually)
% lpfreq = 30;
% 
% high_transband = hptrans; % high pass transition band. 
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
% For the test phase:
% •        First digit: 1 for dev, 2 for stan
% •        Second digit: 0 for deviant, 1,2,3,4 for standard types: 1 = regular standard, 2 = standard pre-preceding the deviant, 3 = standard preceding the deviant, 4 = standard after the deviant.
% •        Third digit: speakers: 1,2,3,4
% For the training phase:
% •        First digit: 1 for fe, 2 for fi
% •        Second digit: for speaker: 1 for S1, 2 for S2


for trial=1:length(EEG.event)
    if strcmp(EEG.event(trial).type,'S 11')
        EEG.event(trial).type = '11';
    elseif strcmp(EEG.event(trial).type,'S 12')
        EEG.event(trial).type = '12';
    elseif strcmp(EEG.event(trial).type,'S 21')
        EEG.event(trial).type = '21';
    elseif strcmp(EEG.event(trial).type,'S 22')
        EEG.event(trial).type = '22';
    elseif strcmp(EEG.event(trial).type,'S101')
        EEG.event(trial).type = '101';
    elseif strcmp(EEG.event(trial).type,'S211')
        EEG.event(trial).type = '211';
    elseif strcmp(EEG.event(trial).type,'S221')
        EEG.event(trial).type = '221';
    elseif strcmp(EEG.event(trial).type,'S231')
        EEG.event(trial).type = '231';
    elseif strcmp(EEG.event(trial).type,'S241')
        EEG.event(trial).type = '241';        
    elseif strcmp(EEG.event(trial).type,'S102')
        EEG.event(trial).type = '102';
    elseif strcmp(EEG.event(trial).type,'S212')
        EEG.event(trial).type = '212';
    elseif strcmp(EEG.event(trial).type,'S222')
        EEG.event(trial).type = '222';
    elseif strcmp(EEG.event(trial).type,'S232')
        EEG.event(trial).type = '232';
    elseif strcmp(EEG.event(trial).type,'S242')
        EEG.event(trial).type = '242';  
    elseif strcmp(EEG.event(trial).type,'S103')
        EEG.event(trial).type = '103';
    elseif strcmp(EEG.event(trial).type,'S213')
        EEG.event(trial).type = '213';
    elseif strcmp(EEG.event(trial).type,'S223')
        EEG.event(trial).type = '223';
    elseif strcmp(EEG.event(trial).type,'S233')
        EEG.event(trial).type = '233';
    elseif strcmp(EEG.event(trial).type,'S243')
        EEG.event(trial).type = '243';  
    elseif strcmp(EEG.event(trial).type,'S104')
        EEG.event(trial).type = '104';
    elseif strcmp(EEG.event(trial).type,'S214')
        EEG.event(trial).type = '214';
    elseif strcmp(EEG.event(trial).type,'S224')
        EEG.event(trial).type = '224';
    elseif strcmp(EEG.event(trial).type,'S234')
        EEG.event(trial).type = '234';
    elseif strcmp(EEG.event(trial).type,'S244')
        EEG.event(trial).type = '244'; 
    end
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

% Save the segmented EEG as an intermediate output
EEG = eeg_checkset(EEG);

% %% BL CORR
% 
% ROI = {'F7','F3','Fz','F4','F8',...
%     'FC5','FC6','C3','C4', 'TP9', 'TP10'};  
% 
% 
% EEG = pop_rmbase(EEG, [blvalue 0]);
% EEG = eeg_checkset(EEG);
% ROI_indxs = [] ;
% for i=1:size(ROI,2)
%     ROI_indxs = [ROI_indxs find(strcmpi({EEG.chanlocs.labels}, ...
%        ROI{i}))] ;
% end
% 
% %% Artifact rejectsion
% 
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
% % Save the post-artifact rejection data as an intermediate output
% EEG = eeg_checkset(EEG);
% 
% 
% %% Rereferencing
% % This code comes from Maren's script "makeSetsEEG.m"
% 
% EEG.data(end+1,:,:) = 0;
% EEG.nbchan = size(EEG.data,1);
% EEG.chanlocs(end+1).labels = 'Cz';
% 
% for chan=1:length(EEG.chanlocs)
%     EEG.chanlocs(chan).type = 'EEG';
%     EEG.chanlocs(chan).ref = 'Cz';
% end
% 
% fprintf('Adding electrode positions using spherical template...\n');
% EEG = pop_chanedit(EEG, 'lookup','Standard-10-5-Cap385_witheog.elp');
% % EEG = pop_chanedit(EEG, 'lookup','standard_1005.elc');
% 
% [~,refchan] = intersect({EEG.chanlocs.labels},{'TP9','TP10'});
% EEG = pop_reref(EEG,refchan,'keepref','on');
% EEG.setname = strcat(pp,' reref');
% 
% % Save the rereferenced data as an intermediate output
% 
% EEG = eeg_checkset(EEG);
% 



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


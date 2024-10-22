function HAPPE_FamVoice_amp200(pp, DIR, blvalue, Subj_cbs, Subj_char)
Fz = 14;

%% Load the data
cd(DIR.EEGLAB_PATH);
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% Preprocessing for the FamVoice data, based on HAPPE 3.3 

% set electrode location for the spectoplots:
Fz_old = 1;
close;

% if ~ismember(pp, ["64", "43", "41", "38", "06", "68", "79"])
%     try
%         [EEG, com] = pop_loadbv([DIR.RAWEEG_PATH convertStringsToChars(pp) '/'], [convertStringsToChars(pp) '.vhdr']);
%     catch
%         [EEG, com] = pop_loadbv([DIR.RAWEEG_PATH convertStringsToChars(pp) '/'], ['FamVoice' convertStringsToChars(pp) '.vhdr']);
%     end
% elseif ismember(pp, ["64", "43", "41", "38"])
%     try
%         [EEG, com] = pop_loadbv([DIR.RAWEEG_PATH convertStringsToChars(pp) '/'], ['FamVoice' convertStringsToChars(pp) 'b.vhdr']);
%     catch
%         [EEG, com] = pop_loadbv([DIR.RAWEEG_PATH convertStringsToChars(pp) '/'], [convertStringsToChars(pp) '_2.vhdr']);
%     end
% elseif ismember(pp, ["06"])
%     [EEG, com] = pop_loadbv([DIR.RAWEEG_PATH convertStringsToChars(pp) '/'], ['FamVoice' convertStringsToChars(pp) '_2.vhdr']);
% elseif ismember(pp, ["68"])
%     [EEG, com] = pop_loadbv([DIR.RAWEEG_PATH convertStringsToChars(pp) '/'], '68gut.vhdr');
% elseif ismember(pp, ["79"]) % here the eeg files was names wrongly, it is however the correct dataset
%     [EEG, com] = pop_loadbv([DIR.RAWEEG_PATH convertStringsToChars(pp) '/'], '76.vhdr');
% end

pp = convertStringsToChars(pp);
    
datapath = fullfile(DIR.RAWEEG_PATH,pp);

eegfile = dir([datapath '/*.vhdr']); 
eegfile = eegfile.name;

logfile = fullfile(datapath,[pp '_logfile.txt']);

EEG = pop_loadbv(datapath, eegfile);

EEGin = EEG;

%% plot triggers
diary(strcat(DIR.qualityAssessment,pp,'_commandwindowoutputTriggers.txt'));

fig0 = famvoice_plot_triggers(EEGin);
title(pp);
set(gcf,'Name',pp,'Units','Normalized','Position',[0.08 0.3 0.4 0.4]);
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('triggersCheck_beforeFixTriggers',pp,'.png')));

%% fix triggers and detect stimulation pauses (code written by Maren Grigutsch)
if isfile(logfile)
    EEG = famvoice_fix_bit0(EEGin,logfile);
end

EEG = famvoice_fix_overlap(EEG);

longEEG = EEG;
longEEG.setname = [convertStringsToChars(pp)];
[ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG,longEEG);
eeglab redraw;

pauses = famvoice_detect_pauses(longEEG,10,10);

fig1 = famvoice_plot_triggers(longEEG,pauses,'pause');
title([pp ' fixed']);
set(gcf,'Name',[pp ' fixed'],'Units','Normalized','Position',[0.52,0.3,0.4,0.4]);
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('fixedTriggerTimeSeriesAndPauses',pp,'.png')));


%% 
if ~isempty(pauses)
   %%Delete the pauses from the dataset

    fprintf('Deleting n=%d pauses from the dataset.\n',size(pauses,1));
    
    [EEG,com] = pop_select(longEEG,'nopoint',pauses);
    EEG = eeg_hist(EEG,com);
    
    EEG.setname = [convertStringsToChars(pp) ' without pauses'];
    [ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG,EEG);
    eeglab redraw;
    
    % Display the trigger time series after pauses have been deleted.
    fig2 = famvoice_plot_triggers(EEG);
    exportgraphics(gcf, strcat(DIR.plotsQA, ...
        strcat('triggerTimeSeriesAfterPausesDeleted',pp,'.png')));

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
diary off

%% check and visualize
if ~isempty(pauses)
    EEG = eeg_hist(EEG,com);
end
EEG = eeg_checkset( EEG );

% pop_eegplot(EEG);

% Vizualize
% spectr
fieldtripEEG = eeglab2fieldtrip(EEG,'preprocessing','none');

cfg = [];
cfg.length = 5;
cfg.overlap = 0;
data_segmented = ft_redefinetrial(cfg, fieldtripEEG);

cfg = [];
cfg.method     = 'mtmfft';
cfg.taper      = 'hanning';
cfg.foilim     = [1 30];
cfg.keeptrials = 'no';
freq_segmented = ft_freqanalysis(cfg, data_segmented);

close all
figure;
hold on;
plot(freq_segmented.freq, freq_segmented.powspctrm(Fz_old,:)) 
ylim([0 40]);
xlabel('Frequlency at Fz (Hz)');
ylabel('absolute power (uV^2)');
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('spectr_raw_',pp,'.png')));

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

% Save the filtered dataset as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_filtered_lnreduced.set')), ...
    'filepath', convertStringsToChars(DIR.intermediateProcessing));

%% Detect bad channels
% find ROI channels
ROI = {'F7','F3','Fz','F4','F8',...
    'FC5','FC6','C3','C4', 'TP9', 'TP10'};  
% Here I cannot add Cz, that's a consequence of choosing to reref in the end

EEG = happe_detectBadChannels(EEG,pp,DIR,ROI);

%% Wavelet thresholding
EEG = happe_waveletThreshold(EEG,'Hard',3);

% Save the wavelet-thresholded EEG as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_wavclean.set')), ...
    'filepath', convertStringsToChars(DIR.waveletCleaned));

%% Filter for ERP
% This is the HAPPE filter:
% hpfreq = 0.3;
% lpfreq = 30;
% EEG = pop_eegfiltnew(EEG, hpfreq, lpfreq, [], 0, [], 0) ;
% We use the MADE filter instead 

% params:
hptrans = 0.4;
hpcutoff = 0.2;

% MADE filter 
% Calculate filter order using the formula: m = dF / (df / fs), where m = filter order,
% df = transition band width, dF = normalized transition width, fs = sampling rate
% dF is specific for the window type. Hamming window dF = 3.3

% hpfreq = 0.4; % MADE uses 0.1, HAPPE 0.3, we use 0.4 (but
% calculated manually)
lpfreq = 30;

high_transband = hptrans; % high pass transition band
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

% Save the ERP filtered EEG as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_ERPfiltered.set')), ...
    'filepath', convertStringsToChars(DIR.ERPfiltered));

% Visualize
% spectr
fieldtripEEG = eeglab2fieldtrip(EEG,'preprocessing','none');

cfg = [];
cfg.length = 20;  % changed the resolution such that I can actually see whether it filtered out 0-0.4 Hz
cfg.overlap = 0;
data_segmented = ft_redefinetrial(cfg, fieldtripEEG);

cfg = [];
cfg.method     = 'mtmfft';
cfg.taper      = 'hanning';
cfg.foilim     = [0.1 30];
cfg.keeptrials = 'no';
freq_segmented = ft_freqanalysis(cfg, data_segmented);

close all
figure;
hold on;
plot(freq_segmented.freq, freq_segmented.powspctrm(Fz,:)) 
ylim([0 40]);
xlabel('Frequency at Fz (Hz)');
ylabel('absolute power (uV^2)');
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('spectr_afterfiltering_',pp,'.png')));

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
    104, 214, 224, 234, 244}; %testS4

segmentStart = -0.2; 
segmentEnd = 0.650;

EEG = pop_epoch(EEG, onsetTags, ...
    [segmentStart, segmentEnd], 'verbose', ...
    'no', 'epochinfo', 'yes') ;

% Save the segmented EEG as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_segmented.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));

% Visualize
% plottopo
close all
pop_plottopo(EEG, [1:EEG.nbchan] , 'after segmentation', 0, 'ydir',1)
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('plottopo_afterSegm_',pp,'.png')), ...
    'Resolution', 300);

%% Baseline correction
EEG = pop_rmbase(EEG, [blvalue 0]);
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_segmented_blcor.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));

% Visualize
% plottopo
close all
pop_plottopo(EEG, [1:EEG.nbchan] , 'after baseline', 0, 'ydir',1)
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('plottopo_afterBaseline_',pp,'.png')), ...
    'Resolution', 300);
 

%% Artifact rejection
% ROI is set above (at "bad channel detection")
ROI_indxs = [] ;
for i=1:size(ROI,2)
    ROI_indxs = [ROI_indxs find(strcmpi({EEG.chanlocs.labels}, ...
       ROI{i}))] ;
end

% AMPLITUDE CRITERIA
% HAPPE suggests 200 for infants and 150 for children and adults, MADE uses
% 150 for infants. We use 150.
minAmp = -200; 
maxAmp = 200; 

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


%% Bad channel interpolation
EEG = happe_interpChan(EEG,pp,DIR);

% Save the interpolated data as an intermediate output
EEG = eeg_checkset(EEG);
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_interpolated.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));


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
pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_reref.set')), ...
    'filepath', convertStringsToChars(DIR.segmenting));

% Visualize
% spectr
fieldtripEEG = eeglab2fieldtrip(EEG,'preprocessing','none');

cfg = [];
cfg.length = 5;
cfg.overlap = 0;
%data_segmented = ft_redefinetrial(cfg, fieldtripEEG);

cfg = [];
cfg.method     = 'mtmfft';
cfg.taper      = 'hanning';
cfg.foilim     = [1 30];
cfg.keeptrials = 'no';
freq_segmented = ft_freqanalysis(cfg, data_segmented);

close all
figure;
hold on;
plot(freq_segmented.freq, freq_segmented.powspctrm(Fz,:)) 
ylim([0 40]);
xlabel('Frequency at Fz (Hz)');
ylabel('absolute power (uV^2)');
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('spectr_clean_',pp,'.png')));

% plottopo
close all
pop_plottopo(EEG, [1:EEG.nbchan] , 'after reref (clean)', 0, 'ydir',1)
exportgraphics(gcf, strcat(DIR.plotsQA, ...
    strcat('plottopo_clean_',pp,'.png')), ...
    'Resolution', 300);


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
    fileName = convertStringsToChars(strcat(DIR.processed,pp,'_processed_', ...
        int2str(usedTags(i)),'.set'));
    pop_saveset(eegByTags(i), 'filename', ...
         fileName);
end

end



EEG = pop_loadset(['/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/' ...
    'hptrans-0.30hpcutoff-0.15_window-hamming_beta0.00_' ...
    'amp-150_wavThreshold-Hard_version-2_baseline-yes_blvalue--200_' ...
    'muscIL-off_detrend-off/04-segmenting/' ...
    '01_reref.set']);

pop_eegplot(EEG)































%
%chaninfo12= load('-mat','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/01-intermediate_processing/channelInfo_12.mat')

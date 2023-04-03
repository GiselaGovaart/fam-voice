function EEG = happe_waveletThreshold(EEG,wavThreshold,version)
%EEG = happe_waveletThreshold(EEG)
%   Performs wavelet thresholding according to the HAPPE 2.1 or 3.0 pipeline


% in a between (a previous 3.0) the values for wavLvl were 10, 9, 8, and
% the 'Wavelet' for 3.0 was 'bior6.8'


%% determine wavelet level

if version == 2
    % HAPPE2.0
    if EEG.srate > 500; wavLvl = 13 ;
    elseif EEG.srate > 250 && EEG.srate <= 500; wavLvl= 12 ;
    elseif EEG.srate <= 250; wavLvl = 11 ;
    end
elseif version == 3
    %HAPPE3.0
    if EEG.srate > 500; wavLvl = 11;
    elseif EEG.srate > 250 && EEG.srate <= 500; wavLvl= 10;
    elseif EEG.srate <= 250; wavLvl = 9;
    end
end

ThresholdRule = wavThreshold ;

EEG.data = double(EEG.data);

%% perform wavelet denoising
artifacts = wdenoise(reshape(EEG.data, size(EEG.data, 1), ...
    [])', wavLvl, 'Wavelet', 'coif4', 'DenoisingMethod', ...
    'Bayes', 'ThresholdRule', ThresholdRule, 'NoiseEstimate', ...
    'LevelDependent')' ;

% if version == 2
%     %HAPPE2.0
%     artifacts = wdenoise(reshape(EEG.data, size(EEG.data, 1), ...
%         [])', wavLvl, 'Wavelet', 'coif4', 'DenoisingMethod', ...
%         'Bayes', 'ThresholdRule', ThresholdRule, 'NoiseEstimate', ...
%         'LevelDependent')' ;
% elseif version == 3
%     %HAPPE3.0
%     artifacts = wdenoise(reshape(EEG.data, size(EEG.data, 1), ...
%         [])', wavLvl, 'Wavelet', 'bior6.8', 'DenoisingMethod', ...
%         'Bayes', 'ThresholdRule', ThresholdRule, 'NoiseEstimate', ...
%         'LevelDependent')' ;
% end

%% remove artifacts from EEG data
preEEG = reshape(EEG.data, size(EEG.data,1), []) ;
postEEG = preEEG - artifacts ;
EEG.data = postEEG ;

EEG.setname = 'wavcleanedEEG' ;


end


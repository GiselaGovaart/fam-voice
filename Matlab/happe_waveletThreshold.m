function EEG = happe_waveletThreshold(EEG,wavThreshold,version)
%EEG = happe_waveletThreshold(EEG)
%   Performs wavelet thresholding according to the HAPPE 2.1 pipeline

%% determine wavelet level

if version == 2
    % HAPPE2.0
    if EEG.srate > 500; wavLvl = 13 ;
    elseif EEG.srate > 250 && EEG.srate <= 500; wavLvl= 12 ;
    elseif EEG.srate <= 250; wavLvl = 11 ;
    end
elseif version == 3
    %HAPPE3.0
    if EEG.srate > 500; wavLvl = 10 ;
    elseif EEG.srate > 250 && EEG.srate <= 500; wavLvl= 9 ;
    elseif EEG.srate <= 250; wavLvl = 8 ;
    end
end

ThresholdRule = wavThreshold ;

EEG.data = double(EEG.data);

%% perform wavelet denoising

if version == 2
    %HAPPE2.0
    artifacts = wdenoise(reshape(EEG.data, size(EEG.data, 1), ...
        [])', wavLvl, 'Wavelet', 'coif4', 'DenoisingMethod', ...
        'Bayes', 'ThresholdRule', ThresholdRule, 'NoiseEstimate', ...
        'LevelDependent')' ;
elseif version == 3
    %HAPPE3.0
    artifacts = wdenoise(reshape(EEG.data, size(EEG.data, 1), ...
        [])', wavLvl, 'Wavelet', 'bior6.8', 'DenoisingMethod', ...
        'Bayes', 'ThresholdRule', ThresholdRule, 'NoiseEstimate', ...
        'LevelDependent')' ;
end

%% remove artifacts from EEG data
preEEG = reshape(EEG.data, size(EEG.data,1), []) ;
postEEG = preEEG - artifacts ;
EEG.data = postEEG ;

EEG.setname = 'wavcleanedEEG' ;

end


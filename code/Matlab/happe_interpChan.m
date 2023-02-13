function outEEG = happe_interpChan(EEG,pp,DIR)
%EEG = happe_interpChan(EEG,pp)
%   Interpolating bad channels using splines
%   NB: also interpolates EOG in case they were flat (see
%   happe_detectBadChannels.m).
%   You should not use EOG for further analyses, but this ensures all 
%   participants have the same number of channels.

%% load names of removed channels

load(strcat(DIR.intermediateProcessing,'channelInfo_',pp));

%% compare which channels were removed
origChans = struct2cell(original);
origChans = squeeze(origChans(1,1,:));

goodChans = struct2cell(selected);
goodChans = squeeze(goodChans(1,1,:));

idx = true(1,length(origChans));
[~,idxKept] = intersect(origChans,goodChans);
idx(idxKept) = false;

if any(idx)
    tmpEEG = EEG;
    tmpEEG.chanlocs = original;
    
    tmpEEG.data = zeros(length(idx),size(EEG.data,2),size(EEG.data,3));
    tmpEEG.data(~idx,:,:) = EEG.data;
    tmpEEG.nbchan = length(idx);
    
    outEEG = pop_interp(tmpEEG,find(idx),'spherical');
    outEEG.setname = 'wavcleanedEEG_rej_chan_int';
    outEEG = eeg_checkset(outEEG);
else
    outEEG = EEG;
end

outEEG.chanlocs = original;


end

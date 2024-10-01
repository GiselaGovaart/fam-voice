function [pauses] = famvoice_detect_pauses(EEG,preSec,postSec)

% FAMVOICE_detect_PAUSES - Detect stimulation pauses in an EEGLAB dataset.
% 
% Usage:
%       pauses = famvoice_detect_pauses(EEG);
%       pauses = famvoice_detect_pauses(EEG,preSec,postSec);
%
% Inputs:
%       EEG    -  an EEGLAB dataset structure; continuous data (i.e. not epoched)
%    preSec    -  (optional) time period (in seconds) before each stimulus 
%                   event that is not counted as a pause; 
%                   default = 10
%   postSec    -  (optional) time period (in seconds) after each stimulus 
%                   event that is not counted as a pause; 
%                   default = 10
% 
% Outputs:
%    pauses    -   N-by-2 array, where each row indicates the latency 
%                   boundaries [start, end] (samples) of a stimulation pause 
% Example:
%    Pauses = famvoice_pauses(EEG.event,{'S 11','S 12'},10,10);
%   
%
% See also EEGLAB.

% Copyright (C) 2023 Maren Grigutsch, MPI CBS Leipzig, <grigu@cbs.mpg.de>


%%

funcname = coder.mfunctionname;

if nargin<3 || isempty(postSec)
    postSec = 10;
end
if nargin<2 || isempty(preSec)
    preSec = 10;
end

% Convert seconds to sample points.
nPre = round(preSec*EEG.srate);
nPost = round(postSec*EEG.srate);



%% Load FamVoice event types.

[~, trg] = famvoice_check_triggers(EEG);

%% Identify stimulation pauses; pay attention to recording pauses and restarts.

i0 = 1;               % potential begin of a pause
was_restarted = true; 
pauses = [];
stimType = trg.stimulus;

EEG = eeg_checkset(EEG,'event');

for k=1:numel(EEG.event)
    if ismember(EEG.event(k).type,stimType)
        if was_restarted == true   
            if ~isnan(i0)
                i1 = max(i0,EEG.event(k).latency - nPre); % end of the pause
                pauses = [pauses; [i0 i1]];
            end           
        else 
            gap = EEG.event(k).latency - prevStimLatency;
            if gap > nPre+nPost
                i0 = prevStimLatency + nPost + 1;
                i1 = EEG.event(k).latency - nPre;
                pauses = [pauses; [i0 i1]];
            end
        end
        was_restarted = false;
        prevStimLatency = EEG.event(k).latency;
        i0 = NaN;
    elseif strcmp(EEG.event(k).type,'boundary') 
     % recording was stopped and restarted; always cut at segment boundaries
        i1 = EEG.event(k).latency; 
        if ~isnan(i0)
            pauses = [pauses; [i0 i1]];
        elseif ~was_restarted
            i0 = prevStimLatency + nPost + 1;
            pauses = [pauses; [i0 i1]];  
        end
        i0 = EEG.event(k).latency;
        was_restarted = true;
    end
end

if isnan(i0)
    i0 = prevStimLatency + nPost +1;
end
i1 = EEG.pnts;
pauses = [pauses; [i0 i1]];

%% Post-processing

pauses(pauses(:,2)<=pauses(:,1),:) = [];

% merge contiguous segments
tmp = reshape(pauses',1,[]);
idx = find(tmp(2:end)==tmp(1:end-1));
tmp([idx idx+1]) = [];
pauses = reshape(tmp,2,[])';

%%
fprintf('%s(): Found n=%d pause(s):\n',funcname,size(pauses,1))
arrayfun(@(x,y,x1,y1) fprintf('  %8d\t-%8d    |   %8.3f - %8.3f s\n',...
    x,y,x1,y1),pauses(:,1),pauses(:,2),...
    (pauses(:,1)-1)/EEG.srate,(pauses(:,2)-1)/EEG.srate);
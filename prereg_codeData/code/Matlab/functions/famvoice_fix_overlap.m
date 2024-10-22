function   EEGout = famvoice_fix_overlap(EEGin)

% FAMVOICE_FIX_OVERLAP - Corrects the event structure in an EEG dataset 
% due to an error in the recording where block start and stimulus triggers 
% occasionally overlapped at the trigger port.
%
% Usage:
%   EEGout = famvoice_fix_overlap(EEGin);
%
% Inputs:
%    EEGin  -  EEGLAB data structure
%                 or
%              BrainVision Header (*.vhdr) filename

% Copyright (C) 2024 Maren Grigutsch, MPI CBS Leipzig, <grigu@cbs.mpg.de>

% $Id: famvoice_fix_overlap.m,v 1.1 2024/09/30 17:26:44 grigu Exp grigu $

%%

myName = mfilename;

if ischar(EEGin)
    if isfile(EEGin)
       [eegpath,eegname,ext] = fileparts(EEGin); 
       EEGin = pop_loadbv(eegpath,[eegname ext]);
    else
        error('Wrong input.');
    end
elseif ~isstruct(EEGin) || ~isfield(EEGin,'event')
    error('Wrong input.');
end


%% Check for fake triggers due to the overlap of a block start ('S  1') and 
%  a stimulus trigger at the trigger port.

ev = EEGin.event;

idx = find(strcmp({ev.type},'S  1'));
if isempty(idx)
    fprintf('Nothing to do.\n')
    EEGout = EEGin;
    return
end

numEvent = numel(ev);
numChanged = 0;
for k = idx   
    if (k < numEvent-2) 
        trg1 = sscanf(ev(k+1).type,'S%d');
        trg2 = sscanf(ev(k+2).type,'S%d');
        latencyGap = ev(k+2).latency - ev(k+1).latency;
        if (trg1 == trg2 + 1) && latencyGap == 1
            fprintf('%s: Event #%d: changing type ''%s'' ==> ''%s''\n',myName,k+1,ev(k+1).type,ev(k+2).type);
            ev(k+1).type = ev(k+2).type;
            numChanged = numChanged + 1;
            ev(k+2).type = 'XXX';
            fprintf('%s: Event #%d: will be deleted.\n',myName,k+2);
        end
    end
end

numXXX = sum(strcmp({ev.type},'XXX'));
if numXXX > 0
    ev(strcmp({ev.type},'XXX')) = [];
end
fprintf('%s: Changed %d event(s); deleted %d event(s).\n',myName,numChanged,numXXX)

%% Prepare Output.

EEGout = EEGin;
EEGout.event = ev;

if numChanged || numXXX
    str = 'Corrected a recording bug where block start and stimulus triggers overlapped at the trigger port.';
    EEGout.comments = pop_comments(EEGout.comments,'',str,1);
end


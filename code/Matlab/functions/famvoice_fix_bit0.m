function EEGout = famvoice_fix_bit0(EEGin, logfile)

% FAMVOICE_FIX_BIT0 - Fixes incorrect trigger codes in EEG records 
% caused by bit 0 being incorrectly always set to high.
%
% Usage:
%   EEGout = famvoice_fix_bit0(EEGin, logfile);
%
% Inputs:
%    EEGin  -  BrainVision Header (*.vhdr) filename
%                 or
%              EEGLAB data structure
%  logfile  -  filename of the trial table created by Presentation during
%               EEG recording
%  

% Copyright (C) 2024 Maren Grigutsch, MPI CBS Leipzig, <grigu@cbs.mpg.de>

% $Id: famvoice_fix_bit0.m,v 1.1 2024/09/30 17:24:56 grigu Exp grigu $



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

logtbl = readtable(logfile,'NumHeaderLines',8,'ReadRowNames',false);

%% Change incorrect event types according to trigger codes given in the logfile.
%  Rename fake triggers: 'S  1' ==> 'XXX'.

fprintf('%s: Fixing bit 0 error in trigger codes...\n', myName)

ev = EEGin.event;
numEvent = numel(ev);

% add field 'block' to event structure
[ev.block] = deal('');

numLog = numel(logtbl.Trigger);

ilog = 1;  % index in logtbl
k = 1;     % index in EEG event structure (EEGin.event)

numChanged = 0;

while k <= numEvent - 1 

    if strcmp(ev(k).code,'Stimulus')       
        
        % FIXme!
        if ilog <= numLog
            logtrg = logtbl.Trigger(ilog);
        else
            logtrg = 0;
        end
        
        trg = sscanf(ev(k).type,'S%d');

        if trg == logtrg 
        % received the expected trigger
            ev(k).block = logtbl.Block{ilog};
            % fprintf('k=%5d, ilog=%5d \t%s / %d\n',k,ilog,ev(k).type,logtrg);
            ilog = ilog + 1;
            if strcmp(ev(k+1).type,'S  1') && ev(k+1).latency - ev(k).latency <= 3
            % received unexpected trigger 'S  1' immediately after the correct stimulus trigger,
            % as bit 0 at the trigger port was always high by mistake
                ev(k+1).type = 'XXX';
                k = k + 1;
            end
        elseif mod(trg,2) && trg==logtrg+1 && strcmp(ev(k+1).type,'S  1') && ev(k+1).latency - ev(k).latency <= 3
        % received incorrect trigger (value increased by 1), immediately followed by an unexpected 'S   1', 
        % as bit 0 was always high and added to the original trigger
            % fprintf('k=%5d, ilog=%5d \t%s / %d\n',k,ilog,ev(k).type,logtrg);
            ev(k).type = sprintf('S%3d',logtrg);
            ev(k).block = logtbl.Block{ilog};
            numChanged = numChanged + 1;
            ev(k+1).type = 'XXX';
            ilog = ilog + 1;
            k = k + 1;
        elseif trg == 101 && strcmp(ev(k+1).type,'S  1') && ev(k+1).latency - ev(k).latency <= 3
        % received incorrect block end  trigger ('S101' instead of 'S100'),
        % immediately followed by 'S  1', as bit 0 was always high by mistake 
        % and was added to the original trigger
            % fprintf('k=%5d, ilog=%5d \t%s / %d ==> S100\n',k,ilog,ev(k).type,logtrg);
            ev(k).type = 'S100';  % block end trigger
            numChanged = numChanged + 1;
            ev(k+1).type = 'XXX';
            k = k + 1;

        elseif trg == 1  || trg == 100
        % received correct block start/end trigger?
            % just keep 
        else
            % fprintf('****k=%5d, ilog=%5d\t %s / %d***\n',k, ilog, ev(k).type,logtrg);
            warning('Found unexpected trigger %s (event #%d).',ev(k).type,k);
        end
    end 

    k = k + 1;   
end

if ilog <= numLog
    warning('The log file contains additional trials that are not included in the data file.');
end

if k == numEvent && strcmp(ev(k).code,'Stimulus') && ~strcmp(ev(k).type,'S100')
    warning('Found additional trigger %s (event #%d).',ev(k).type,k);
end


fprintf('%s: Changed %d trigger codes.\n', myName,numChanged);


%% Delete incorrect 'S  1' (renamed 'XXX') events.

numXXX = sum(strcmp({ev.type},'XXX'));
if numXXX > 0
    ev(strcmp({ev.type},'XXX')) = [];
end
fprintf('%s: Deleted %d fake ''S  1'' events.\n',myName,numXXX);

%% 

EEGout = EEGin;
EEGout.event = ev;
if numChanged > 0 || numXXX > 0
    str = 'Fixed trigger recording bug where bit 0 was always high due to an error.';
    EEGout.comments = pop_comments(EEGout.comments,'',str,1);
    str = sprintf('%s: Changed the type of %d event(s).',myName,numChanged);
    EEGout.comments = pop_comments(EEGout.comments,'',str,1);
    str = sprintf('%s: Deleted %d fake ''S  1'' event(s).',myName,numXXX);    
    EEGout.comments = pop_comments(EEGout.comments,'',str,1);    
end



function [EEG, com] = famvoice_fix_chanlocs(EEG)

% FAMVOICE_FIX_CHANLOCS - Edit the channel locations structure of an EEGLAB
% dataset (EEG.chanlocs):
%
%         change channel label V1 --> FP2; 
%         correct the coordinates of channel V2; 
%         add channel types ('EEG'|'EOG') and 
%         add reference info ('Cz') for each channels.
%
% Usage:
%           EEGOUT = famvoice_fix_chanlocs(EEG);
%    [EEGOUT, com] = famvoice_fix_chanlocs(EEG);
% 
% Input:
%       EEG  -  an EEGLAB dataset structure
%  
% Outputs:
%    EEGOUT  -  updated EEGLAB dataset
%       com  -  the command string (history entry)
%
% Author: Maren Grigutsch, MPI CBS Leipzig, 2023


com = '';
funcame = coder.mfunctionname;

chanlocs = EEG.chanlocs;
    
% Fix channel label V1 --> FP2 ?
iV1 = find(strcmp({chanlocs.labels},'V1'));
if ~isempty(iV1)
    chanlocs(iV1).labels = 'FP2';
end

% Fix location info of electtrode V2 
iV2 = find(strcmp({chanlocs.labels},'V2'));
if ~isempty(iV2)
    loc = chanlocs(iV2);
    loc.sph_radius = 1;
    loc = convertlocs(loc,'sph2cart');
    chanlocs(iV2) = loc;
end

% add channel types
[chanlocs.type] = deal('EEG');
if ~isempty(iV2)
    chanlocs(iV2).type = 'EOG';
end

% add reference info
if all(strcmp({chanlocs.ref},''))
    [chanlocs.ref] = deal('Cz');
end

% update the dataset
EEG.chanlocs = chanlocs;
EEG = eeg_checkset(EEG);

com = sprintf('EEG = %s(EEG);',funcame);



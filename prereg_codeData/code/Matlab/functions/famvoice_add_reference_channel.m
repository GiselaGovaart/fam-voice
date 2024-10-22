function [EEG, com] = famvoice_add_reference_channel(EEG)

% FAMVOICE_ADD_REFERENCE_CHANNEL - Add the online reference (Cz) to an 
% EEGLAB dataset.
%
% Usage:
%          EEGOUT = famvoice_add_reference_channel(EEG);
%   [EEGOUT, com] = famvoice_add_reference_channel(EEG);
%
% Input:
%       EEG  -  an EEGLAB dataset structure
%  
% Outputs:
%    EEGOUT  -  the updated EEGLAB dataset
%       com  -  the command string (history entry)
%
% Author: Maren Grigutsch, MPI CBS Leipzig, 2023


%%

funcname = coder.mfunctionname;
com = sprintf('EEG = %s( EEG );', funcname);

% The online reference was Cz.
iCz = find(strcmp({EEG.chanlocs.labels},'Cz'));

% Do nothing if the channel Cz already exists in the dataset or 
% the dataset has already been re-referenced.
if ~isempty(iCz)
    warning('Nothing to do; channel ''Cz'' is already present in the dataset.');    
elseif ~all(strcmp({EEG.chanlocs.ref},'')) & ~all(strcmp({EEG.chanlocs.ref},'Cz'))
    error('ERROR: Cannot add the recording reference channel (''Cz'':) The dataset has already been re-referenced.');
else

    fprintf('%s(): Adding the reference channel, Cz, to the dataset.',funcname)

    chanlocs = EEG.chanlocs;

    if all(strcmp({EEG.chanlocs.ref},''))
        [chanlocs.ref] = deal('Cz');
    end

    if all(strcmp({EEG.chanlocs.type},''))
        [chanlocs.ref] = deal('EEG');
    end
    
    % build channel locations of Cz from its spherical BESA coordinates.
    refloc = [];
    refloc.labels = 'Cz';
    refloc.sph_theta_besa = 0;
    refloc.sph_phi_besa = 0;
    refloc.sph_radius = 1;
    
    refloc = convertlocs(refloc,'sphbesa2all');
    refloc = rmfield(refloc,{'sph_theta_besa','sph_phi_besa'});

    refloc.type='EEG';
    refloc.ref = 'Cz';
    refloc.urchan = [];

    % add locations of the reference channel
    chanlocs(end+1) = refloc;

    % add the reference time series (vector of zeros) to the data matrix
    EEG.data(end+1,:,:) = 0;
    EEG.nbchan = EEG.nbchan+1;

    % update the chanlocs structure
    EEG.chanlocs = chanlocs;

    % check the consistency of the fields in the updated EEG dataset
    EEG = eeg_checkset(EEG);
end

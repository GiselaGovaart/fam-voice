function makeSetsEEG(pp,DIR)
%makeSetsEEG(pp)
%   Takes the raw EEG data files as created in the lab and transforms them
%   into .set files that EEGLAB can read

% try commting this out, to get full EEG in the end
eeglab nogui

EEGFilename = convertStringsToChars(strcat(pp, ".hdr"));
EEG = pop_loadrefa8(DIR.RAWEEG_PATH, EEGFilename, [], 1:28);
EEG = eeg_checkset(EEG);
EEG.setname = strcat(pp, " raw");


%% Fix channel names and add channel info (type, ref).

fprintf('Fixing channel labels...\n');

% fix channel labels
old_new = {
    'H-F9', 'F9'; 
    'H+F10', 'F10'; 
    'V+Fp2', 'Fp2'; 
    'V-', 'EOG1'
    };


for k=1:size(old_new,1)
    ii = strmatch(old_new{k,1},{EEG.chanlocs.labels});
    if ~isempty(ii)
       EEG.chanlocs(ii).labels = old_new{k,2}; 
       fprintf('   changed channel label ''%s'' --> ''%s''.\n',old_new{k,1},old_new{k,2});
    end
end

% add type and reference info

for chan=1:28
    EEG.chanlocs(chan).type = 'EEG';
    EEG.chanlocs(chan).ref = 'Cz';
end


%% Add electrode positions.

fprintf('Adding electrode positions using spherical template...\n');
EEG = pop_chanedit(EEG, 'lookup','Standard-10-5-Cap385_witheog.elp');
EEG.setname = strcat(pp,' loc');

%% Re-reference (keeping the reference channels in the dataset).
% commented out here, because I only do it in the end of my pipeline

% [~,refchan] = intersect({EEG.chanlocs.labels},{'TP9','TP10'});
% EEG = pop_reref(EEG,refchan,'keepref','on');
% % EEG.setname = [Subj ' reref'];
% EEG.setname = strcat(pp,' reref');
% 
% % if is_interactive
% %    [ALLEEG, EEG, CURRENTSET, com] = pop_newset(ALLEEG, EEG, CURRENTSET,'gui','off');
% %    eeglab redraw
% % end

%% Save as EEGLAB dataset.

filename = convertStringsToChars(strcat(pp, '.set'));
filepath = DIR.SET_PATH;
pop_saveset( EEG, filename, filepath);
end


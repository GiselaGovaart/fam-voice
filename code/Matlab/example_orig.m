%% Load raw data.

DataPath = '../data/';
Subj =  '32';


[EEG, com] = pop_loadbv(DataPath, [Subj '.vhdr']);
EEG = eeg_hist(EEG,com);


%% Edit channel locations and add the reference channel, Cz.

[EEG,com] = famvoice_fix_chanlocs(EEG);
EEG = eeg_hist(EEG,com);

[EEG,com] = famvoice_add_reference_channel(EEG);
EEG = eeg_hist(EEG,com);


%% Detect stimulation pauses.

longEEG = EEG;

longEEG.setname = [Subj];
[ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG,longEEG);
eeglab redraw;

pauses = famvoice_detect_pauses(longEEG);

% Display the trigger time series and the pauses.
fig = famvoice_plot_triggers(longEEG,pauses,'pause');


%% 
if ~isempty(pauses)
   %%Delete the pauses from the dataset

    fprintf('Deleting n=%d pauses from the dataset.\n',size(pauses,1));
    
    [EEG,com] = pop_select(longEEG,'rmpoint',pauses);
    EEG = eeg_hist(EEG,com);
    
    EEG.setname = [Subj ' without pauses'];
    [ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG,EEG);
    eeglab redraw;
    
    % Display the trigger time series after pauses have been deleted.
    fig2 = famvoice_plot_triggers(EEG);


   %% Check consistency between datasets before and after deleting pauses.

    fprintf('Checking consistency between datasets before and after deleting pauses...\n')
    
    trg = famvoice_triggers;
    stimType = trg.stimulus;
    n_long = sum(ismember({longEEG.event.type},stimType));
    n = sum(ismember({EEG.event.type},stimType));
    
    if n_long ~= n
        error('ERROR: Inconsistent number of stimulus events after deleting pauses: got %d; expected %d',n,n_long);
    end
    
    % Cut epochs around each stimulus trigger and compare the data.
    epoch_long = pop_epoch(longEEG,stimType,[-0.5 0.5]);
    epoch = pop_epoch(EEG,stimType,[-0.5 0.5]);
    m = max(abs(epoch.data(:)-epoch_long.data(:))); 

    fprintf('Comparing data matrices...')
    if m ~= 0
        error('Found inconsistent data between datasets; max. diviation: %e uV',m)
    end
    
    fprintf('...ok.\n')
    clear trg stimTrg n_long n m epoch_long epoch
%%
end

function plot_ERP_proc_withSD_all(DIR, Subj)

% CondNr = ["11" "21" "12" "22" "101" "102" "103" "104"  ...
%     "211" "212" "213" "214" "221" "222" "223" "224" "231" "232" ...
%     "233" "234" "241" "242" "243" "244"];

% load EEGlab
rmpath(genpath(DIR.EEGLAB_PATH));
cd(DIR.EEGLAB_PATH);
eeglab; close;

DIR.processed = convertStringsToChars(DIR.processed);
DIR.grandaverage = convertStringsToChars(DIR.grandaverage);

%% Put all the names of the files together
cd(DIR.processed)
counter = 1;
GAargD12 = cell(counter);
GAargS121 = cell(counter);
GAargS122 = cell(counter);

GAargD3 = cell(counter);
GAargS31 = cell(counter);
GAargS32 = cell(counter);

GAargD4 = cell(counter);
GAargS41 = cell(counter);
GAargS42 = cell(counter);

for ipp = 1:length(Subj)
    setNameD1 = strcat(Subj(ipp),"_processed_101.set");
    setNameD2 = strcat(Subj(ipp),"_processed_102.set");
    if isfile(strcat(DIR.processed,setNameD1))
    setNameD12 = setNameD1;
    elseif isfile(strcat(DIR.processed,setNameD2))
    setNameD12 = setNameD2;
    end

    setNameS11 = strcat(Subj(ipp),"_processed_221.set");
    setNameS12 = strcat(Subj(ipp),"_processed_222.set");
    if isfile(strcat(DIR.processed,setNameS11))
    setNameS121 = setNameS11;
    elseif isfile(strcat(DIR.processed,setNameS12))
    setNameS121 = setNameS12;
    end

    setNameS21 = strcat(Subj(ipp),"_processed_231.set");
    setNameS22 = strcat(Subj(ipp),"_processed_232.set");
    if isfile(strcat(DIR.processed,setNameS21))
    setNameS122 = setNameS21;
    elseif isfile(strcat(DIR.processed,setNameS22))
    setNameS122 = setNameS22;
    end

    setNameD3 = strcat(Subj(ipp),"_processed_103.set");
    setNameS31 = strcat(Subj(ipp),"_processed_223.set");
    setNameS32 = strcat(Subj(ipp),"_processed_233.set");

    setNameD4 = strcat(Subj(ipp),"_processed_104.set");
    setNameS41 = strcat(Subj(ipp),"_processed_224.set");
    setNameS42 = strcat(Subj(ipp),"_processed_234.set");

    % set the trial numbers, but only if the file is there
    trialsD12 = 0;
    trialsS12= 0;
    trialsD3 = 0;
    trialsS3 = 0;
    trialsD4 = 0;
    trialsS4 = 0;

    % S12
    if isfile(strcat(DIR.processed,setNameD12))
        setD12 = pop_loadset(convertStringsToChars(setNameD12));
        trialsD12 = setD12.trials;
    end

    if isfile(strcat(DIR.processed,setNameS121))
        setS121 = pop_loadset(convertStringsToChars(setNameS121));
        trialsS121 = setS121.trials;
    end
    if isfile(strcat(DIR.processed,setNameS122))
        setS122 = pop_loadset(convertStringsToChars(setNameS122));
        trialsS122 = setS122.trials;
    end

    if isfile(strcat(DIR.processed,setNameS121)) && isfile(strcat(DIR.processed,setNameS122))
        trialsS12 = trialsS121+trialsS122;
    end

    % S3
    if isfile(strcat(DIR.processed,setNameD3))
        setD3 = pop_loadset(convertStringsToChars(setNameD3));
        trialsD3 = setD3.trials;
    end
    if isfile(strcat(DIR.processed,setNameS31))
        setS31 = pop_loadset(convertStringsToChars(setNameS31));
        trialsS31 = setS31.trials;
    end
    if isfile(strcat(DIR.processed,setNameS32))
        setS32 = pop_loadset(convertStringsToChars(setNameS32));
        trialsS32 = setS32.trials;
    end

    if isfile(strcat(DIR.processed,setNameS31)) && isfile(strcat(DIR.processed,setNameS32))
        trialsS3 = trialsS31+trialsS32;
    end

    % S4
    if isfile(strcat(DIR.processed,setNameD4))
        setD4 = pop_loadset(convertStringsToChars(setNameD4));
        trialsD4 = setD4.trials;
    end
    if isfile(strcat(DIR.processed,setNameS41))
        setS41 = pop_loadset(convertStringsToChars(setNameS41));
        trialsS41 = setS41.trials;
    end
    if isfile(strcat(DIR.processed,setNameS42))
        setS42 = pop_loadset(convertStringsToChars(setNameS42));
        trialsS42 = setS42.trials;
    end

    if isfile(strcat(DIR.processed,setNameS41)) && isfile(strcat(DIR.processed,setNameS42))
        trialsS4 = trialsS41+trialsS42;
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD12 > 9 && trialsS12 > 9 && morethan3 == "no"
        setNameD12 = convertStringsToChars(setNameD12);
        setNameS121 = convertStringsToChars(setNameS121);
        setNameS122 = convertStringsToChars(setNameS122);

        GAargD12{counter}={counter};
        GAargD12{counter} = setNameD12;
        GAargS121{counter}={counter};
        GAargS121{counter} = setNameS121;
        GAargS122{counter}={counter};
        GAargS122{counter} = setNameS122;
        counter = counter+1;
    end

    if trialsD3 > 9 && trialsS3 > 9 && morethan3 == "no"
        setNameD3 = convertStringsToChars(setNameD3);
        setNameS31 = convertStringsToChars(setNameS31);
        setNameS32 = convertStringsToChars(setNameS32);

        GAargD3{counter}={counter};
        GAargD3{counter} = setNameD3;
        GAargS31{counter}={counter};
        GAargS31{counter} = setNameS31;
        GAargS32{counter}={counter};
        GAargS32{counter} = setNameS32;
        counter = counter+1;
    end

    if trialsD4 > 9 && trialsS4 > 9 && morethan3 == "no"
        setNameD4 = convertStringsToChars(setNameD4);
        setNameS41 = convertStringsToChars(setNameS41);
        setNameS42 = convertStringsToChars(setNameS42);

        GAargD4{counter}={counter};
        GAargD4{counter} = setNameD4;
        GAargS41{counter}={counter};
        GAargS41{counter} = setNameS41;
        GAargS42{counter}={counter};
        GAargS42{counter} = setNameS42;
        counter = counter+1;
    end


end

% Combine the specified cell arrays into all_D and all_S for each RQ
all_D_acq = cat(2, GAargD12, GAargD4);
all_S_acq = cat(2, GAargS121, GAargS41, GAargS122, GAargS42);

all_D_rec = cat(2, GAargD12, GAargD3, GAargD4);
all_S_rec = cat(2, GAargS121, GAargS31, GAargS41, GAargS122, GAargS32, GAargS42);


% remove empty cells (if any) from all_D and all_S:
all_D_acq = all_D_acq(~cellfun('isempty', all_D_acq));
all_S_acq = all_S_acq(~cellfun('isempty', all_S_acq));
all_D_rec = all_D_rec(~cellfun('isempty', all_D_rec));
all_S_rec = all_S_rec(~cellfun('isempty', all_S_rec));

% For all_D
all_D_sets_acq = cell(1, length(all_D_acq));
for i = 1:length(all_D_acq)
    if isfile(all_D_acq{i})
        all_D_sets_acq{i} = pop_loadset(all_D_acq{i}); % Encapsulate in cell to match expected input format
    else
        warning('File does not exist: %s', all_D_acq{i});
    end
end

all_D_sets_rec = cell(1, length(all_D_rec));
for i = 1:length(all_D_rec)
    if isfile(all_D_rec{i})
        all_D_sets_rec{i} = pop_loadset(all_D_rec{i}); % Encapsulate in cell to match expected input format
    else
        warning('File does not exist: %s', all_D_rec{i});
    end
end

% For all_S
all_S_sets_acq = cell(1, length(all_S_acq));
for i = 1:length(all_S_acq)
    if isfile(all_S_acq{i})
        all_S_sets_acq{i} = pop_loadset(all_S_acq{i}); % Encapsulate in cell to match expected input format
    else
        warning('File does not exist: %s', all_S_acq{i});
    end
end

all_S_sets_rec = cell(1, length(all_S_rec));
for i = 1:length(all_S_rec)
    if isfile(all_S_rec{i})
        all_S_sets_rec{i} = pop_loadset(all_S_rec{i}); % Encapsulate in cell to match expected input format
    else
        warning('File does not exist: %s', all_S_rec{i});
    end
end

% remove EEGlab path again to be able to run the plot code
rmpath(genpath(DIR.EEGLAB_PATH));

plot_erp({ ...
    all_D_sets_acq, ...
    all_S_sets_acq}, ...
    'Fz', ...
    'plotdiff', 0, ...
    'plotstd', 'fill', ...
    'permute', 1000, ...  
    'avgmode', 'auto', ...
    'labels', {'deviant', 'standard'} ...
    );

exportgraphics(gcf, strcat(DIR.plotsQA, ...
    ['ERP_ACQ_Fz_SD_all.jpeg']), ...
    'Resolution', 300);

plot_erp({ ...
    all_D_sets_rec, ...
    all_S_sets_rec}, ...
    'Fz', ...
    'plotdiff', 0, ...
    'plotstd', 'fill', ...
    'permute', 1000, ...  
    'avgmode', 'auto', ...
    'labels', {'deviant', 'standard'} ...
    );

exportgraphics(gcf, strcat(DIR.plotsQA, ...
    ['ERP_REC_Fz_SD_all.jpeg']), ...
    'Resolution', 300);

end

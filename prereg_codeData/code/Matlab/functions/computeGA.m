function computeGA(DIR, Subj_Fam, Subj_Unfam)

% CondNr = ["11" "21" "12" "22" "101" "102" "103" "104"  ...
%     "211" "212" "213" "214" "221" "222" "223" "224" "231" "232" ...
%     "233" "234" "241" "242" "243" "244"];

% load EEGlab 
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

DIR.processed = convertStringsToChars(DIR.processed);
DIR.grandaverage = convertStringsToChars(DIR.grandaverage);

%% Make GA for training speaker (1 or 2)
% For FAM------------------------------------------------------------------
Subj = Subj_Fam;
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD1 = strcat(Subj(ipp),"_processed_101.set");
    setNameD2 = strcat(Subj(ipp),"_processed_102.set");
    if isfile(strcat(DIR.processed,setNameD1))
    setNameD = setNameD1;
    elseif isfile(strcat(DIR.processed,setNameD2))
    setNameD = setNameD2;
    end

    setNameS11 = strcat(Subj(ipp),"_processed_221.set");
    setNameS12 = strcat(Subj(ipp),"_processed_222.set");
    if isfile(strcat(DIR.processed,setNameS11))
    setNameS1 = setNameS11;
    elseif isfile(strcat(DIR.processed,setNameS12))
    setNameS1 = setNameS12;
    else
        setNameS1 = 0;
    end

    setNameS21 = strcat(Subj(ipp),"_processed_231.set");
    setNameS22 = strcat(Subj(ipp),"_processed_232.set");
    if isfile(strcat(DIR.processed,setNameS21))
    setNameS2 = setNameS21;
    elseif isfile(strcat(DIR.processed,setNameS22))
    setNameS2 = setNameS22;
    else
        setNameS2 = 0;
    end

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;
    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_1012 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_2212 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_2312 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_2212, ga_2312);
pop_saveset(GA_merged, 'filename', 'ga_fam_S12_Stan.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_1012, 'filename', 'ga_fam_S12_Dev.set', ...
        'filepath', DIR.grandaverage);

% For UNFAM ---------------------------------------------------------------
Subj = Subj_Unfam;
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD1 = strcat(Subj(ipp),"_processed_101.set");
    setNameD2 = strcat(Subj(ipp),"_processed_102.set");
    if isfile(strcat(DIR.processed,setNameD1))
    setNameD = setNameD1;
    elseif isfile(strcat(DIR.processed,setNameD2))
    setNameD = setNameD2;
    end

    setNameS11 = strcat(Subj(ipp),"_processed_221.set");
    setNameS12 = strcat(Subj(ipp),"_processed_222.set");
    if isfile(strcat(DIR.processed,setNameS11))
    setNameS1 = setNameS11;
    elseif isfile(strcat(DIR.processed,setNameS12))
    setNameS1 = setNameS12;
    else
        setNameS1 = 0;
    end

    setNameS21 = strcat(Subj(ipp),"_processed_231.set");
    setNameS22 = strcat(Subj(ipp),"_processed_232.set");
    if isfile(strcat(DIR.processed,setNameS21))
    setNameS2 = setNameS21;
    elseif isfile(strcat(DIR.processed,setNameS22))
    setNameS2 = setNameS22;
    else
        setNameS2 = 0;
    end

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;

    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_1012 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_2212 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_2312 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_2212, ga_2312);
pop_saveset(GA_merged, 'filename', 'ga_unfam_S12_Stan.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_1012, 'filename', 'ga_unfam_S12_Dev.set', ...
        'filepath', DIR.grandaverage);


%% Make GA for Speaker 3
% For FAM -----------------------------------------------------------------
Subj = Subj_Fam;
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_processed_103.set");
    setNameS1 = strcat(Subj(ipp),"_processed_223.set");
    setNameS2 = strcat(Subj(ipp),"_processed_233.set");

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;
    end

    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_103 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_223 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_233 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_223, ga_233);
pop_saveset(GA_merged, 'filename', 'ga_fam_S3_Stan.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_103, 'filename', 'ga_fam_S3_Dev.set', ...
        'filepath', DIR.grandaverage);

% For UNFAM ---------------------------------------------------------------
Subj = Subj_Unfam;
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_processed_103.set");
    setNameS1 = strcat(Subj(ipp),"_processed_223.set");
    setNameS2 = strcat(Subj(ipp),"_processed_233.set");

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;

    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_103 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_223 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_233 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_223, ga_233);
pop_saveset(GA_merged, 'filename', 'ga_unfam_S3_Stan.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_103, 'filename', 'ga_unfam_S3_Dev.set', ...
        'filepath', DIR.grandaverage);

%% Make GA for Speaker 4
% For FAM -----------------------------------------------------------------
Subj = Subj_Fam;
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_processed_104.set");
    setNameS1 = strcat(Subj(ipp),"_processed_224.set");
    setNameS2 = strcat(Subj(ipp),"_processed_234.set");

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;

    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_104 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_224 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_234 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_224, ga_234);

pop_saveset(GA_merged, 'filename', 'ga_fam_S4_Stan.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_104, 'filename', 'ga_fam_S4_Dev.set', ...
        'filepath', DIR.grandaverage);

% For UNFAM ---------------------------------------------------------------
Subj = Subj_Unfam;
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_processed_104.set");
    setNameS1 = strcat(Subj(ipp),"_processed_224.set");
    setNameS2 = strcat(Subj(ipp),"_processed_234.set");

    % set the trial numbers, but only if the file is there
    trialsD = 0;
    trialsS = 0;

    if isfile(strcat(DIR.processed,setNameD))
        setD = pop_loadset(convertStringsToChars(setNameD));
        trialsD = setD.trials;
    end
    if isfile(strcat(DIR.processed,setNameS1))
        setS1 = pop_loadset(convertStringsToChars(setNameS1));
        trialsS1 = setS1.trials;

    end
    if isfile(strcat(DIR.processed,setNameS2))
        setS2 = pop_loadset(convertStringsToChars(setNameS2));
        trialsS2 = setS2.trials;
    end

    if isfile(strcat(DIR.processed,setNameS1)) && isfile(strcat(DIR.processed,setNameS2))
        trialsS = trialsS1+trialsS2;
    end

    % read out whether more than 3 channels from ROI were kicked out
    T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
    morethan3 = T{1,6};

    if trialsD > 9 && trialsS > 9 && morethan3 == "no"
        setNameD = convertStringsToChars(setNameD);
        setNameS1 = convertStringsToChars(setNameS1);
        setNameS2 = convertStringsToChars(setNameS2);

        GAargD{counter}={counter};
        GAargD{counter} = setNameD;
        GAargS1{counter}={counter};
        GAargS1{counter} = setNameS1;
        GAargS2{counter}={counter};
        GAargS2{counter} = setNameS2;
        counter = counter+1;
    end
end

% Deviants
ga_104 = pop_grandaverage(GAargD, 'pathname', DIR.processed);
% S1
ga_224 = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
% S2
ga_234 = pop_grandaverage(GAargS2, 'pathname', DIR.processed);

GA_merged = pop_mergeset(ga_224, ga_234);

pop_saveset(GA_merged, 'filename', 'ga_unfam_S4_Stan.set', ...
        'filepath', DIR.grandaverage);
pop_saveset(ga_104, 'filename', 'ga_unfam_S4_Dev.set', ...
        'filepath', DIR.grandaverage);

end

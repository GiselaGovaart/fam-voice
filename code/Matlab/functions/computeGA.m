function computeGA(Subj, DIR)

% CondNr = ["11" "21" "12" "22" "101" "102" "103" "104"  ...
%     "211" "212" "213" "214" "221" "222" "223" "224" "231" "232" ...
%     "233" "234" "241" "242" "243" "244"];

% load EEGlab 
DIR.EEGLAB_PATH = '/data/p_02453/packages/eeglab2021.0';
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

DIR.processed = convertStringsToChars(DIR.processed);
DIR.grandaverage = convertStringsToChars(DIR.grandaverage);

%% Make GA for training speaker (1 or 2)
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
    end

    setNameS21 = strcat(Subj(ipp),"_processed_231.set");
    setNameS22 = strcat(Subj(ipp),"_processed_232.set");
    if isfile(strcat(DIR.processed,setNameS21))
    setNameS2 = setNameS21;
    elseif isfile(strcat(DIR.processed,setNameS22))
    setNameS2 = setNameS22;
    end

    setD = pop_loadset(convertStringsToChars(setNameD));
    setS1 = pop_loadset(convertStringsToChars(setNameS1));
    setS2 = pop_loadset(convertStringsToChars(setNameS2));
    trialsD = setD.trials;
    trialsS1 = setS1.trials;
    trialsS2 = setS2.trials;
    trialsS = trialsS1+trialsS2;

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
EEG = pop_grandaverage(GAargD, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_101-102');
EEG = pop_saveset(EEG, 'filename', 'ga_101-102.set', ...
    'filepath', DIR.grandaverage);
% S1
EEG = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_221-222');
EEG = pop_saveset(EEG, 'filename', 'ga_221-222.set', ...
    'filepath', DIR.grandaverage);
% S2
EEG = pop_grandaverage(GAargS2, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_231-232');
EEG = pop_saveset(EEG, 'filename', 'ga_231-232.set', ...
    'filepath', DIR.grandaverage);

cd(DIR.grandaverage);
ga_1012 = pop_loadset('ga_101-102.set');
ga_2212 = pop_loadset('ga_221-222.set');
ga_2312 = pop_loadset('ga_231-232.set');

GA_merged = pop_mergeset(ga_2212, ga_2312);
EEG = pop_saveset(GA_merged, 'filename', 'ga_S12_Stan.set', ...
        'filepath', DIR.grandaverage);
EEG = pop_saveset(ga_1012, 'filename', 'ga_S12_Dev.set', ...
        'filepath', DIR.grandaverage);


%% Make GA for Speaker 3
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_processed_103.set");
    setNameS1 = strcat(Subj(ipp),"_processed_223.set");
    setNameS2 = strcat(Subj(ipp),"_processed_233.set");
    setD = pop_loadset(convertStringsToChars(setNameD));
    setS1 = pop_loadset(convertStringsToChars(setNameS1));
    setS2 = pop_loadset(convertStringsToChars(setNameS2));
    trialsD = setD.trials;
    trialsS1 = setS1.trials;
    trialsS2 = setS2.trials;
    trialsS = trialsS1+trialsS2;

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
EEG = pop_grandaverage(GAargD, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_103');
EEG = pop_saveset(EEG, 'filename', 'ga_103.set', ...
    'filepath', DIR.grandaverage);
% S1
EEG = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_223');
EEG = pop_saveset(EEG, 'filename', 'ga_223.set', ...
    'filepath', DIR.grandaverage);
% S2
EEG = pop_grandaverage(GAargS2, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_233');
EEG = pop_saveset(EEG, 'filename', 'ga_233.set', ...
    'filepath', DIR.grandaverage);

cd(DIR.grandaverage);
ga_103 = pop_loadset('ga_103.set');
ga_223 = pop_loadset('ga_223.set');
ga_233 = pop_loadset('ga_233.set');

GA_merged = pop_mergeset(ga_223, ga_233);
EEG = pop_saveset(GA_merged, 'filename', 'ga_S3_Stan.set', ...
        'filepath', DIR.grandaverage);
EEG = pop_saveset(ga_103, 'filename', 'ga_S3_Dev.set', ...
        'filepath', DIR.grandaverage);



%% Make GA for Speaker 4
cd(DIR.processed)
counter = 1;
GAargD = cell(counter);
GAargS1 = cell(counter);
GAargS2 = cell(counter);

for ipp = 1:length(Subj)
    setNameD = strcat(Subj(ipp),"_processed_104.set");
    setNameS1 = strcat(Subj(ipp),"_processed_224.set");
    setNameS2 = strcat(Subj(ipp),"_processed_234.set");
    setD = pop_loadset(convertStringsToChars(setNameD));
    setS1 = pop_loadset(convertStringsToChars(setNameS1));
    setS2 = pop_loadset(convertStringsToChars(setNameS2));
    trialsD = setD.trials;
    trialsS1 = setS1.trials;
    trialsS2 = setS2.trials;
    trialsS = trialsS1+trialsS2;

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
EEG = pop_grandaverage(GAargD, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_104');
EEG = pop_saveset(EEG, 'filename', 'ga_104.set', ...
    'filepath', DIR.grandaverage);
% S1
EEG = pop_grandaverage(GAargS1, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_224');
EEG = pop_saveset(EEG, 'filename', 'ga_224.set', ...
    'filepath', DIR.grandaverage);
% S2
EEG = pop_grandaverage(GAargS2, 'pathname', DIR.processed);
EEG = pop_editset(EEG,'setname', 'GA_234');
EEG = pop_saveset(EEG, 'filename', 'ga_234.set', ...
    'filepath', DIR.grandaverage);

cd(DIR.grandaverage);
ga_104 = pop_loadset('ga_104.set');
ga_224 = pop_loadset('ga_224.set');
ga_234 = pop_loadset('ga_234.set');

GA_merged = pop_mergeset(ga_224, ga_234);

EEG = pop_saveset(GA_merged, 'filename', 'ga_S4_Stan.set', ...
        'filepath', DIR.grandaverage);
EEG = pop_saveset(ga_104, 'filename', 'ga_S4_Dev.set', ...
        'filepath', DIR.grandaverage);






% %Make GA
% for iCond = 1:length(CondNr) 
%     counter = 1;
%     GAarg = cell(counter);
%     
%     for ipp = 1:length(Subj)
%         setName = strcat(Subj(ipp),"_processed_",CondNr(iCond),".set");
%         if isfile(strcat(DIR.processed,setName))
%             set = pop_loadset(convertStringsToChars(setName));
%             trials = set.trials;
%            if trials > 9
%                setName = convertStringsToChars(setName);
%                GAarg{counter}={counter};
%                GAarg{counter} = setName;
%                counter = counter+1;
%            end
%         end
%     end
%     EEG = pop_grandaverage(GAarg, 'pathname', DIR.processed);
%     EEG = pop_editset(EEG,'setname', strcat('GA_',CondNr));
%     fname = convertStringsToChars(strcat('ga_',CondNr(iCond), '.set'));
%     EEG = pop_saveset(EEG, 'filename', fname, ...
%         'filepath', DIR.grandaverage);
% 
% end
% 
% cd(DIR.grandaverage);
% ga_101 = pop_loadset('ga_101.set');
% ga_102 = pop_loadset('ga_102.set');
% ga_231 = pop_loadset('ga_231.set');
% ga_232 = pop_loadset('ga_232.set');
% 
% GA_merged = pop_mergeset(ga_101, ga_102);
% EEG = pop_saveset(GA_merged, 'filename', 'ga_101-102.set', ...
%         'filepath', DIR.grandaverage);
% GA_merged = pop_mergeset(ga_231, ga_232);
% EEG = pop_saveset(GA_merged, 'filename', 'ga_231-232.set', ...
%         'filepath', DIR.grandaverage);


end

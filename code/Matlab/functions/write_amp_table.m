function write_amp_table(Subj, DIR, blvalue, twstartacq, twendacq, ...
    twstartrec, twendrec,twstartrecfam, twendrecfam,roi)

%% Set electrode nrs
% ROI
Fz = 14;
F3 = 6;
F4 = 7;
FC5 = 11;
FC6 = 12;
Cz = 27;
C3 = 1;
C4 = 2;

setlist = dir(strcat(DIR.processed,"*_processed_*"));

CondNr = ["101" "102" "103" "104"  ... % dev
    "221" "222" "223" "224" ... % pre-preceeding stand
    "231" "232" "233" "234" ]; % preceeding stand

T_trials = readtable(strcat(DIR.qualityAssessment, 'trial_overview.txt'), ...
    'ReadVariableNames', true, 'VariableNamingRule', 'preserve');
% Convert the first column to strings and Set the row names from the first column
firstColumnStrings = string(T_trials{:, 1});  % Convert to string array 
T_trials.Properties.RowNames = firstColumnStrings;
T_trials(:, 1) = [];  % Remove the first column 



%% Amplitude table ACQ
if roi == "normal"
    % Make output matrix
    outMat = strings(length(Subj)+1, length(CondNr)+1);
    outMat(1,2:length(CondNr)+1) = CondNr;
    outMat(2:length(Subj)+1,1) = Subj;

    % load EEGlab
    rmpath(genpath(DIR.EEGLAB_PATH));
    cd(DIR.EEGLAB_PATH);
    eeglab; close;

    for ipp = 1:length(Subj)
        for iCond = 1:length(CondNr)
            % Get the current condition number
            currentCond = CondNr{iCond};  % Use curly braces to get the string

            % Extract the last digit of the current condition
            lastDigit = str2double(currentCond(end));
            % Construct the condition strings (these names are a bit confusing,
            % but they actually do change
            cond101 = strcat('10', num2str(lastDigit));
            cond221 = strcat('22', num2str(lastDigit));
            cond231 = strcat('23', num2str(lastDigit));

            % Get the number of trials for the current subject and conditions
            trialsCurrentCond = T_trials{currentCond, convertStringsToChars(Subj(ipp))};
            trialsCond101 = T_trials{cond101, convertStringsToChars(Subj(ipp))};
            trialsCond221 = T_trials{cond221, convertStringsToChars(Subj(ipp))};
            trialsCond231 = T_trials{cond231, convertStringsToChars(Subj(ipp))};

            % Check the conditions
            if trialsCond101 > 9 && (trialsCond221 + trialsCond231) > 9
                setName = strcat(Subj(ipp),"_processed_",CondNr(iCond),".set");
                T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
                morethan3 = T{1,6};
                if isfile(strcat(DIR.processed,setName))&& morethan3 == "no"
                    set = pop_loadset(convertStringsToChars(setName));
                    erp = mean( set.data, 3 );
                    baseline = blvalue/2; % divide by 2 because of sr of 500, which means that every sample contains 2 ms.
                    window = [twstartacq/2  twendacq/2];
                    mean_amplitude_all = mean(erp(:, (window(1)-baseline):(window(2)-baseline)), 2);  % substract baseline to get correct latency
                    % compute amp per electrode
                    mean_amplitude_fz = mean_amplitude_all(Fz,1);
                    mean_amplitude_f3 = mean_amplitude_all(F3,1);
                    mean_amplitude_f4 = mean_amplitude_all(F4,1);
                    mean_amplitude_fc5 = mean_amplitude_all(FC5,1);
                    mean_amplitude_fc6 = mean_amplitude_all(FC6,1);
                    mean_amplitude_cz = mean_amplitude_all(Cz,1);
                    mean_amplitude_c3 = mean_amplitude_all(C3,1);
                    mean_amplitude_c4 = mean_amplitude_all(C4,1);

                    % take mean of all amplitudes in ROI
                    mean_amplitude_roi = (mean_amplitude_fz + mean_amplitude_f3 + ...
                        mean_amplitude_f4 + mean_amplitude_fc5 + mean_amplitude_fc6 + ...
                        mean_amplitude_cz + mean_amplitude_c3 + mean_amplitude_c4)/8;

                    outMat(ipp+1,iCond+1) =  mean_amplitude_roi;
                end
            end
        end
    end

    outMatT = outMat';

    rmpath(genpath(DIR.EEGLAB_PATH));

    colNames(length(Subj)+1) = ["placeholder"];
    colNames(1) = "Cond";
    colNames(2:length(Subj)+1) = Subj;

    C = cellstr(outMatT);
    T = cell2table(C, 'VariableNames',cellstr(colNames));
    T(1,:) = []; % this could be coded prettier, but it works
    writetable(T,strcat(DIR.qualityAssessment, strcat('amplitudes_acq.txt')),'Delimiter','\t');
end

%% Amplitude table REC
if roi == "normal"
    % Make output matrix
    outMat = strings(length(Subj)+1, length(CondNr)+1);
    outMat(1,2:length(CondNr)+1) = CondNr;
    outMat(2:length(Subj)+1,1) = Subj;

    % load EEGlab
    rmpath(genpath(DIR.EEGLAB_PATH));
    cd(DIR.EEGLAB_PATH);
    eeglab; close;

    for ipp = 1:length(Subj)
        for iCond = 1:length(CondNr)
            % Get the current condition number
            currentCond = CondNr{iCond};  % Use curly braces to get the string

            % Extract the last digit of the current condition
            lastDigit = str2double(currentCond(end));
            % Construct the condition strings (these names are a bit confusing,
            % but they actually do change
            cond101 = strcat('10', num2str(lastDigit));
            cond221 = strcat('22', num2str(lastDigit));
            cond231 = strcat('23', num2str(lastDigit));

            % Get the number of trials for the current subject and conditions
            trialsCurrentCond = T_trials{currentCond, convertStringsToChars(Subj(ipp))};
            trialsCond101 = T_trials{cond101, convertStringsToChars(Subj(ipp))};
            trialsCond221 = T_trials{cond221, convertStringsToChars(Subj(ipp))};
            trialsCond231 = T_trials{cond231, convertStringsToChars(Subj(ipp))};

            % Check the conditions
            if trialsCond101 > 9 && (trialsCond221 + trialsCond231) > 9
                setName = strcat(Subj(ipp),"_processed_",CondNr(iCond),".set");
                T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
                morethan3 = T{1,6};
                if isfile(strcat(DIR.processed,setName))&& morethan3 == "no"
                    set = pop_loadset(convertStringsToChars(setName));
                    erp = mean( set.data, 3 );
                    baseline = blvalue/2; % divide by 2 because of sr of 500, which means that every sample contains 2 ms.
                    window = [twstartrec/2  twendrec/2];
                    mean_amplitude_all = mean(erp(:, (window(1)-baseline):(window(2)-baseline)), 2);  % substract baseline to get correct latency
                    % compute amp per electrode
                    mean_amplitude_fz = mean_amplitude_all(Fz,1);
                    mean_amplitude_f3 = mean_amplitude_all(F3,1);
                    mean_amplitude_f4 = mean_amplitude_all(F4,1);
                    mean_amplitude_fc5 = mean_amplitude_all(FC5,1);
                    mean_amplitude_fc6 = mean_amplitude_all(FC6,1);
                    mean_amplitude_cz = mean_amplitude_all(Cz,1);
                    mean_amplitude_c3 = mean_amplitude_all(C3,1);
                    mean_amplitude_c4 = mean_amplitude_all(C4,1);

                    % take mean of all amplitudes in ROI

                    mean_amplitude_roi = (mean_amplitude_fz + mean_amplitude_f3 + ...
                        mean_amplitude_f4 + mean_amplitude_fc5 + mean_amplitude_fc6 + ...
                        mean_amplitude_cz + mean_amplitude_c3 + mean_amplitude_c4)/8;

                    outMat(ipp+1,iCond+1) =  mean_amplitude_roi;
                end
            end
        end
    end

    outMatT = outMat';

    rmpath(genpath(DIR.EEGLAB_PATH));

    colNames(length(Subj)+1) = ["placeholder"];
    colNames(1) = "Cond";
    colNames(2:length(Subj)+1) = Subj;

    C = cellstr(outMatT);
    T = cell2table(C, 'VariableNames',cellstr(colNames));
    T(1,:) = []; % this could be coded prettier, but it works
    writetable(T,strcat(DIR.qualityAssessment, strcat('amplitudes_rec.txt')),'Delimiter','\t');
end

%% Amplitude table REC FAM
% Make output matrix
outMat = strings(length(Subj)+1, length(CondNr)+1);
outMat(1,2:length(CondNr)+1) = CondNr;
outMat(2:length(Subj)+1,1) = Subj;

% load EEGlab 
rmpath(genpath(DIR.EEGLAB_PATH)); 
cd(DIR.EEGLAB_PATH);
eeglab; close;

for ipp = 1:length(Subj)
    for iCond = 1:length(CondNr)
        % Get the current condition number
        currentCond = CondNr{iCond};  % Use curly braces to get the string

        % Extract the last digit of the current condition
        lastDigit = str2double(currentCond(end));
        % Construct the condition strings (these names are a bit confusing,
        % but they actually do change 
        cond101 = strcat('10', num2str(lastDigit));
        cond221 = strcat('22', num2str(lastDigit));
        cond231 = strcat('23', num2str(lastDigit));

        % Get the number of trials for the current subject and conditions
        trialsCurrentCond = T_trials{currentCond, convertStringsToChars(Subj(ipp))};
        trialsCond101 = T_trials{cond101, convertStringsToChars(Subj(ipp))};
        trialsCond221 = T_trials{cond221, convertStringsToChars(Subj(ipp))};
        trialsCond231 = T_trials{cond231, convertStringsToChars(Subj(ipp))};

        % Check the conditions
        if trialsCond101 > 9 && (trialsCond221 + trialsCond231) > 9
            setName = strcat(Subj(ipp),"_processed_",CondNr(iCond),".set");
            T = readtable(strcat(DIR.qualityAssessment, 'InfoChannels_', Subj(ipp)));
            morethan3 = T{1,6};
            if isfile(strcat(DIR.processed,setName))&& morethan3 == "no"
                set = pop_loadset(convertStringsToChars(setName));
                erp = mean( set.data, 3 );
                baseline = blvalue/2; % divide by 2 because of sr of 500, which means that every sample contains 2 ms.
                window = [twstartrecfam/2  twendrecfam/2];
                mean_amplitude_all = mean(erp(:, (window(1)-baseline):(window(2)-baseline)), 2);  % substract baseline to get correct latency
                % compute amp per electrode
                mean_amplitude_fz = mean_amplitude_all(Fz,1);
                mean_amplitude_f3 = mean_amplitude_all(F3,1);
                mean_amplitude_f4 = mean_amplitude_all(F4,1);
                mean_amplitude_fc5 = mean_amplitude_all(FC5,1);
                mean_amplitude_fc6 = mean_amplitude_all(FC6,1);
                mean_amplitude_cz = mean_amplitude_all(Cz,1);
                mean_amplitude_c3 = mean_amplitude_all(C3,1);
                mean_amplitude_c4 = mean_amplitude_all(C4,1);

                % take mean of all amplitudes in ROI
                if roi == "normal"
                    mean_amplitude_roi = (mean_amplitude_fz + mean_amplitude_f3 + ...
                        mean_amplitude_f4 + mean_amplitude_fc5 + mean_amplitude_fc6 + ...
                        mean_amplitude_cz + mean_amplitude_c3 + mean_amplitude_c4)/8;
                elseif roi == "frontal"
                    mean_amplitude_roi = (mean_amplitude_fz + mean_amplitude_f3 + ...
                        mean_amplitude_f4 + mean_amplitude_fc5 + mean_amplitude_fc6)/5;
                end

                outMat(ipp+1,iCond+1) =  mean_amplitude_roi;
            end
        end
    end
end

outMatT = outMat';

rmpath(genpath(DIR.EEGLAB_PATH));

colNames(length(Subj)+1) = ["placeholder"];
colNames(1) = "Cond";
colNames(2:length(Subj)+1) = Subj;

C = cellstr(outMatT);
T = cell2table(C, 'VariableNames',cellstr(colNames));
T(1,:) = []; % this could be coded prettier, but it works
writetable(T,strcat(DIR.qualityAssessment, strcat('amplitudes_recfam_',roi,'.txt')),'Delimiter','\t');

end

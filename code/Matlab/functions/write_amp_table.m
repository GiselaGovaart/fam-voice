function write_amp_table(Subj, DIR, blvalue, twstartacq, twendacq, twstartrec, twendrec)

%% Set electrode nrs
% Definelty part of final ROI
Fz = 15;
F3 = 7;
F4 = 8;
FC5 = 12;
FC6 = 13;

% Possibly part of final ROI (in that case: ADD): 
Cz = 27;
C3 = 1;
C4 = 2;
F7 = 9;
F8 = 10;


setlist = dir(strcat(DIR.processed,"*_processed_*"));

CondNr = ["101" "102" "103" "104"  ... % dev
    "231" "232" "233" "234" ]; % preceeding stand

%% Amplitude table ACQ

% Make output matrix
outMat = strings(length(Subj)+1, length(CondNr)+1);
outMat(1,2:length(CondNr)+1) = CondNr;
outMat(2:length(Subj)+1,1) = Subj;

addpath(genpath(DIR.EEGLAB_PATH));

for ipp = 1:length(Subj)
    for iCond = 1:length(CondNr)
        setName = strcat(Subj(ipp),"_processed_",CondNr(iCond),".set");
        if isfile(strcat(DIR.processed,setName))
            set = pop_loadset(convertStringsToChars(setName));
            erp = mean( set.data, 3 );
            baseline = blvalue/2; % divide by 2 because of sr of 500, which means that every sample contains 2 ms.
            window = [twstartacq/2  twendacq/2]; 
            mean_amplitude_all = mean(erp(:, (window(1)-baseline):(window(2)-baseline)), 2);  % substract baseline to get correct latency
            mean_amplitude_fz = mean_amplitude_all(Fz,1);
            mean_amplitude_f3 = mean_amplitude_all(F3,1);
            mean_amplitude_f4 = mean_amplitude_all(F4,1);
            mean_amplitude_fc5 = mean_amplitude_all(FC5,1);
            mean_amplitude_fc6 = mean_amplitude_all(FC6,1);
            mean_amplitude_roi = (mean_amplitude_fz + mean_amplitude_f3 + ...
                mean_amplitude_f4 + mean_amplitude_fc5 + mean_amplitude_fc6)/5;
            outMat(ipp+1,iCond+1) =  mean_amplitude_roi;
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
writetable(T,strcat(DIR.qualityAssessment, 'amplitudes_acq.txt'),'Delimiter','\t');

%% Amplitude table REC
% Make output matrix
outMat = strings(length(Subj)+1, length(CondNr)+1);
outMat(1,2:length(CondNr)+1) = CondNr;
outMat(2:length(Subj)+1,1) = Subj;

addpath(genpath(DIR.EEGLAB_PATH));

for ipp = 1:length(Subj)
    for iCond = 1:length(CondNr)
        setName = strcat(Subj(ipp),"_processed_",CondNr(iCond),".set");
        if isfile(strcat(DIR.processed,setName))
            set = pop_loadset(convertStringsToChars(setName));
            erp = mean( set.data, 3 );
            baseline = blvalue/2; % divide by 2 because of sr of 500, which means that every sample contains 2 ms.
            window = [twstartrec/2  twendrec/2]; 
            mean_amplitude_all = mean(erp(:, (window(1)-baseline):(window(2)-baseline)), 2);  % substract baseline to get correct latency
            mean_amplitude_fz = mean_amplitude_all(Fz,1);
            mean_amplitude_f3 = mean_amplitude_all(F3,1);
            mean_amplitude_f4 = mean_amplitude_all(F4,1);
            mean_amplitude_fc5 = mean_amplitude_all(FC5,1);
            mean_amplitude_fc6 = mean_amplitude_all(FC6,1);
            mean_amplitude_roi = (mean_amplitude_fz + mean_amplitude_f3 + ...
                mean_amplitude_f4 + mean_amplitude_fc5 + mean_amplitude_fc6)/5;
            outMat(ipp+1,iCond+1) =  mean_amplitude_roi;
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
writetable(T,strcat(DIR.qualityAssessment, 'amplitudes_rec.txt'),'Delimiter','\t');


end

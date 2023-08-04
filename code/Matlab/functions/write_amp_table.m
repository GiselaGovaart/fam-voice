function write_amp_table(Subj, DIR, blvalue)


%% Amplitude table
% This is just a draft table for Antonio to play around with,
% with single subject average per condition,
% time window: 216-466 after stimulus onset
% electrode: Fz

setlist = dir(strcat(DIR.processed,"*_processed_*"));

CondNr = ["101" "102" "103" "104"  ... % dev
    "231" "232" "233" "234" ]; % preceeding stand

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
            window = [108  233]; % tw: 151-401 after change. change starts after 65 ms, 216-466 --> divide by 2:
            mean_amplitude_all = mean(erp(:, (window(1)-baseline):(window(2)-baseline)), 2);  % substract baseline to get correct latency
            mean_amplitude_fz = mean_amplitude_all(4,1);
            outMat(ipp+1,iCond+1) =  mean_amplitude_fz;
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
writetable(T,strcat(DIR.qualityAssessment, 'amplitudes.txt'),'Delimiter','\t');

end

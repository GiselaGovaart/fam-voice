function write_output_tables(Subj, DIR)
% write output tables


%% Trial overview
% subjects = ["01","02"];
setlist = dir(strcat(DIR.processed,"*_processed_*"));

CondNr = ["11" "21" "12" "22" "101" "102" "103" "104"  ...
    "211" "212" "213" "214" "221" "222" "223" "224" "231" "232" ...
    "233" "234" "241" "242" "243" "244"];

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
            trials = set.trials;
            outMat(ipp+1,iCond+1) = trials;
        end
    end
end

% Gisela's code that did not work:
% for i = 1:length(setlist)
%     setName = setlist(i).name;
%     namesplit = split(setName,"_");
%     name = namesplit(1,1);
%     cond = erase(namesplit(3,1), ".set");
%     set = pop_loadset(setName);
%     trials = set.trials;
%     for j = 1:length(Subj)
%         if Subj(j) == name
%             for h = 1:length(CondNr)
%                if CondNr(h) == cond
%                    outMat(j+1,h+1) = trials;
%                end
%             end
%         end
%     end
% end

outMatT = outMat';

rmpath(genpath(DIR.EEGLAB_PATH)); 


colNames(length(Subj)+1) = ["placeholder"];
colNames(1) = "Cond";
colNames(2:16) = Subj;

C = cellstr(outMatT);
T = cell2table(C, 'VariableNames',cellstr(colNames));
T(1,:) = []; % this could be coded prettier, but it works
writetable(T,strcat(DIR.qualityAssessment, 'trial_overview.txt'),'Delimiter','\t');


%% Channel overview

pps = dir(strcat(DIR.intermediateProcessing,"channelInfo_*"));
load(pps(1).name,"original");

% Make output matrix
outMat = strings(length(original)+1,length(pps)+1);
% Add original (27) electrode labels
for electrode = 1:length(original)
    elecName = original(electrode).labels;
    outMat(electrode + 1,1) = elecName;
end

colNames = strings(1,length(pps)+1);
colNames(1) = "chName";
outMat(1,1) = "chName";
for ipp = 1:length(pps)
    ppName = pps(ipp).name;
    load(ppName, "selected", "original", "crucialRemovedNames");
    namesplit = split(ppName,"_");
    colNames(ipp+1) = strrep(namesplit{2},".mat",""); 
    outMat(1,ipp+1) = ppName;

    for electrode = 1:length(original)
        elecNameOrig = convertCharsToStrings(original(electrode).labels);
        % standard, add for all electrodes a zero
        outMat(electrode + 1,ipp+1) = "0";
        % add a 1 when the electrode was selected
        for selElectrode = 1:length(selected)
            elecName = convertCharsToStrings(selected(selElectrode).labels);
            if elecNameOrig == elecName
                outMat(electrode + 1,ipp+1) = "1";
            end
        end
        % add a c when the electrode was crucial (so got re-added)
        for crucElectrode = 1:length(crucialRemovedNames)
            elecName = convertCharsToStrings(crucialRemovedNames(1,crucElectrode));
            if elecNameOrig == elecName
                outMat(electrode + 1,ipp+1) = "c";
            end
        end
    end
end

C = cellstr(outMat);
T = cell2table(C, 'VariableNames',cellstr(colNames));
T(1,:) = []; % this could be coded prettier, but it works
writetable(T,strcat(DIR.qualityAssessment,'channel_overview.txt'),'Delimiter','\t');


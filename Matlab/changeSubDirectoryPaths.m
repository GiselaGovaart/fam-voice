function DIR = changeSubDirectoryPaths(DIR,hpStr,threshold,wavThreshold,version)

DIR.overallPath = strcat(DIR.SET_PATH,"01-output/hp",hpStr,"_Amp",int2str(threshold),...
        "_wavThreshold", wavThreshold, "_version",int2str(version));
% these single quatiations marks instead of double make sure that there is
% no error for HAPPE_FamVoice_pilot.m:
% pop_saveset(EEG, 'filename', convertStringsToChars(strcat(pp,'_filtered_lnreduced.set')), ...
%     'filepath', convertStringsToChars(DIR.intermediateProcessing));

DIR.intermediateProcessing =  strcat(DIR.overallPath,"/01-intermediate_processing/");
DIR.waveletCleaned =  strcat(DIR.overallPath,"/02-wavelet_cleaned_continuous/");
DIR.ERPfiltered =  strcat(DIR.overallPath,"/03-ERP_filtered/");
DIR.segmenting =  strcat(DIR.overallPath,"/04-segmenting/");
DIR.processed =  strcat(DIR.overallPath,"/05-processed/");
DIR.qualityAssessment =  strcat(DIR.overallPath,"/06-quality_assessment_outputs/");

addpath(genpath(DIR.overallPath));

end
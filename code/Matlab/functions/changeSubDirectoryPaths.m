function DIR = changeSubDirectoryPaths(DIR,hpStr,window, betaStr, threshold, ...
    wavThreshold, version, baseline, blvalue, muscIL, detrend)

DIR.overallPath = strcat(DIR.SET_PATH,"01-output/hp-",hpStr, "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
        "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
        "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detrend);

DIR.intermediateProcessing =  strcat(DIR.overallPath,"/01-intermediate_processing/");
DIR.waveletCleaned =  strcat(DIR.overallPath,"/02-wavelet_cleaned_continuous/");
DIR.ERPfiltered =  strcat(DIR.overallPath,"/03-ERP_filtered/");
DIR.segmenting =  strcat(DIR.overallPath,"/04-segmenting/");
DIR.processed =  strcat(DIR.overallPath,"/05-processed/");
DIR.qualityAssessment =  strcat(DIR.overallPath,"/06-quality_assessment_outputs/");
DIR.grandaverage = strcat(DIR.overallPath,"/07-grandaverage/");

addpath(genpath(DIR.overallPath));

end
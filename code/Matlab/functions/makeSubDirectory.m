function DIR = makeSubDirectory(DIR,hptransStr, hpcutoffStr,window, betaStr, threshold, ...
    wavThreshold, version, baseline, blvalue, muscIL, detr)

DIR.overallPath = strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
        "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
        "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
        "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr);

mkdir(DIR.overallPath);
mkdir(strcat(DIR.overallPath,"/01-intermediate_processing/"));
DIR.intermediateProcessing =  strcat(DIR.overallPath,"/01-intermediate_processing/");
mkdir(strcat(DIR.overallPath,"/02-wavelet_cleaned_continuous/"));
DIR.waveletCleaned =  strcat(DIR.overallPath,"/02-wavelet_cleaned_continuous/");
mkdir(strcat(DIR.overallPath,"/03-ERP_filtered/"));
DIR.ERPfiltered =  strcat(DIR.overallPath,"/03-ERP_filtered/");
mkdir(strcat(DIR.overallPath,"/04-segmenting/"));
DIR.segmenting =  strcat(DIR.overallPath,"/04-segmenting/");
mkdir(strcat(DIR.overallPath,"/05-processed/"));
DIR.processed =  strcat(DIR.overallPath,"/05-processed/");
mkdir(strcat(DIR.overallPath,"/06-quality_assessment_outputs/"));
DIR.qualityAssessment =  strcat(DIR.overallPath,"/06-quality_assessment_outputs/");
mkdir(strcat(DIR.overallPath,"/07-grandaverage/"));
DIR.grandaverage = strcat(DIR.overallPath,"/07-grandaverage/");
end
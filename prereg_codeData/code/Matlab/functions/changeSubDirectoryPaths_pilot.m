function DIR = changeSubDirectoryPaths_pilot(DIR, manualInfoFolder,filtervalue)


% function DIR = changeSubDirectoryPaths(DIR,hptransStr, hpcutoffStr,window, betaStr, threshold, ...
%     wavThreshold, version, baseline, blvalue, muscIL, detr)

% DIR.overallPath = strcat(DIR.SET_PATH,"01-output/hptrans-",hptransStr, "hpcutoff-", hpcutoffStr, ...
%         "_window-", window, "_beta",betaStr,"_amp-",int2str(threshold),...
%         "_wavThreshold-", wavThreshold, "_version-",int2str(version),"_baseline-", baseline, ...
%         "_blvalue-", int2str(blvalue), "_muscIL-", muscIL,"_detrend-", detr);


DIR.overallPath = strcat(DIR.RAWEEG_PATH,"01-output/", manualInfoFolder,"_filter-", filtervalue);

DIR.intermediateProcessing =  strcat(DIR.overallPath,"/01-intermediate_processing/");
DIR.waveletCleaned =  strcat(DIR.overallPath,"/02-wavelet_cleaned_continuous/");
DIR.ERPfiltered =  strcat(DIR.overallPath,"/03-ERP_filtered/");
DIR.segmenting =  strcat(DIR.overallPath,"/04-segmenting/");
DIR.processed =  strcat(DIR.overallPath,"/05-processed/");
DIR.qualityAssessment =  strcat(DIR.overallPath,"/06-quality_assessment_outputs/");
DIR.grandaverage = strcat(DIR.overallPath,"/07-grandaverage/");
DIR.plots = strcat(DIR.overallPath,"/08-plots");
%subfolders plot
DIR.plotsQA = strcat(DIR.plots,"/01-quality_assessment/");
DIR.plotsCL = strcat(DIR.plots,"/02-collapsed_localizer/");
DIR.plotsERPraw = strcat(DIR.plots,"/03-ERPs_raw/");
DIR.plotsERPindiv = strcat(DIR.plots,"/04-ERPs_individual/");
DIR.plotsERPproc = strcat(DIR.plots,"/05-ERPs_processed/");

addpath(genpath(DIR.overallPath));

end
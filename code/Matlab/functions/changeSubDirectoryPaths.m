function DIR = changeSubDirectoryPaths(DIR, manualInfoFolder)

DIR.overallPath = strcat(DIR.RAWEEG_PATH,"01-output/", manualInfoFolder);

DIR.intermediateProcessing =  strcat(DIR.overallPath,"/01-intermediate_processing/");
DIR.waveletCleaned =  strcat(DIR.overallPath,"/02-wavelet_cleaned_continuous/");
DIR.ERPfiltered =  strcat(DIR.overallPath,"/03-ERP_filtered/");
DIR.segmenting =  strcat(DIR.overallPath,"/04-segmenting/");
DIR.processed =  strcat(DIR.overallPath,"/05-processed/");
DIR.processed_woBLcorr =  strcat(DIR.overallPath,"/05-processed/withoutBLcorr/");
DIR.qualityAssessment =  strcat(DIR.overallPath,"/06-quality_assessment_outputs/");
DIR.grandaverage = strcat(DIR.overallPath,"/07-grandaverage/");
DIR.grandaverage_woBLcorr = strcat(DIR.overallPath,"/07-grandaverage/withoutBLcorr/");
DIR.plots = strcat(DIR.overallPath,"/08-plots");

%subfolders plot
DIR.plotsQA = strcat(DIR.plots,"/01-quality_assessment/");
DIR.plotsCL = strcat(DIR.plots,"/02-collapsed_localizer/");
DIR.plotsERPraw = strcat(DIR.plots,"/03-ERPs_raw/");
DIR.plotsERPindiv = strcat(DIR.plots,"/04-ERPs_individual/");
DIR.plotsERPproc = strcat(DIR.plots,"/05-ERPs_processed/");

addpath(genpath(DIR.overallPath));

end
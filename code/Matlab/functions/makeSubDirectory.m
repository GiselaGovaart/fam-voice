function DIR = makeSubDirectory(DIR, manualInfoFolder)

DIR.overallPath = strcat(DIR.RAWEEG_PATH,"01-output/", manualInfoFolder);

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
mkdir(strcat(DIR.overallPath,"/05-processed/withoutBLcorr/"));
DIR.processed_woBLcorr =  strcat(DIR.overallPath,"/05-processed/withoutBLcorr/");
mkdir(strcat(DIR.overallPath,"/05-processed/raw/"));
DIR.processed_raw =  strcat(DIR.overallPath,"/05-processed/raw/");
mkdir(strcat(DIR.overallPath,"/06-quality_assessment_outputs/"));
DIR.qualityAssessment =  strcat(DIR.overallPath,"/06-quality_assessment_outputs/");
mkdir(strcat(DIR.overallPath,"/07-grandaverage/"));
DIR.grandaverage = strcat(DIR.overallPath,"/07-grandaverage/");
mkdir(strcat(DIR.overallPath,"/07-grandaverage/withoutBLcorr/"));
DIR.grandaverage_woBLcorr = strcat(DIR.overallPath,"/07-grandaverage/withoutBLcorr/");
mkdir(strcat(DIR.overallPath,"/07-grandaverage/raw/"));
DIR.grandaverage_raw = strcat(DIR.overallPath,"/07-grandaverage/raw/");
mkdir(strcat(DIR.overallPath,"/08-plots/"));
DIR.plots = strcat(DIR.overallPath,"/08-plots");

%subfolders plot
mkdir(strcat(DIR.plots,"/01-quality_assessment/"));
DIR.plotsQA = strcat(DIR.plots,"/01-quality_assessment/");
mkdir(strcat(DIR.plots,"/02-collapsed_localizer/"));
DIR.plotsCL = strcat(DIR.plots,"/02-collapsed_localizer/");
mkdir(strcat(DIR.plots,"/03-ERPs_raw/"));
DIR.plotsERPraw = strcat(DIR.plots,"/03-ERPs_raw/");
mkdir(strcat(DIR.plots,"/04-ERPs_individual/"));
DIR.plotsERPindiv = strcat(DIR.plots,"/04-ERPs_individual/");
mkdir(strcat(DIR.plots,"/05-ERPs_processed/"));
DIR.plotsERPproc = strcat(DIR.plots,"/05-ERPs_processed/");
mkdir(strcat(DIR.plots,"/05-Plots_Manuscript/"));
DIR.plotsMS = strcat(DIR.plots,"/05-Plots_Manuscript/");
end
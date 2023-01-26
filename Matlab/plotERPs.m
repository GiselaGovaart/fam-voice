


% load EEGlab
eeglab; close;

%% Load datasets
% load the necessary datasets

%addpath(genpath(DIR.EEGLAB_PATH));
cd(DIR.processed);
EEG_01_221 = pop_loadset('01_processed_221.set');
EEG_01_231 = pop_loadset('01_processed_231.set');
EEG_01_101 = pop_loadset('01_processed_101.set');
EEG_01_stan1 = pop_mergeset(EEG_01_221,EEG_01_231);
% EEG_01_222 = pop_loadset('01_processed_222.set');
% EEG_01_232 = pop_loadset('01_processed_232.set');
% EEG_01_102 = pop_loadset('01_processed_102.set');
% EEG_01_stan2 = pop_mergeset(EEG_01_222,EEG_01_232);
EEG_01_223 = pop_loadset('01_processed_223.set');
EEG_01_233 = pop_loadset('01_processed_233.set');
EEG_01_103 = pop_loadset('01_processed_103.set');
EEG_01_stan3 = pop_mergeset(EEG_01_223,EEG_01_233);
EEG_01_224 = pop_loadset('01_processed_224.set');
EEG_01_234 = pop_loadset('01_processed_234.set');
EEG_01_104 = pop_loadset('01_processed_104.set');
EEG_01_stan4 = pop_mergeset(EEG_01_224,EEG_01_234);

EEG_02_221 = pop_loadset('02_processed_221.set');
EEG_02_231 = pop_loadset('02_processed_231.set');
EEG_02_101 = pop_loadset('02_processed_101.set');
EEG_02_stan1 = pop_mergeset(EEG_02_221,EEG_02_231);
% EEG_02_222 = pop_loadset('02_processed_222.set');
% EEG_02_232 = pop_loadset('02_processed_232.set');
% EEG_02_102 = pop_loadset('02_processed_102.set');
% EEG_02_stan2 = pop_mergeset(EEG_02_222,EEG_02_232);
EEG_02_223 = pop_loadset('02_processed_223.set');
EEG_02_233 = pop_loadset('02_processed_233.set');
EEG_02_103 = pop_loadset('02_processed_103.set');
EEG_02_stan3 = pop_mergeset(EEG_02_223,EEG_02_233);
EEG_02_224 = pop_loadset('02_processed_224.set');
EEG_02_234 = pop_loadset('02_processed_234.set');
EEG_02_104 = pop_loadset('02_processed_104.set');
EEG_02_stan4 = pop_mergeset(EEG_02_224,EEG_02_234);


% EEG_03_221 = pop_loadset('03_processed_221.set');
% EEG_03_231 = pop_loadset('03_processed_231.set');
% EEG_03_101 = pop_loadset('03_processed_101.set');
% EEG_03_stan1 = pop_mergeset(EEG_03_221,EEG_03_231);
EEG_03_222 = pop_loadset('03_processed_222.set');
EEG_03_232 = pop_loadset('03_processed_232.set');
EEG_03_102 = pop_loadset('03_processed_102.set');
EEG_03_stan2 = pop_mergeset(EEG_03_222,EEG_03_232);
% EEG_03_223 = pop_loadset('03_processed_223.set');
% EEG_03_233 = pop_loadset('03_processed_233.set');
% EEG_03_103 = pop_loadset('03_processed_103.set');
% EEG_03_stan3 = pop_mergeset(EEG_03_223,EEG_03_233);
% EEG_03_224 = pop_loadset('03_processed_224.set');
% EEG_03_234 = pop_loadset('03_processed_234.set');
% EEG_03_104 = pop_loadset('03_processed_104.set');
% EEG_03_stan4 = pop_mergeset(EEG_03_224,EEG_03_234);

% EEG_04_221 = pop_loadset('04_processed_221.set');
% EEG_04_231 = pop_loadset('04_processed_231.set');
% EEG_04_101 = pop_loadset('04_processed_101.set');
% EEG_04_stan1 = pop_mergeset(EEG_04_221,EEG_04_231);
EEG_04_222 = pop_loadset('04_processed_222.set');
EEG_04_232 = pop_loadset('04_processed_232.set');
EEG_04_102 = pop_loadset('04_processed_102.set');
EEG_04_stan2 = pop_mergeset(EEG_04_222,EEG_04_232);
EEG_04_223 = pop_loadset('04_processed_223.set');
EEG_04_233 = pop_loadset('04_processed_233.set');
EEG_04_103 = pop_loadset('04_processed_103.set');
EEG_04_stan3 = pop_mergeset(EEG_04_223,EEG_04_233);
EEG_04_224 = pop_loadset('04_processed_224.set');
EEG_04_234 = pop_loadset('04_processed_234.set');
EEG_04_104 = pop_loadset('04_processed_104.set');
EEG_04_stan4 = pop_mergeset(EEG_04_224,EEG_04_234);

EEG_05_221 = pop_loadset('05_processed_221.set');
EEG_05_231 = pop_loadset('05_processed_231.set');
EEG_05_101 = pop_loadset('05_processed_101.set');
EEG_05_stan1 = pop_mergeset(EEG_05_221,EEG_05_231);
% EEG_05_222 = pop_loadset('05_processed_222.set');
% EEG_05_232 = pop_loadset('05_processed_232.set');
% EEG_05_102 = pop_loadset('05_processed_102.set');
% EEG_05_stan2 = pop_mergeset(EEG_05_222,EEG_05_232);
EEG_05_223 = pop_loadset('05_processed_223.set');
EEG_05_233 = pop_loadset('05_processed_233.set');
EEG_05_103 = pop_loadset('05_processed_103.set');
EEG_05_stan3 = pop_mergeset(EEG_05_223,EEG_05_233);
EEG_05_224 = pop_loadset('05_processed_224.set');
EEG_05_234 = pop_loadset('05_processed_234.set');
EEG_05_104 = pop_loadset('05_processed_104.set');
EEG_05_stan4 = pop_mergeset(EEG_05_224,EEG_05_234);

EEG_06_221 = pop_loadset('06_processed_221.set');
EEG_06_231 = pop_loadset('06_processed_231.set');
EEG_06_101 = pop_loadset('06_processed_101.set');
EEG_06_stan1 = pop_mergeset(EEG_06_221,EEG_06_231);
% EEG_06_222 = pop_loadset('06_processed_222.set');
% EEG_06_232 = pop_loadset('06_processed_232.set');
% EEG_06_102 = pop_loadset('06_processed_102.set');
% EEG_06_stan2 = pop_mergeset(EEG_06_222,EEG_06_232);
EEG_06_223 = pop_loadset('06_processed_223.set');
EEG_06_233 = pop_loadset('06_processed_233.set');
EEG_06_103 = pop_loadset('06_processed_103.set');
EEG_06_stan3 = pop_mergeset(EEG_06_223,EEG_06_233);
EEG_06_224 = pop_loadset('06_processed_224.set');
EEG_06_234 = pop_loadset('06_processed_234.set');
EEG_06_104 = pop_loadset('06_processed_104.set');
EEG_06_stan4 = pop_mergeset(EEG_06_224,EEG_06_234);

% EEG_07_221 = pop_loadset('07_processed_221.set');
% EEG_07_231 = pop_loadset('07_processed_231.set');
% EEG_07_101 = pop_loadset('07_processed_101.set');
% EEG_07_stan1 = pop_mergeset(EEG_07_221,EEG_07_231);
EEG_07_222 = pop_loadset('07_processed_222.set');
EEG_07_232 = pop_loadset('07_processed_232.set');
EEG_07_102 = pop_loadset('07_processed_102.set');
EEG_07_stan2 = pop_mergeset(EEG_07_222,EEG_07_232);
EEG_07_223 = pop_loadset('07_processed_223.set');
EEG_07_233 = pop_loadset('07_processed_233.set');
EEG_07_103 = pop_loadset('07_processed_103.set');
EEG_07_stan3 = pop_mergeset(EEG_07_223,EEG_07_233);
EEG_07_224 = pop_loadset('07_processed_224.set');
EEG_07_234 = pop_loadset('07_processed_234.set');
EEG_07_104 = pop_loadset('07_processed_104.set');
EEG_07_stan4 = pop_mergeset(EEG_07_224,EEG_07_234);

% EEG_08_221 = pop_loadset('08_processed_221.set');
% EEG_08_231 = pop_loadset('08_processed_231.set');
% EEG_08_101 = pop_loadset('08_processed_101.set');
% EEG_08_stan1 = pop_mergeset(EEG_08_221,EEG_08_231);
EEG_08_222 = pop_loadset('08_processed_222.set');
EEG_08_232 = pop_loadset('08_processed_232.set');
EEG_08_102 = pop_loadset('08_processed_102.set');
EEG_08_stan2 = pop_mergeset(EEG_08_222,EEG_08_232);
EEG_08_223 = pop_loadset('08_processed_223.set');
EEG_08_233 = pop_loadset('08_processed_233.set');
EEG_08_103 = pop_loadset('08_processed_103.set');
EEG_08_stan3 = pop_mergeset(EEG_08_223,EEG_08_233);
EEG_08_224 = pop_loadset('08_processed_224.set');
EEG_08_234 = pop_loadset('08_processed_234.set');
EEG_08_104 = pop_loadset('08_processed_104.set');
EEG_08_stan4 = pop_mergeset(EEG_08_224,EEG_08_234);

EEG_09_221 = pop_loadset('09_processed_221.set');
EEG_09_231 = pop_loadset('09_processed_231.set');
EEG_09_101 = pop_loadset('09_processed_101.set');
EEG_09_stan1 = pop_mergeset(EEG_09_221,EEG_09_231);
% EEG_09_222 = pop_loadset('09_processed_222.set');
% EEG_09_232 = pop_loadset('09_processed_232.set');
% EEG_09_102 = pop_loadset('09_processed_102.set');
% EEG_09_stan2 = pop_mergeset(EEG_09_222,EEG_09_232);
EEG_09_223 = pop_loadset('09_processed_223.set');
EEG_09_233 = pop_loadset('09_processed_233.set');
EEG_09_103 = pop_loadset('09_processed_103.set');
EEG_09_stan3 = pop_mergeset(EEG_09_223,EEG_09_233);
EEG_09_224 = pop_loadset('09_processed_224.set');
EEG_09_234 = pop_loadset('09_processed_234.set');
EEG_09_104 = pop_loadset('09_processed_104.set');
EEG_09_stan4 = pop_mergeset(EEG_09_224,EEG_09_234);

EEG_10_221 = pop_loadset('10_processed_221.set');
EEG_10_231 = pop_loadset('10_processed_231.set');
EEG_10_101 = pop_loadset('10_processed_101.set');
EEG_10_stan1 = pop_mergeset(EEG_10_221,EEG_10_231);
% EEG_10_222 = pop_loadset('10_processed_222.set');
% EEG_10_232 = pop_loadset('10_processed_232.set');
% EEG_10_102 = pop_loadset('10_processed_102.set');
% EEG_10_stan2 = pop_mergeset(EEG_10_222,EEG_10_232);
EEG_10_223 = pop_loadset('10_processed_223.set');
EEG_10_233 = pop_loadset('10_processed_233.set');
EEG_10_103 = pop_loadset('10_processed_103.set');
EEG_10_stan3 = pop_mergeset(EEG_10_223,EEG_10_233);
EEG_10_224 = pop_loadset('10_processed_224.set');
EEG_10_234 = pop_loadset('10_processed_234.set');
EEG_10_104 = pop_loadset('10_processed_104.set');
EEG_10_stan4 = pop_mergeset(EEG_10_224,EEG_10_234);

% EEG_11_221 = pop_loadset('11_processed_221.set');
% EEG_11_231 = pop_loadset('11_processed_231.set');
% EEG_11_101 = pop_loadset('11_processed_101.set');
% EEG_11_stan1 = pop_mergeset(EEG_11_221,EEG_11_231);
EEG_11_222 = pop_loadset('11_processed_222.set');
EEG_11_232 = pop_loadset('11_processed_232.set');
EEG_11_102 = pop_loadset('11_processed_102.set');
EEG_11_stan2 = pop_mergeset(EEG_11_222,EEG_11_232);
EEG_11_223 = pop_loadset('11_processed_223.set');
EEG_11_233 = pop_loadset('11_processed_233.set');
EEG_11_103 = pop_loadset('11_processed_103.set');
EEG_11_stan3 = pop_mergeset(EEG_11_223,EEG_11_233);
EEG_11_224 = pop_loadset('11_processed_224.set');
EEG_11_234 = pop_loadset('11_processed_234.set');
EEG_11_104 = pop_loadset('11_processed_104.set');
EEG_11_stan4 = pop_mergeset(EEG_11_224,EEG_11_234);

% EEG_12_221 = pop_loadset('12_processed_221.set');
% EEG_12_231 = pop_loadset('12_processed_231.set');
% EEG_12_101 = pop_loadset('12_processed_101.set');
% EEG_12_stan1 = pop_mergeset(EEG_12_221,EEG_12_231);
EEG_12_222 = pop_loadset('12_processed_222.set');
EEG_12_232 = pop_loadset('12_processed_232.set');
EEG_12_102 = pop_loadset('12_processed_102.set');
EEG_12_stan2 = pop_mergeset(EEG_12_222,EEG_12_232);
EEG_12_223 = pop_loadset('12_processed_223.set');
EEG_12_233 = pop_loadset('12_processed_233.set');
EEG_12_103 = pop_loadset('12_processed_103.set');
EEG_12_stan3 = pop_mergeset(EEG_12_223,EEG_12_233);
EEG_12_224 = pop_loadset('12_processed_224.set');
EEG_12_234 = pop_loadset('12_processed_234.set');
EEG_12_104 = pop_loadset('12_processed_104.set');
EEG_12_stan4 = pop_mergeset(EEG_12_224,EEG_12_234);

EEG_13_221 = pop_loadset('13_processed_221.set');
EEG_13_231 = pop_loadset('13_processed_231.set');
EEG_13_101 = pop_loadset('13_processed_101.set');
EEG_13_stan1 = pop_mergeset(EEG_13_221,EEG_13_231);
% EEG_13_222 = pop_loadset('13_processed_222.set');
% EEG_13_232 = pop_loadset('13_processed_232.set');
% EEG_13_102 = pop_loadset('13_processed_102.set');
% EEG_13_stan2 = pop_mergeset(EEG_13_222,EEG_13_232);
EEG_13_223 = pop_loadset('13_processed_223.set');
EEG_13_233 = pop_loadset('13_processed_233.set');
EEG_13_103 = pop_loadset('13_processed_103.set');
EEG_13_stan3 = pop_mergeset(EEG_13_223,EEG_13_233);
EEG_13_224 = pop_loadset('13_processed_224.set');
EEG_13_234 = pop_loadset('13_processed_234.set');
EEG_13_104 = pop_loadset('13_processed_104.set');
EEG_13_stan4 = pop_mergeset(EEG_13_224,EEG_13_234);

% EEG_15_221 = pop_loadset('15_processed_221.set');
% EEG_15_231 = pop_loadset('15_processed_231.set');
% EEG_15_101 = pop_loadset('15_processed_101.set');
% EEG_15_stan1 = pop_mergeset(EEG_15_221,EEG_15_231);
EEG_15_222 = pop_loadset('15_processed_222.set');
EEG_15_232 = pop_loadset('15_processed_232.set');
EEG_15_102 = pop_loadset('15_processed_102.set');
EEG_15_stan2 = pop_mergeset(EEG_15_222,EEG_15_232);
EEG_15_223 = pop_loadset('15_processed_223.set');
EEG_15_233 = pop_loadset('15_processed_233.set');
EEG_15_103 = pop_loadset('15_processed_103.set');
EEG_15_stan3 = pop_mergeset(EEG_15_223,EEG_15_233);
EEG_15_224 = pop_loadset('15_processed_224.set');
EEG_15_234 = pop_loadset('15_processed_234.set');
EEG_15_104 = pop_loadset('15_processed_104.set');
EEG_15_stan4 = pop_mergeset(EEG_15_224,EEG_15_234);















%% via using a study design, but i think this is quatsch
[STUDY, ALLEEG] = std_editset( STUDY, ALLEEG, 'name','FamVoicePilot', ...
    'updatedat','off','commands',{{ ...
    'index',6,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/01_processed_101.set', ...
    'subject','S01','condition','train_dev'}, ...
    {'index',12,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/02_processed_101.set', ...
    'subject','S02','condition','train_dev'}, ...
    {'index',18,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/04_processed_102.set', ...
    'subject','S03','condition','train_dev'}, ...
    {'index',7,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/01_processed_231.set', ...
    'subject','S01','condition','train_stan'}, ...
    {'index',13,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/02_processed_231.set', ...
    'subject','S02','condition','train_stan'}, ...
    {'index',19,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/04_processed_232.set', ...
    'subject','S03','condition','train_stan'}, ...
    {'index',8,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/01_processed_103.set', ...
    'subject','S01','condition','novel3_dev'}, ...
    {'index',14,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/02_processed_103.set', ...
    'subject','S02','condition','novel3_dev'}, ...
    {'index',20,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/04_processed_103.set', ...
    'subject','S03','condition','novel3_dev'}, ...
    {'index',9,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/01_processed_233.set', ...
    'subject','S01','condition','novel3_stan'}, ...
    {'index',15,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/02_processed_233.set', ...
    'subject','S02','condition','novel3_stan'}, ...
    {'index',21,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/04_processed_233.set', ...
    'subject','S03','condition','novel3_stan'}, ...
    {'index',10,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/01_processed_104.set', ...
    'subject','S01','condition','novel4_dev'}, ...
    {'index',16,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/02_processed_104.set', ...
    'subject','S02','condition','novel4_dev'}, ...
    {'index',22,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/04_processed_104.set', ...
    'subject','S03','condition','novel4_dev'}, ...
    {'index',11,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/01_processed_234.set', ...
    'subject','S01','condition','novel4_stan'}, ...
    {'index',17,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/02_processed_234.set', ...
    'subject','S02','condition','novel4_stan'}, ...
    {'index',23,'load','/data/p_02453/raw_eeg/pilot/raw-data-sets/01-output/hp0.30_Amp200_wavThresholdHard_version3/05-processed/04_processed_234.set', ...
    'subject','S03','condition','novel4_stan'}} );




[STUDY, ALLEEG] = std_precomp(STUDY, ALLEEG, 'channels', 'interpolate', ...
    'on', 'recompute','on','erp','on');
tmpchanlocs = ALLEEG(1).chanlocs; STUDY = std_erpplot(STUDY, ALLEEG, ...
    'channels', { tmpchanlocs.labels }, 'plotconditions', 'together');

CURRENTSTUDY = 1; EEG = ALLEEG; 
CURRENTSET = [1:length(EEG)];
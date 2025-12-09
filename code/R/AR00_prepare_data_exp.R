# In this file, write the R-code necessary to load your original data file
# (e.g., an SPSS, Excel, or SAS-file), and convert it to a data.frame. Then,
# use the function open_data(your_data_frame) or closed_data(your_data_frame)
# to store the data.

# load packages --------------------------------------------------------------------
library(worcs)
library(here)
library(tidyr)
library(dplyr)
library(easystats)

here()

## Reason to center the covariates (see below)
# Centering covariates is generally good practice. Moreover, it is often important to  
# z -transform the covariate, i.e., to not only subtract the mean, but also to divide by its standard deviation. 
# The reason why this is often important is that the sampler doesn’t work well if predictors have different scales. 
# For the simple models we use here, the sampler works without  
# z -transformation. However, for more realistic and more complex models,  
# z -transformation of covariates is often very important.
# https://vasishth.github.io/bayescogsci/book/ch-coding2x2.html


# EXPERIMENTAL DATA ---------------------------------------------------------------------
## Prepare demographic data ---------------------------------------------------------
# Read csv demographics
t_demo = read.delim(here("data", "demographic_data_FamVoice_exp.csv"), header = TRUE, sep = ",", dec = ".")
t_mumdist = read.delim(here("data", "mumDist_mean_of_means.csv"), header = TRUE, sep = ",", dec = ".")
t_trials = read.delim(here("data", "trial_overview.txt"), header = TRUE, sep = "\t", dec = ".")

colnames(t_trials) = sub("X", "", colnames(t_trials))
colnames(t_trials) = sub("^0", "", colnames(t_trials))

# Create the new column mumDist in t_demo
t_demo = t_demo %>%
  mutate(mumDist = NA)  # Initialize mumDist column with NA

# Fill the mumDist column based on values from t_mumDist
for (i in 1:nrow(t_demo)){
  subjnr = as.character(t_demo$Subj[i])
  speaker = t_demo$TestSpeaker[i]
  testorder = t_demo$TestOrder[i]
  
  if (is.na(speaker)){
    t_demo$mumDist[i] = NA
  }else if (speaker == "S1"){
    if(as.integer(substr(as.character(testorder), 1, 1)) == 1){ 
      t_demo$mumDist[i] = t_mumdist[t_mumdist$vp == subjnr, "mean_s1"]
    }else{
      t_demo$mumDist[i] = t_mumdist[t_mumdist$vp == subjnr, "mean_s2"]
    }
  }else if (speaker =="S3"){
    t_demo$mumDist[i] = t_mumdist[t_mumdist$vp == subjnr, "mean_s3"]
  }else if (speaker =="S4"){
    t_demo$mumDist[i] = t_mumdist[t_mumdist$vp == subjnr, "mean_s4"]
  }else{
    t_demo$mumDist[i] = t_mumdist[t_mumdist$vp == subjnr, NA]
  }
}

## Function to compute mean nr of trials ------------------------------
row_101 <- which(t_trials$Cond == 101)
row_102 <- which(t_trials$Cond == 102)
row_103 <- which(t_trials$Cond == 103)
row_104 <- which(t_trials$Cond == 104)
row_221 <- which(t_trials$Cond == 221)
row_222 <- which(t_trials$Cond == 222)
row_223 <- which(t_trials$Cond == 223)
row_224 <- which(t_trials$Cond == 224)
row_231 <- which(t_trials$Cond == 231)
row_232 <- which(t_trials$Cond == 232)
row_233 <- which(t_trials$Cond == 233)
row_234 <- which(t_trials$Cond == 234)

calculate_trials <- function(subj_data, subj_col) {
  nrS <- numeric(nrow(subj_data))
  nrD <- numeric(nrow(subj_data))
  
  for (i in 1:nrow(subj_data)) {
    # Calculate nr of Trials for standard and deviant based on the conditions
    if (subj_data$TestSpeaker[i] == "S1") {
      nrS[i] <- (subj_col[row_221] + subj_col[row_222] + subj_col[row_231] + subj_col[row_232]) 
      nrD[i] <- (subj_col[row_101] + subj_col[row_102])
    }else if (subj_data$TestSpeaker[i] == "S4") {
      nrS[i] <- (subj_col[row_224] + subj_col[row_234]) 
      nrD[i] <- (subj_col[row_104])
    }else if (subj_data$TestSpeaker[i] == "S3") {
      nrS[i] <- (subj_col[row_223] + subj_col[row_233]) 
      nrD[i] <- (subj_col[row_103])
    }
  }
  return(list(trials_S = nrS, trials_D = nrD))
}

## ACQUISTION ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
### Function to process data ----------------------------------------------------------------------------------------------------------------------------------------------------------

process_acq_data <- function(file_name, t_demo) {
  # Read csv amplitude
  t = read.delim(here("data", file_name), header = TRUE, sep = "\t", dec = ".")
  
  # Combine 101 and 102, call it 101
  t[is.na(t)] = 0
  t[1,] = t[1,] + t[2,]
  t[1,1] = 101
  t = t[-2,]
  
  # Combine 221 and 222, call it 221
  t[4,] = t[4,] + t[5,]
  t[4,1] = 221
  t = t[-5,]
  
  # Combine 231 and 232, call it 231
  t[7,] = t[7,] + t[8,]
  t[7,1] = 231
  t = t[-8,]
  
  # Compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
  t[1,] = t[1,] - (t[4,] + t[7,]) / 2 
  t[1,1] = 1
  
  t[2,] = t[2,] - (t[5,] + t[8,]) / 2
  t[2,1] = 3
  
  t[3,] = t[3,] - (t[6,] + t[9,]) / 2
  t[3,1] = 4
  
  t = t[-9,]
  t = t[-8,]
  t = t[-7,]
  t = t[-6,]
  t = t[-5,]
  t = t[-4,]
  
  # Transpose
  t = t(t)
  
  # Fix row and column names
  colnames(t) = t[1,]
  t = t[-1, ] 
  rownames(t) = sub("X", "", rownames(t))
  t = cbind(rownames(t), data.frame(t, row.names = NULL))
  colnames(t)[1] = "Subj"
  t$Subj = factor(t$Subj)
  colnames(t) = sub("X", "S", colnames(t))
  
  # Take out the zeros from the subject names
  t$Subj = sub("^0", "", t$Subj)
  
  # Create the new column MMR in t_demo
  data_acq = t_demo
  data_acq = data_acq %>%
    mutate(MMR = NA)  # Initialize MMR column with NA
  
  # Fill the MMR column based on values from t
  for (i in 1:nrow(data_acq)) {
    subjnr = data_acq$Subj[i]
    speaker = data_acq$TestSpeaker[i]
    # Check if the combination exists in t
    if (subjnr %in% t$Subj && speaker %in% colnames(t)) {
      data_acq$MMR[i] = t[t$Subj == subjnr, speaker]
    }
  }
  
  # Move MMR to the second column
  data_acq = data_acq %>%
    select(Subj, MMR, everything())  
  
  # Remove NAs
  data_acq$MMR[data_acq$MMR == 0] <- NA
  data_acq = data_acq %>% drop_na(MMR)
  
  # Calculate Trials for Standard and Deviant
  subjects <- unique(data_acq$Subj)
  trials_S <- numeric(nrow(data_acq))
  trials_D <- numeric(nrow(data_acq))
  
  for (subj in subjects) {
    subj_data <- data_acq %>% filter(Subj == subj)
    subj_col <- t_trials[[as.character(subj)]]
    subj_col[is.na(subj_col)] <- 0
    
    results <- calculate_trials(subj_data, subj_col)
    trials_S[data_acq$Subj == subj] <- results$trials_S
    trials_D[data_acq$Subj == subj] <- results$trials_D
    
  }
  data_acq$TrialsStan <- trials_S
  data_acq$TrialsDev <- trials_D
  
  # Only include datasets that are analyzed
  data_acq = data_acq %>%
    filter(TestSpeaker == 'S1' | TestSpeaker == 'S4')
  
  # Make sure data classes are correct
  data_acq$MMR = as.numeric(data_acq$MMR)
  data_acq$mumDist = as.numeric(data_acq$mumDist)
  data_acq$age = as.numeric(data_acq$age)
  data_acq$nrSpeakersDaily = as.numeric(data_acq$nrSpeakersDaily)
  data_acq$TestSpeaker = as.factor(data_acq$TestSpeaker)
  data_acq$Group = as.factor(data_acq$Group)
  data_acq$sleepState = as.factor(data_acq$sleepState)
  data_acq$Subj = as.factor(data_acq$Subj)
  
  # Center and scale: this subtracts the mean from each value and then divides by the SD
  data_acq$mumDist <- as.numeric(scale(data_acq$mumDist))
  data_acq$nrSpeakersDaily <- as.numeric(scale(data_acq$nrSpeakersDaily))
  data_acq$age <- as.numeric(scale(data_acq$age))
  
  # Manually setting the contrasts
  contrasts(data_acq$TestSpeaker) <- contr.equalprior_pairs
  contrasts(data_acq$Group) <- contr.equalprior_pairs
  contrasts(data_acq$sleepState) <- contr.equalprior_pairs
  
  return(data_acq)  # Return the processed data
}


# Call function
data_acq <- process_acq_data("amplitudes_acq.txt", t_demo)
# Save data
setwd(here("data"))
open_data(data_acq, worcs_directory = ".")
setwd(here())

# Call function for exploratory data
data_acq_earlyTW <- process_acq_data("amplitudes_acq_earlyTW.txt", t_demo)
# Save data
setwd(here("data"))
open_data(data_acq_earlyTW, worcs_directory = ".")
setwd(here())


### Function to make dataframe to compute descriptive tables ----------------------------------------------------------------------------------------------------------------------------------------------------------
process_acq_data_noncentered <- function(file_name, t_demo) {
  # Read csv amplitude
  t = read.delim(here("data", file_name), header = TRUE, sep = "\t", dec = ".")
  
  # Combine 101 and 102, call it 101
  t[is.na(t)] = 0
  t[1,] = t[1,] + t[2,]
  t[1,1] = 101
  t = t[-2,]
  
  # Combine 221 and 222, call it 221
  t[4,] = t[4,] + t[5,]
  t[4,1] = 221
  t = t[-5,]
  
  # Combine 231 and 232, call it 231
  t[7,] = t[7,] + t[8,]
  t[7,1] = 231
  t = t[-8,]
  
  # Compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
  t[1,] = t[1,] - (t[4,] + t[7,]) / 2 
  t[1,1] = 1
  
  t[2,] = t[2,] - (t[5,] + t[8,]) / 2
  t[2,1] = 3
  
  t[3,] = t[3,] - (t[6,] + t[9,]) / 2
  t[3,1] = 4
  
  t = t[-9,]
  t = t[-8,]
  t = t[-7,]
  t = t[-6,]
  t = t[-5,]
  t = t[-4,]
  
  # Transpose
  t = t(t)
  
  # Fix row and column names
  colnames(t) = t[1,]
  t = t[-1, ] 
  rownames(t) = sub("X", "", rownames(t))
  t = cbind(rownames(t), data.frame(t, row.names = NULL))
  colnames(t)[1] = "Subj"
  t$Subj = factor(t$Subj)
  colnames(t) = sub("X", "S", colnames(t))
  
  # Take out the zeros from the subject names
  t$Subj = sub("^0", "", t$Subj)
  
  # Create the new column MMR in t_demo
  data_acq = t_demo
  data_acq = data_acq %>%
    mutate(MMR = NA)  # Initialize MMR column with NA
  
  # Fill the MMR column based on values from t
  for (i in 1:nrow(data_acq)) {
    subjnr = data_acq$Subj[i]
    speaker = data_acq$TestSpeaker[i]
    # Check if the combination exists in t
    if (subjnr %in% t$Subj && speaker %in% colnames(t)) {
      data_acq$MMR[i] = t[t$Subj == subjnr, speaker]
    }
  }
  
  # Move MMR to the second column
  data_acq = data_acq %>%
    select(Subj, MMR, everything())  
  
  # Remove NAs
  data_acq$MMR[data_acq$MMR == 0] <- NA
  data_acq = data_acq %>% drop_na(MMR)
  
  # Calculate Trials for Standard and Deviant
  subjects <- unique(data_acq$Subj)
  trials_S <- numeric(nrow(data_acq))
  trials_D <- numeric(nrow(data_acq))
  
  for (subj in subjects) {
    subj_data <- data_acq %>% filter(Subj == subj)
    subj_col <- t_trials[[as.character(subj)]]
    subj_col[is.na(subj_col)] <- 0
    
    results <- calculate_trials(subj_data, subj_col)
    trials_S[data_acq$Subj == subj] <- results$trials_S
    trials_D[data_acq$Subj == subj] <- results$trials_D
    
  }
  data_acq$TrialsStan <- trials_S
  data_acq$TrialsDev <- trials_D
  
  # Only include datasets that are analyzed
  data_acq = data_acq %>%
    filter(TestSpeaker == 'S1' | TestSpeaker == 'S4')
  
  # Make sure data classes are correct
  data_acq$MMR = as.numeric(data_acq$MMR)
  data_acq$mumDist = as.numeric(data_acq$mumDist)
  data_acq$age = as.numeric(data_acq$age)
  data_acq$nrSpeakersDaily = as.numeric(data_acq$nrSpeakersDaily)
  data_acq$TestSpeaker = as.factor(data_acq$TestSpeaker)
  data_acq$Group = as.factor(data_acq$Group)
  data_acq$sleepState = as.factor(data_acq$sleepState)
  data_acq$Subj = as.factor(data_acq$Subj)
  
  # Center and scale: this subtracts the mean from each value and then divides by the SD
  # data_acq$mumDist <- as.numeric(scale(data_acq$mumDist))
  # data_acq$nrSpeakersDaily <- as.numeric(scale(data_acq$nrSpeakersDaily))
  # data_acq$age <- as.numeric(scale(data_acq$age))
  
  # Manually setting the contrasts
  contrasts(data_acq$TestSpeaker) <- contr.equalprior_pairs
  contrasts(data_acq$Group) <- contr.equalprior_pairs
  contrasts(data_acq$sleepState) <- contr.equalprior_pairs
  
  return(data_acq)  # Return the processed data
}

data_acq_noncentered <- process_acq_data_noncentered("amplitudes_acq.txt", t_demo)


## RECOGNITION ----------------------------------------------------------------------------------------

process_rec_data <- function(file_name, t_demo) {
  # Read csv amplitude
  t = read.delim(here("data", file_name), header = TRUE, sep = "\t", dec = ".")

  # Combine 101 and 102, call it 101
  t[is.na(t)] = 0
  t[1,] = t[1,] + t[2,]
  t[1,1] = 101
  t = t[-2,]
  
  # Combine 221 and 222, call it 221
  t[4,] = t[4,] + t[5,]
  t[4,1] = 221
  t = t[-5,]
  
  # Combine 231 and 232, call it 231
  t[7,] = t[7,] + t[8,]
  t[7,1] = 231
  t = t[-8,]
  
  # Compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
  t[1,] = t[1,] - (t[4,] + t[7,]) / 2 
  t[1,1] = 1
  
  t[2,] = t[2,] - (t[5,] + t[8,]) / 2
  t[2,1] = 3
  
  t[3,] = t[3,] - (t[6,] + t[9,]) / 2
  t[3,1] = 4
  
  t = t[-9,]
  t = t[-8,]
  t = t[-7,]
  t = t[-6,]
  t = t[-5,]
  t = t[-4,]
  
  # Transpose
  t = t(t)
  
  # Fix row and column names
  colnames(t) = t[1,]
  t = t[-1, ] 
  rownames(t) = sub("X", "", rownames(t))
  t = cbind(rownames(t), data.frame(t, row.names = NULL))
  colnames(t)[1] = "Subj"
  t$Subj = factor(t$Subj)
  colnames(t) = sub("X", "S", colnames(t))
  
  # Take out the zeros from the subject names
  t$Subj = sub("^0", "", t$Subj)
  
  # Create the new column MMR in t_demo
  data_rec = t_demo
  data_rec = data_rec %>%
    mutate(MMR = NA)  # Initialize MMR column with NA
  
  # Fill the MMR column based on values from t
  for (i in 1:nrow(data_rec)) {
    subjnr = data_rec$Subj[i]
    speaker = data_rec$TestSpeaker[i]
    # Check if the combination exists in t
    if (subjnr %in% t$Subj && speaker %in% colnames(t)) {
      data_rec$MMR[i] = t[t$Subj == subjnr, speaker]
    }
  }
  
  # Move MMR to the second column
  data_rec = data_rec %>%
    select(Subj, MMR, everything())  
  
  # Remove NAs
  data_rec$MMR[data_rec$MMR == 0] <- NA
  data_rec = data_rec %>% drop_na(MMR)
  
  # Calculate Trials for Standard and Deviant
  subjects <- unique(data_rec$Subj)
  trials_S <- numeric(nrow(data_rec))
  trials_D <- numeric(nrow(data_rec))
  
  for (subj in subjects) {
    subj_data <- data_rec %>% filter(Subj == subj)
    subj_col <- t_trials[[as.character(subj)]]
    subj_col[is.na(subj_col)] <- 0
    
    results <- calculate_trials(subj_data, subj_col)
    trials_S[data_rec$Subj == subj] <- results$trials_S
    trials_D[data_rec$Subj == subj] <- results$trials_D
    
  }
  data_rec$TrialsStan <- trials_S
  data_rec$TrialsDev <- trials_D
  
  # Make sure data classes are correct
  data_rec$MMR = as.numeric(data_rec$MMR)
  data_rec$mumDist = as.numeric(data_rec$mumDist)
  data_rec$age = as.numeric(data_rec$age)
  data_rec$nrSpeakersDaily = as.numeric(data_rec$nrSpeakersDaily)
  data_rec$TestSpeaker = as.factor(data_rec$TestSpeaker)
  data_rec$Group = as.factor(data_rec$Group)
  data_rec$sleepState = as.factor(data_rec$sleepState)
  data_rec$Subj = as.factor(data_rec$Subj)
  
  # Center and scale: this subtracts the mean from each value and then divides by the SD
  data_rec$mumDist <- as.numeric(scale(data_rec$mumDist))
  data_rec$nrSpeakersDaily <- as.numeric(scale(data_rec$nrSpeakersDaily))
  data_rec$age <- as.numeric(scale(data_rec$age))
  
  # Manually setting the contrasts
  contrasts(data_rec$TestSpeaker) <- contr.equalprior_pairs
  contrasts(data_rec$Group) <- contr.equalprior_pairs
  contrasts(data_rec$sleepState) <- contr.equalprior_pairs
  
  return(data_rec)  # Return the processed data
}

# Call function
data_rec <- process_rec_data("amplitudes_rec.txt", t_demo)

# Save data
setwd(here("data"))
open_data(data_rec, worcs_directory = ".")
setwd(here())


# Dataframe to compute descriptive tables
process_rec_data_noncentered <- function(file_name, t_demo) {
  # Read csv amplitude
  t = read.delim(here("data", file_name), header = TRUE, sep = "\t", dec = ".")
  
  # Combine 101 and 102, call it 101
  t[is.na(t)] = 0
  t[1,] = t[1,] + t[2,]
  t[1,1] = 101
  t = t[-2,]
  
  # Combine 221 and 222, call it 221
  t[4,] = t[4,] + t[5,]
  t[4,1] = 221
  t = t[-5,]
  
  # Combine 231 and 232, call it 231
  t[7,] = t[7,] + t[8,]
  t[7,1] = 231
  t = t[-8,]
  
  # Compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
  t[1,] = t[1,] - (t[4,] + t[7,]) / 2 
  t[1,1] = 1
  
  t[2,] = t[2,] - (t[5,] + t[8,]) / 2
  t[2,1] = 3
  
  t[3,] = t[3,] - (t[6,] + t[9,]) / 2
  t[3,1] = 4
  
  t = t[-9,]
  t = t[-8,]
  t = t[-7,]
  t = t[-6,]
  t = t[-5,]
  t = t[-4,]
  
  # Transpose
  t = t(t)
  
  # Fix row and column names
  colnames(t) = t[1,]
  t = t[-1, ] 
  rownames(t) = sub("X", "", rownames(t))
  t = cbind(rownames(t), data.frame(t, row.names = NULL))
  colnames(t)[1] = "Subj"
  t$Subj = factor(t$Subj)
  colnames(t) = sub("X", "S", colnames(t))
  
  # Take out the zeros from the subject names
  t$Subj = sub("^0", "", t$Subj)
  
  # Create the new column MMR in t_demo
  data_rec = t_demo
  data_rec = data_rec %>%
    mutate(MMR = NA)  # Initialize MMR column with NA
  
  # Fill the MMR column based on values from t
  for (i in 1:nrow(data_rec)) {
    subjnr = data_rec$Subj[i]
    speaker = data_rec$TestSpeaker[i]
    # Check if the combination exists in t
    if (subjnr %in% t$Subj && speaker %in% colnames(t)) {
      data_rec$MMR[i] = t[t$Subj == subjnr, speaker]
    }
  }
  
  # Move MMR to the second column
  data_rec = data_rec %>%
    select(Subj, MMR, everything())  
  
  # Remove NAs
  data_rec$MMR[data_rec$MMR == 0] <- NA
  data_rec = data_rec %>% drop_na(MMR)
  
  # Calculate Trials for Standard and Deviant
  subjects <- unique(data_rec$Subj)
  trials_S <- numeric(nrow(data_rec))
  trials_D <- numeric(nrow(data_rec))
  
  for (subj in subjects) {
    subj_data <- data_rec %>% filter(Subj == subj)
    subj_col <- t_trials[[as.character(subj)]]
    subj_col[is.na(subj_col)] <- 0
    
    results <- calculate_trials(subj_data, subj_col)
    trials_S[data_rec$Subj == subj] <- results$trials_S
    trials_D[data_rec$Subj == subj] <- results$trials_D
    
  }
  data_rec$TrialsStan <- trials_S
  data_rec$TrialsDev <- trials_D
  
  # Make sure data classes are correct
  data_rec$MMR = as.numeric(data_rec$MMR)
  data_rec$mumDist = as.numeric(data_rec$mumDist)
  data_rec$age = as.numeric(data_rec$age)
  data_rec$nrSpeakersDaily = as.numeric(data_rec$nrSpeakersDaily)
  data_rec$TestSpeaker = as.factor(data_rec$TestSpeaker)
  data_rec$Group = as.factor(data_rec$Group)
  data_rec$sleepState = as.factor(data_rec$sleepState)
  data_rec$Subj = as.factor(data_rec$Subj)
  
  # Center and scale: this subtracts the mean from each value and then divides by the SD
  # data_rec$mumDist <- as.numeric(scale(data_rec$mumDist))
  # data_rec$nrSpeakersDaily <- as.numeric(scale(data_rec$nrSpeakersDaily))
  # data_rec$age <- as.numeric(scale(data_rec$age))
  
  # Manually setting the contrasts
  contrasts(data_rec$TestSpeaker) <- contr.equalprior_pairs
  contrasts(data_rec$Group) <- contr.equalprior_pairs
  contrasts(data_rec$sleepState) <- contr.equalprior_pairs
  
  return(data_rec)  # Return the processed data
}

data_rec_noncentered <- process_rec_data_noncentered("amplitudes_rec.txt", t_demo)

## REC FAM ----------------------------------------------------------------------------------------

process_recfam_data <- function(file_name, t_demo) {
  # Read csv amplitude
  t = read.delim(here("data", file_name), header = TRUE, sep = "\t", dec = ".")
  
  # Combine 101 and 102, call it 101
  t[is.na(t)] = 0
  t[1,] = t[1,] + t[2,]
  t[1,1] = 101
  t = t[-2,]
  
  # Combine 221 and 222, call it 221
  t[4,] = t[4,] + t[5,]
  t[4,1] = 221
  t = t[-5,]
  
  # Combine 231 and 232, call it 231
  t[7,] = t[7,] + t[8,]
  t[7,1] = 231
  t = t[-8,]
  
  # Compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
  t[1,] = t[1,] - (t[4,] + t[7,]) / 2 
  t[1,1] = 1
  
  t[2,] = t[2,] - (t[5,] + t[8,]) / 2
  t[2,1] = 3
  
  t[3,] = t[3,] - (t[6,] + t[9,]) / 2
  t[3,1] = 4
  
  t = t[-9,]
  t = t[-8,]
  t = t[-7,]
  t = t[-6,]
  t = t[-5,]
  t = t[-4,]
  
  # Transpose
  t = t(t)
  
  # Fix row and column names
  colnames(t) = t[1,]
  t = t[-1, ] 
  rownames(t) = sub("X", "", rownames(t))
  t = cbind(rownames(t), data.frame(t, row.names = NULL))
  colnames(t)[1] = "Subj"
  t$Subj = factor(t$Subj)
  colnames(t) = sub("X", "S", colnames(t))
  
  # Take out the zeros from the subject names
  t$Subj = sub("^0", "", t$Subj)
  
  # Create the new column MMR in t_demo
  data_rec = t_demo
  data_rec = data_rec %>%
    mutate(MMR = NA)  # Initialize MMR column with NA
  
  # Fill the MMR column based on values from t
  for (i in 1:nrow(data_rec)) {
    subjnr = data_rec$Subj[i]
    speaker = data_rec$TestSpeaker[i]
    # Check if the combination exists in t
    if (subjnr %in% t$Subj && speaker %in% colnames(t)) {
      data_rec$MMR[i] = t[t$Subj == subjnr, speaker]
    }
  }
  
  # Move MMR to the second column
  data_rec = data_rec %>%
    select(Subj, MMR, everything())  
  
  # Remove NAs
  data_rec$MMR[data_rec$MMR == 0] <- NA
  data_rec = data_rec %>% drop_na(MMR)
  
  # Calculate Trials for Standard and Deviant
  subjects <- unique(data_rec$Subj)
  trials_S <- numeric(nrow(data_rec))
  trials_D <- numeric(nrow(data_rec))
  
  for (subj in subjects) {
    subj_data <- data_rec %>% filter(Subj == subj)
    subj_col <- t_trials[[as.character(subj)]]
    subj_col[is.na(subj_col)] <- 0
    
    results <- calculate_trials(subj_data, subj_col)
    trials_S[data_rec$Subj == subj] <- results$trials_S
    trials_D[data_rec$Subj == subj] <- results$trials_D
    
  }
  data_rec$TrialsStan <- trials_S
  data_rec$TrialsDev <- trials_D
  
  # Only include datasets that are analyzed
  data_rec = data_rec %>%
    filter(Group == 'fam')
  
  # Make sure data classes are correct
  data_rec$MMR = as.numeric(data_rec$MMR)
  data_rec$mumDist = as.numeric(data_rec$mumDist)
  data_rec$age = as.numeric(data_rec$age)
  data_rec$nrSpeakersDaily = as.numeric(data_rec$nrSpeakersDaily)
  data_rec$TestSpeaker = as.factor(data_rec$TestSpeaker)
  data_rec$Group = as.factor(data_rec$Group)
  data_rec$sleepState = as.factor(data_rec$sleepState)
  data_rec$Subj = as.factor(data_rec$Subj)
  
  # Center and scale: this subtracts the mean from each value and then divides by the SD
  data_rec$mumDist <- as.numeric(scale(data_rec$mumDist))
  data_rec$nrSpeakersDaily <- as.numeric(scale(data_rec$nrSpeakersDaily))
  data_rec$age <- as.numeric(scale(data_rec$age))
  
  # Manually setting the contrasts
  contrasts(data_rec$TestSpeaker) <- contr.equalprior_pairs
  # contrasts(data_rec$Group) <- contr.equalprior_pairs
  contrasts(data_rec$sleepState) <- contr.equalprior_pairs
  
  return(data_rec)  # Return the processed data
}

# Call function
data_recfam_normal <- process_recfam_data("amplitudes_recfam_normal.txt", t_demo)
data_recfam_frontal <- process_recfam_data("amplitudes_recfam_frontal.txt", t_demo)

# Save data
setwd(here("data"))
open_data(data_recfam_normal, worcs_directory = ".")
open_data(data_recfam_frontal, worcs_directory = ".")
setwd(here())

# Dataframe to compute descriptive tables
process_recfam_data_noncentered <- function(file_name, t_demo) {
  # Read csv amplitude
  t = read.delim(here("data", file_name), header = TRUE, sep = "\t", dec = ".")
  
  # Combine 101 and 102, call it 101
  t[is.na(t)] = 0
  t[1,] = t[1,] + t[2,]
  t[1,1] = 101
  t = t[-2,]
  
  # Combine 221 and 222, call it 221
  t[4,] = t[4,] + t[5,]
  t[4,1] = 221
  t = t[-5,]
  
  # Combine 231 and 232, call it 231
  t[7,] = t[7,] + t[8,]
  t[7,1] = 231
  t = t[-8,]
  
  # Compute MMR: deviant minus standard, and rename the conditions. 1 = TrainVoice (S1 or S2), 3 = FamNonTrainVoice (S3), 4 = NovelVoice (S4)
  t[1,] = t[1,] - (t[4,] + t[7,]) / 2 
  t[1,1] = 1
  
  t[2,] = t[2,] - (t[5,] + t[8,]) / 2
  t[2,1] = 3
  
  t[3,] = t[3,] - (t[6,] + t[9,]) / 2
  t[3,1] = 4
  
  t = t[-9,]
  t = t[-8,]
  t = t[-7,]
  t = t[-6,]
  t = t[-5,]
  t = t[-4,]
  
  # Transpose
  t = t(t)
  
  # Fix row and column names
  colnames(t) = t[1,]
  t = t[-1, ] 
  rownames(t) = sub("X", "", rownames(t))
  t = cbind(rownames(t), data.frame(t, row.names = NULL))
  colnames(t)[1] = "Subj"
  t$Subj = factor(t$Subj)
  colnames(t) = sub("X", "S", colnames(t))
  
  # Take out the zeros from the subject names
  t$Subj = sub("^0", "", t$Subj)
  
  # Create the new column MMR in t_demo
  data_rec = t_demo
  data_rec = data_rec %>%
    mutate(MMR = NA)  # Initialize MMR column with NA
  
  # Fill the MMR column based on values from t
  for (i in 1:nrow(data_rec)) {
    subjnr = data_rec$Subj[i]
    speaker = data_rec$TestSpeaker[i]
    # Check if the combination exists in t
    if (subjnr %in% t$Subj && speaker %in% colnames(t)) {
      data_rec$MMR[i] = t[t$Subj == subjnr, speaker]
    }
  }
  
  # Move MMR to the second column
  data_rec = data_rec %>%
    select(Subj, MMR, everything())  
  
  # Remove NAs
  data_rec$MMR[data_rec$MMR == 0] <- NA
  data_rec = data_rec %>% drop_na(MMR)
  
  # Calculate Trials for Standard and Deviant
  subjects <- unique(data_rec$Subj)
  trials_S <- numeric(nrow(data_rec))
  trials_D <- numeric(nrow(data_rec))
  
  for (subj in subjects) {
    subj_data <- data_rec %>% filter(Subj == subj)
    subj_col <- t_trials[[as.character(subj)]]
    subj_col[is.na(subj_col)] <- 0
    
    results <- calculate_trials(subj_data, subj_col)
    trials_S[data_rec$Subj == subj] <- results$trials_S
    trials_D[data_rec$Subj == subj] <- results$trials_D
    
  }
  data_rec$TrialsStan <- trials_S
  data_rec$TrialsDev <- trials_D
  
  # Only include datasets that are analyzed
  data_rec = data_rec %>%
    filter(Group == 'fam')
  
  # Make sure data classes are correct
  data_rec$MMR = as.numeric(data_rec$MMR)
  data_rec$mumDist = as.numeric(data_rec$mumDist)
  data_rec$age = as.numeric(data_rec$age)
  data_rec$nrSpeakersDaily = as.numeric(data_rec$nrSpeakersDaily)
  data_rec$TestSpeaker = as.factor(data_rec$TestSpeaker)
  data_rec$Group = as.factor(data_rec$Group)
  data_rec$sleepState = as.factor(data_rec$sleepState)
  data_rec$Subj = as.factor(data_rec$Subj)
  
  # # Center and scale: this subtracts the mean from each value and then divides by the SD
  # data_rec$mumDist <- as.numeric(scale(data_rec$mumDist))
  # data_rec$nrSpeakersDaily <- as.numeric(scale(data_rec$nrSpeakersDaily))
  # data_rec$age <- as.numeric(scale(data_rec$age))
  
  # Manually setting the contrasts
  contrasts(data_rec$TestSpeaker) <- contr.equalprior_pairs
  #contrasts(data_rec$Group) <- contr.equalprior_pairs # here we only have one group
  contrasts(data_rec$sleepState) <- contr.equalprior_pairs
  
  return(data_rec)  # Return the processed data
}

data_recfam_normal_noncentered <- process_recfam_data_noncentered("amplitudes_recfam_normal.txt", t_demo)


# Clean up ----------------
rm(t_demo, t_mumdist, i, speaker, subjnr,testorder)



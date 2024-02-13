
library(designr)
library(tidyverse)

# Simulate some data --------------------------------------------------------------------
# create experimental design for ACQUISITION
design <-
  fixed.factor("Group", levels=c("fam", "unfam")) +
  fixed.factor("TestSpeaker", levels=c("1", "2")) +
  random.factor("Subj", groups="Group", instances=32)

dat <- design.codes(design)
# define a sum contrast. I take 0.5 instead of 1 because it's nicer for two levels (https://phillipalday.com/stats/coding.html)
dat$TestSpeaker_n <- ifelse(dat$TestSpeaker=="1", +0.5, -0.5)
dat$Group_n <- ifelse(dat$Group=="fam", +0.5, -0.5)

# simulate data
dat$MMR <- 2.92 + 5*dat$TestSpeaker_n + rnorm(nrow(dat),0,14) # 1st part: the mean of the MMR for all groups together, 2nd part: making sure the groups are different, 3rd part: adding noise: the SD of the MMR is 14

# now add dummy values for the other variables
dat$mumDistTrainS = NA
dat$mumDistNovelS = NA
dat$timeVoiceFam = NA
dat$nrSpeakersDaily = NA
dat$sleepState = NA

dat$mumDistTrainS = rep(abs(rnorm(nrow(dat)/2,1,2)), each=2)
dat$mumDistNovelS = rep(abs(rnorm(nrow(dat)/2,1,2.5)), each=2)
dat$timeVoiceFam = rep(round(rnorm(nrow(dat)/2,21,2)), each=2)
dat$nrSpeakersDaily = rep(round(rnorm(nrow(dat)/2,4,1)), each=2)
dat$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat)/2, replace = TRUE), each=2)

# centering the covariates -  CHECK WHETHER THIS IS NECESSARY
(dat <- dat %>%
    mutate(mumDistTrainS = mumDistTrainS - mean(mumDistTrainS)))
(dat <- dat %>%
    mutate(mumDistNovelS = mumDistNovelS - mean(mumDistNovelS)))
(dat <- dat %>%
    mutate(timeVoiceFam = timeVoiceFam - mean(timeVoiceFam)))
(dat <- dat %>%
    mutate(nrSpeakersDaily = nrSpeakersDaily - mean(nrSpeakersDaily)))


# create experimental design for RECOGNITION
design <-
  fixed.factor("Group", levels=c("fam", "unfam")) +
  fixed.factor("TestSpeaker", levels=c("1", "2", "3")) +
  random.factor("Subj", groups="Group", instances=32)

dat_rec <- design.codes(design)

# define a sum contrast. I take 0.5 instead of 1 because it's nicer for two levels (https://phillipalday.com/stats/coding.html)
dat_rec$TestSpeaker_n <- NA
for(i in 1:nrow(dat_rec)){
  if(dat_rec$TestSpeaker[i]=="1"){
    dat_rec$TestSpeaker_n[i] = 0.1
  }else if(dat_rec$TestSpeaker[i]=="2"){
    dat_rec$TestSpeaker_n[i] = 0.4
  }else{
    dat_rec$TestSpeaker_n[i] = -.5
  }
}


dat_rec$Group_n <- ifelse(dat_rec$Group=="fam", +0.5, -0.5)

# simulate data
dat_rec$MMR <- 2.92 + 5*dat_rec$TestSpeaker_n + rnorm(nrow(dat_rec),0,14) # 1st part: the mean of the MMR for all groups together, 2nd part: making sure the groups are different, 3rd part: adding noise: the SD of the MMR is 14

# now add dummy values for the other variables
dat_rec$mumDistTrainS = NA
dat_rec$mumDistNovelS = NA
dat_rec$timeVoiceFam = NA
dat_rec$nrSpeakersDaily = NA
dat_rec$sleepState = NA

dat_rec$mumDistTrainS = rep(abs(rnorm(nrow(dat_rec)/3,1,2)), each=3)
dat_rec$mumDistNovelS = rep(abs(rnorm(nrow(dat_rec)/3,1,2.5)), each=3)
dat_rec$timeVoiceFam = rep(round(rnorm(nrow(dat_rec)/3,21,2)), each=3)
dat_rec$nrSpeakersDaily = rep(round(rnorm(nrow(dat_rec)/3,4,1)), each=3)
dat_rec$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat_rec)/3, replace = TRUE), each=3)

# centering the covariates -  CHECK WHETHER THIS IS NECESSARY
(dat_rec <- dat_rec %>%
    mutate(mumDistTrainS = mumDistTrainS - mean(mumDistTrainS)))
(dat_rec <- dat_rec %>%
    mutate(mumDistNovelS = mumDistNovelS - mean(mumDistNovelS)))
(dat_rec <- dat_rec %>%
    mutate(timeVoiceFam = timeVoiceFam - mean(timeVoiceFam)))
(dat_rec <- dat_rec %>%
    mutate(nrSpeakersDaily = nrSpeakersDaily - mean(nrSpeakersDaily)))

dat_rec = subset(dat_rec, select = -c(TestSpeaker_n,Group_n) ) # remove these "contrast coding columns" because we only use them for data simulation



rm(design,i)
# # Now we add the contrasts to the factors itself: 
# ### CHECK WHETHER THIS IS NECESSARY
# contrasts(dat$Group) <- c(-0.5, +0.5)
# contrasts(dat$TestSpeaker) <- c(-0.5, +0.5)
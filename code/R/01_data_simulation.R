# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# install packages --------------------------------------------------------------------
# install.packages(designr)
# install.packages(tidyverse)


# load packages --------------------------------------------------------------------
library(designr)
library(tidyverse)
library(truncnorm)

# Simulate some data for ACQUISITION--------------------------------------------------------------------
# create experimental design 
design <-
  fixed.factor("Group", levels=c("fam", "unfam")) +
  fixed.factor("TestSpeaker", levels=c("1", "2")) +
  random.factor("Subj", groups="Group", instances=32)

dat <- design.codes(design)
# define a sum contrast. I take 0.5 instead of 1 because it's nicer for two levels (https://phillipalday.com/stats/coding.html)
dat$TestSpeaker_n <- ifelse(dat$TestSpeaker=="1", +0.5, -0.5)
dat$Group_n <- ifelse(dat$Group=="fam", +0.5, -0.5)

# simulate data
dat$MMR <- 6 + 5*dat$TestSpeaker_n + rnorm(nrow(dat),0,22) # 1st part: the mean of the MMR for all groups together, 
                                                              # 2nd part: making sure the groups are different: adding an effect of 5: S1=2.5, S2=-2/5
                                                              # 3rd part: adding noise: the SD of the MMR is 22

# now add dummy values for the other variables
dat$mumDist = NA
dat$nrSpeakersDaily = NA
dat$sleepState = NA
dat$age = NA

dat$age = rep(abs(rnorm(nrow(dat)/2,90,12)), each=2)
dat$mumDist = rep(abs(rnorm(nrow(dat),1,2)), each=1)
dat$nrSpeakersDaily = rep(round(rtruncnorm(nrow(dat)/2,a=1,b= Inf,4,2)), each=2) # truncate dist at 1 (since every child will hear at least one speaker in daily life)
dat$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat)/2, replace = TRUE), each=2)


dat = subset(dat, select = -c(TestSpeaker_n,Group_n) ) # remove these "contrast coding columns" because we only use them for data simulation
dat$sleepState = as.factor(dat$sleepState)

# Center and scale: this subtracts the mean from each value and then divides by the SD
dat$mumDist<- scale(dat$mumDist)
dat$nrSpeakersDaily <- scale(dat$nrSpeakersDaily)
dat$age <- scale(dat$age)



# Simulate some data for RECOGNITION--------------------------------------------------------------------
# create experimental design 
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
dat_rec$MMR <- 6 + 5*dat_rec$TestSpeaker_n + rnorm(nrow(dat_rec),0,22) # 1st part: the mean of the MMR for all groups together, 2nd part: making sure the groups are different, 3rd part: adding noise: the SD of the MMR is 14

# now add dummy values for the other variables
dat_rec$mumDist = NA
dat_rec$nrSpeakersDaily = NA
dat_rec$sleepState = NA
dat_rec$age = NA

dat_rec$age = rep(abs(round(rnorm(nrow(dat_rec)/3,90,12))), each=3)
dat_rec$mumDist = rep(abs(rnorm(nrow(dat_rec),1,2)), each=1)
dat_rec$nrSpeakersDaily = rep(round(rtruncnorm(nrow(dat_rec)/3,a=1,b= Inf,4,2)), each=3) # truncate dist at 1 (since every child will hear at least one speaker in daily life)
dat_rec$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat_rec)/3, replace = TRUE), each=3)

# centering the covariates -  CHECK WHETHER THIS IS NECESSARY
# (dat_rec <- dat_rec %>%
#     mutate(mumDistTrainS = mumDistTrainS - mean(mumDistTrainS)))
# (dat_rec <- dat_rec %>%
#     mutate(mumDistNovelS = mumDistNovelS - mean(mumDistNovelS)))
# (dat_rec <- dat_rec %>%
#     mutate(timeVoiceFam = timeVoiceFam - mean(timeVoiceFam)))
# (dat_rec <- dat_rec %>%
#     mutate(nrSpeakersDaily = nrSpeakersDaily - mean(nrSpeakersDaily)))

dat_rec = subset(dat_rec, select = -c(TestSpeaker_n,Group_n) ) # remove these "contrast coding columns" because we only use them for data simulation

dat_rec$sleepState = as.factor(dat_rec$sleepState)

# Center and scale
dat_rec$mumDist <- scale(dat_rec$mumDist)
dat_rec$nrSpeakersDaily <- scale(dat_rec$nrSpeakersDaily)
dat_rec$age <- scale(dat_rec$age)

rm(design,i)


# # Now we add the contrasts to the factors itself: 
# ### CHECK WHETHER THIS IS NECESSARY
# contrasts(dat$Group) <- c(-0.5, +0.5)
# contrasts(dat$TestSpeaker) <- c(-0.5, +0.5)







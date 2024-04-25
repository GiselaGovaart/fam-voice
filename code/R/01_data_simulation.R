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
dat_acq <- design.codes(design)

# define contrasts for data sim
dat_acq$TestSpeaker_n <- ifelse(dat_acq$TestSpeaker == "1" , +0.5, -0.5)
dat_acq$Group_n <- ifelse(dat_acq$Group == "fam" , +0.5, -0.5)

# simulate data
dat_acq$MMR <- 5 +                  # The mean of the MMR for all groups together = 5
  5*dat_acq$TestSpeaker_n +         # Adding an effect of 5 on TestSpeaker
  5*dat_acq$Group_n +               # Adding an effect of 5 on Group
  rnorm(nrow(dat_acq),0,15)         # SD of 15

dat_acq = subset(dat_acq, select = -c(Group_n, TestSpeaker_n)) # remove these "contrast coding columns" because we only use them for data simulation

# now add dummy values for the other variables
dat_acq$mumDist = NA
dat_acq$nrSpeakersDaily = NA
dat_acq$sleepState = NA
dat_acq$age = NA

dat_acq$age = rep(abs(round(rnorm(nrow(dat_acq)/2,95,10))), each=2)
dat_acq$mumDist = rep(abs(round(rnorm(nrow(dat_acq),1,2),digits=4)), each=1)
dat_acq$nrSpeakersDaily = rep(round(rtruncnorm(nrow(dat_acq)/2,a=1,b= Inf,4,2)), each=2) # truncate dist at 1 (since every child will hear at least one speaker in daily life)
dat_acq$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat_acq), replace = TRUE))
dat_acq$sleepState = as.factor(dat_acq$sleepState)

# Center and scale: this subtracts the mean from each value and then divides by the SD
dat_acq$mumDist<- as.numeric(scale(dat_acq$mumDist))
dat_acq$nrSpeakersDaily <- as.numeric(scale(dat_acq$nrSpeakersDaily))
dat_acq$age <-as.numeric(scale(dat_acq$age))

# Manually setting the contrasts
contrasts(dat_acq$TestSpeaker) <- matrix(c(-0.5, 0.5), ncol = 1)
contrasts(dat_acq$Group) <- matrix(c(-0.5, 0.5), ncol = 1)


# Simulate some data for RECOGNITION--------------------------------------------------------------------
# create experimental design 
design <-
  fixed.factor("Group", levels=c("fam", "unfam")) +
  fixed.factor("TestSpeaker", levels=c("1", "2", "3")) +
  random.factor("Subj", groups="Group", instances=32)

dat_rec <- design.codes(design)

# define a sum contrast for data sim
dat_rec$Group_n <- ifelse(dat_rec$Group=="fam", +0.5, -0.5)
dat_rec$TestSpeaker_n = NA
for (i in 1:nrow(dat_rec)){
  if (dat_rec$TestSpeaker[i]== "1"){
    dat_rec$TestSpeaker_n[i] = +0.5
  }else if (dat_rec$TestSpeaker[i]== "2"){
    dat_rec$TestSpeaker_n[i] = 0
  }else{
    dat_rec$TestSpeaker_n[i] = -0.5
  }
}

# simulate data
dat_rec$MMR <- 5 +                  # The mean of the MMR for all groups together = 5
  5*dat_rec$TestSpeaker_n +         # Adding an effect of 5 on TestSpeaker
  5*dat_rec$Group_n +               # Adding an effect of 5 on Group
  rnorm(nrow(dat_rec),0,15)         # SD of 15

# now add dummy values for the other variables
dat_rec$mumDist = NA
dat_rec$nrSpeakersDaily = NA
dat_rec$sleepState = NA
dat_rec$age = NA

dat_rec$age = rep(abs(round(rnorm(nrow(dat_rec)/3,90,12))), each=3)
dat_rec$mumDist = rep(abs(round(rnorm(nrow(dat_rec),1,2),digits=4)), each=1)
dat_rec$nrSpeakersDaily = rep(round(rtruncnorm(nrow(dat_rec)/3,a=1,b= Inf,4,2)), each=3) # truncate dist at 1 (since every child will hear at least one speaker in daily life)
dat_rec$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat_rec)/3, replace = TRUE), each=3)

dat_rec = subset(dat_rec, select = -c(Group_n, TestSpeaker_n)) # remove these "contrast coding columns" because we only use them for data simulation

dat_rec$sleepState = as.factor(dat_rec$sleepState)

# Center and scale
dat_rec$mumDist <- as.numeric(scale(dat_rec$mumDist))
dat_rec$nrSpeakersDaily <- as.numeric(scale(dat_rec$nrSpeakersDaily))
dat_rec$age <- as.numeric(scale(dat_rec$age))

# Manually setting the contrasts
contrasts(dat_rec$TestSpeaker) <- matrix(c(-2/3, 1/3, 1/3,
                                              1/3, -2/3, 1/3), 
                                            ncol = 2, byrow = TRUE)
contrasts(dat_rec$Group) <- matrix(c(-0.5, 0.5), ncol = 1)

rm(design)

## Checking the data -----------------------------------------------------------------------------------------------
# mean and sd
mean(dat_acq$MMR)
sd(dat_acq$MMR)

# effect of Group
testdatfam = subset(dat_acq, Group == "fam")
testdatunfam = subset(dat_acq, Group == "unfam")
mean(testdatfam$MMR) - mean(testdatunfam$MMR)

# effect of TestSpeaker
testdat1 = subset(dat_acq, TestSpeaker == "1")
testdat2 = subset(dat_acq, TestSpeaker == "2")
mean(testdat1$MMR) - mean(testdat2$MMR)

# Plotting
plot(density(dat_acq$MMR),
     main="Simulated data ACQ",xlab="MMR")

ggplot(aes(x = MMR, y = age, color = TestSpeaker), data = dat_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(x = MMR, y = nrSpeakersDaily), data = dat_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(x = MMR, y = age, color = Group), data = dat_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(x = MMR, y = mumDist, color = TestSpeaker), data = dat_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(x = MMR, y = Group, color = TestSpeaker), data = dat_acq) +
  geom_boxplot()

ggplot(aes(x = MMR, y = Group), data = dat_acq) +
  geom_boxplot() 


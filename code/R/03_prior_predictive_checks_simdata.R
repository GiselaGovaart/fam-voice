# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(brms)


# Set priors ------------------------------------------------------------
# priors 0.4 Hz filter
priors_acq_low <- c(set_prior("normal(5.94, 20.52)",  
                              class = "Intercept"),
                    set_prior("normal(0, 20.52)",  
                              class = "b"),
                    set_prior("normal(0, 20.52)",  
                              class = "sigma"))

priors_rec_low <- c(set_prior("normal(5.97, 23.34)",  
                              class = "Intercept"),
                    set_prior("normal(0, 23.34)",  
                              class = "b"),
                    set_prior("normal(0, 23.34)",  
                              class = "sigma")) 
# priors 1 Hz filter

#### add


## Checks for now with REC data:
# Prior predictive checks WITHOUT covariates --------------------------------------------------------------------
pm1 <- brm(MMR ~ 1 + Group * TestSpeaker + (1 | Subj), data = dat_rec,
           prior = priors_rec_low,
           iter = 2000, chains = 4,family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))
pp <- posterior_predict(pm1) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp), breaks = 20)
# distribution of the effect of TestSpeaker
TestSpeakerEffect <- colMeans(pp[dat$TestSpeaker=="1",]) - colMeans(pp[dat$TestSpeaker=="2",])
hist(TestSpeakerEffect, breaks = 20)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat$Group=="fam",]) - colMeans(pp[dat$Group=="unfam",])
hist(GroupEffect)

# This looks good, we see that in the distribution of the mean MMR, the value that is most often found is between 0-10, and our priors said that 
# the mean is 6 The SD also looks fine. Actually, this distribution looks a lot like the histogram for the actual pilot MMR data:
plot(hist(data_pilot_rec_low$MMR),
     main="Pilot data REC low",xlab="MMR")
hist(colMeans(pp), breaks = 10)
# The effect of TestSpeaker (simulated as 5) does not seem to be retrieved
# The non-effect of Group is retrieved

# Prior predictive checks WITH covariates --------------------------------------------------------------------
pm2 <- brm(MMR ~ 1 + TestSpeaker * Group + 
             mumDistTrainS * TestSpeaker + 
             mumDistNovelS * TestSpeaker + 
             timeVoiceFam * Group +
             nrSpeakersDaily + 
             sleepState + 
             (1 + TestSpeaker * Group | Subj),
           data = dat_rec,
           prior = priors_rec_low,
           iter = 2000, chains = 4,
           family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))

pp <- posterior_predict(pm2) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp), breaks = 40)
# distribution of the effect of TestSpeaker
TestSpeakerEffect <- colMeans(pp[dat$TestSpeaker=="1",]) - colMeans(pp[dat$TestSpeaker=="2",])
hist(TestSpeakerEffect, breaks = 20)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat$Group=="fam",]) - colMeans(pp[dat$Group=="unfam",])
hist(GroupEffect)

# We see that in the distribution of the mean MMR, the value that is most often found is between 0-10, and our priors said that 
# the mean is 6 The SD also looks fine. Actually, this distribution looks a lot like the histogram for the actual pilot MMR data:
plot(hist(data_pilot_rec_low$MMR),
     main="Pilot data",xlab="MMR")
hist(colMeans(pp), breaks = 20)

# The effect of TestSpeaker (simulated as 5) does not seem to be retrieved --> no, because it this data, it's not there! It's only there for the ACQ data
# The non-effect of Group is retrieved

# --> We see that adding covariates to this check does not change the results





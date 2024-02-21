# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(brms)


# Set priors ------------------------------------------------------------
# priors 0.4 Hz filter
priors <- c(set_prior("normal(2.92, 14)", 
                      class = "Intercept"),
            set_prior("normal(0, 14)", 
                      class = "b"),
            set_prior("normal(0, 14)", 
                      class = "sigma")) 

# priors 1 Hz filter


# Prior predictive checks WITHOUT covariates --------------------------------------------------------------------
pm1 <- brm(MMR ~ 1 + Group * TestSpeaker + (1 | Subj), data = dat,
           prior = priors,
           iter = 2000, chains = 4,family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))
pp <- posterior_predict(pm1) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp), breaks = 40)
# distribution of the effect of TestSpeaker
TestSpeakerEffect <- colMeans(pp[dat$TestSpeaker=="1",]) - colMeans(pp[dat$TestSpeaker=="2",])
hist(TestSpeakerEffect, breaks = 40)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat$Group=="fam",]) - colMeans(pp[dat$Group=="unfam",])
hist(GroupEffect)

# This looks good, we see that in the distribution of the mean MMR, the value that is most often found is between 0-5, and our priors said that 
# the mean is 2.92. The SD also looks fine. Actually, this distribution looks a lot like the histogram for the actual pilot MMR data:
plot(hist(data_pilot$MMR),
     main="Pilot data",xlab="MMR")
# also, the effect of TestSpeaker (simulated as 5) seems to be retrieved, and the non-effect of Group is also retrieved

# Prior predictive checks WITH covariates --------------------------------------------------------------------
pm2 <- brm(MMR ~ 1 + TestSpeaker * Group + 
             mumDistTrainS * TestSpeaker + 
             mumDistNovelS * TestSpeaker + 
             timeVoiceFam * TestSpeaker * Group +
             nrSpeakersDaily * TestSpeaker * Group + 
             sleepState * TestSpeaker * Group + 
             (1 | Subj) + (1 | TestSpeaker:Group),
           data = dat,
           prior = priors,
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
hist(TestSpeakerEffect, breaks = 40)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat$Group=="fam",]) - colMeans(pp[dat$Group=="unfam",])
hist(GroupEffect)

# This looks good, we see that in the distribution of the mean MMR, the value that is most often found is between 0-5, and our priors said that 
# the mean is 2.92. The SD also looks fine. Actually, this distribution looks a lot like the histogram for the actual pilot MMR data:
plot(hist(data_pilot$MMR),
     main="Pilot data",xlab="MMR")
# also, the effect of TestSpeaker (simulated as 5) seems to be more or less retrieved, and the non-effect of Group is also retrieved

# --> we see that adding covariates to this check does not really change the results.





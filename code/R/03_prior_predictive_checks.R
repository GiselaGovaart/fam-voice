# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(brms)
library(here)

# Set priors ------------------------------------------------------------
priors <- c(set_prior("normal(3.5, 20)", 
                      class = "Intercept"),
            set_prior("normal(0, 20)",  
                      class = "b"),
            set_prior("normal(0, 20)",  
                      class = "sigma")) 
# Set up sampling ------------------------------------------------------------
num_chains <- 4 
num_iter <- 4000 
num_warmup <- num_iter / 2 
num_thin <- 1 

## ACQUISITION
# Prior predictive checks  --------------------------------------------------------------------
priorpredcheck_acq_m <- brm(MMR ~ 1 + TestSpeaker * Group + 
                              mumDist +
                              nrSpeakersDaily  + 
                              sleepState + 
                              age +
                              (1 + TestSpeaker | Subj),
                            data = dat_acq,
                            prior = priors,
                            family = gaussian(),
                            control = list(
                              adapt_delta = .99, 
                              max_treedepth = 15
                            ),
                            iter = num_iter, 
                            chains = num_chains, 
                            warmup = num_warmup,
                            thin = num_thin,
                            cores = num_chains, 
                            seed = project_seed,
                            file = here("data", "model_output", "03_model_priorpredcheck_acq.rds"),
                            file_refit = "on_change",
                            save_pars = save_pars(all = TRUE),
                            sample_prior = "only"
)

pp <- posterior_predict(priorpredcheck_acq_m) 
pp <- t(pp)
# distribution of mean MMR
meanMMR = colMeans(pp)
hist(meanMMR, breaks = 40)
# distribution of the effect of TestSpeaker
TestSpeakerEffect <- colMeans(pp[dat_acq$TestSpeaker=="1",]) - colMeans(pp[dat_acq$TestSpeaker=="2",])
hist(TestSpeakerEffect, breaks = 40)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat_acq$Group=="fam",]) - colMeans(pp[dat_acq$Group=="unfam",])
hist(GroupEffect, breaks = 40)

## RECOGNITION
# Prior predictive checks  --------------------------------------------------------------------
priorpredcheck_rec_m <- brm(MMR ~ 1 + TestSpeaker * Group + 
                              mumDist +
                              nrSpeakersDaily  + 
                              sleepState + 
                              age +
                              (1 + TestSpeaker | Subj),
                            data = dat_rec,
                            prior = priors,
                            family = gaussian(),
                            control = list(
                              adapt_delta = .99, 
                              max_treedepth = 15
                            ),
                            iter = num_iter, 
                            chains = num_chains, 
                            warmup = num_warmup,
                            thin = num_thin,
                            cores = num_chains, 
                            seed = project_seed,
                            file = here("data", "model_output", "03_model_priorpredcheck_rec.rds"),
                            file_refit = "on_change",
                            save_pars = save_pars(all = TRUE),
                            sample_prior = "only"
)

pp <- posterior_predict(priorpredcheck_rec_m) 
pp <- t(pp)
# distribution of mean MMR
meanMMR = colMeans(pp)
hist(meanMMR, breaks = 40)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat_rec$Group=="fam",]) - colMeans(pp[dat_rec$Group=="unfam",])
hist(GroupEffect, breaks = 40)


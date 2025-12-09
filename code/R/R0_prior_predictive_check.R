# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(brms)
library(here)

# Set priors ------------------------------------------------------------
priors <- c(set_prior("normal(3.5, 20)",  
                      class = "Intercept"),
            set_prior("normal(0, 10)",  
                      class = "b"),
            set_prior("normal(0, 20)",  
                      class = "sigma"))

# Set up sampling ------------------------------------------------------------
num_chains <- 4 
num_iter <- 4000 
num_warmup <- num_iter / 2 
num_thin <- 1 

priorpredcheck_rec <- brm(MMR ~ 1 + TestSpeaker * Group + 
                            mumDist +
                            nrSpeakersDaily  + 
                            sleepState + 
                            age +
                            (1 + TestSpeaker | Subj),
                          data = data_rec,
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
                          file = here("data", "model_output", "R0_model_priorpredcheck_rec.rds"),
                          file_refit = "on_change",
                          save_pars = save_pars(all = TRUE),
                          sample_prior = "only"
)

pp <- posterior_predict(priorpredcheck_rec) 
pp <- t(pp)
# distribution of mean MMR
meanMMR = colMeans(pp)
hist(meanMMR, breaks = 40)
# distribution of the effect of TestSpeaker
TestSpeakerEffect <- colMeans(pp[data_rec$TestSpeaker=="S1",]) - colMeans(pp[data_rec$TestSpeaker=="S4",])
hist(TestSpeakerEffect, breaks = 40)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[data_rec$Group=="fam",]) - colMeans(pp[data_rec$Group=="unfam",])
hist(GroupEffect, breaks = 40)

summary(priorpredcheck_rec)


##### Testing contr.equalprior_pairs

# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------

library(here)
library(tidyverse)
library(brms)

# set vars --------------------------------------------------------------------
num_chains <- 4 # number of chains = number of processor cores
num_iter <- 4000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain


# only setting contrasts(dat_rec$TestSpeaker) <- contr.equalprior_pairs AFTER running the model,
# i.e. for sampling the priors.
#m1
rec_MMR_m_prior_orig <- unupdate(MMR_m_rec) # sample priors from model

(pairs_bayes_orig <- pairs(emmeans(rec_MMR_m_prior_orig, ~TestSpeaker)))

ggplot(stack(insight::get_parameters(pairs_bayes_orig)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values without contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")

#m2
contrasts(dat_rec$TestSpeaker) <- contr.equalprior_pairs

rec_MMR_m_prior_contr <- unupdate(MMR_m_rec) # sample priors from model

(pairs_bayes_contr <- pairs(emmeans(rec_MMR_m_prior_contr, ~TestSpeaker)))

ggplot(stack(insight::get_parameters(pairs_bayes_contr)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values with contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")



#  setting contrasts(dat_rec$TestSpeaker) <- contr.equalprior_pairs BEFORE running the model
# --> only this has the desired effect.
# m1
modelMMR_rec_orig <-
  brm(MMR ~ 1 + TestSpeaker * Group + 
        mumDistTrainS * TestSpeaker + 
        mumDistNovelS * TestSpeaker + 
        timeVoiceFam * TestSpeaker * Group +
        nrSpeakersDaily * TestSpeaker * Group + 
        (1 | Subj) + (1 | TestSpeaker*Group),  # or: (1 + TestSpeaker * Group | Subj)
      data = dat_rec,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors,
      sample_prior = "only", # sample priors
      init = "random",
      # Init = random: the initial value of the MonteCarloChain. Random means that your 4 chains all 
      # start from  different value. If you start from 4 different values and they all converge to same 
      # param space, you can be quite sure that’s the good one!
      # You could also put 0, and start each chain at 0. Why? For computational efficiency. Because your know
      # that for your data, it does not make sense te start eg at -2. 
      control = list(
        adapt_delta = .99, 
        max_treedepth = 15
        # These are the parameters of the algorithms. We adapt to make the model more precise but less fast
      ),
      chains = num_chains,
      iter = num_iter,
      warmup = num_warmup,
      thin = num_thin,
      algorithm = "sampling", 
      cores = num_chains, # you want to use one core per chain, so keep same value as num_chains here
      seed = project_seed,
      file = here("data", "model_output", "samples_MMR_rec.rds"),
      file_refit = "on_change" 
  )

(pairs_bayes_orig <- pairs(emmeans(modelMMR_rec_orig, ~TestSpeaker)))

ggplot(stack(insight::get_parameters(pairs_bayes_orig)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values without contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")


# m2
contrasts(dat_rec$TestSpeaker) <- contr.equalprior_pairs

modelMMR_rec_contr <-
  brm(MMR ~ 1 + TestSpeaker * Group + 
        mumDistTrainS * TestSpeaker + 
        mumDistNovelS * TestSpeaker + 
        timeVoiceFam * TestSpeaker * Group +
        nrSpeakersDaily * TestSpeaker * Group + 
        (1 | Subj) + (1 | TestSpeaker*Group),  # or: (1 + TestSpeaker * Group | Subj)
      data = dat_rec,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors,
      sample_prior = "only", # sample priors
      init = "random",
      # Init = random: the initial value of the MonteCarloChain. Random means that your 4 chains all 
      # start from  different value. If you start from 4 different values and they all converge to same 
      # param space, you can be quite sure that’s the good one!
      # You could also put 0, and start each chain at 0. Why? For computational efficiency. Because your know
      # that for your data, it does not make sense te start eg at -2. 
      control = list(
        adapt_delta = .99, 
        max_treedepth = 15
        # These are the parameters of the algorithms. We adapt to make the model more precise but less fast
      ),
      chains = num_chains,
      iter = num_iter,
      warmup = num_warmup,
      thin = num_thin,
      algorithm = "sampling", 
      cores = num_chains, # you want to use one core per chain, so keep same value as num_chains here
      seed = project_seed,
      file = here("data", "model_output", "samples_MMR_rec.rds"),
      file_refit = "on_change" 
  )


(pairs_bayes_contr <- pairs(emmeans(modelMMR_rec_contr, ~TestSpeaker)))
ggplot(stack(insight::get_parameters(pairs_bayes_contr)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values with contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")














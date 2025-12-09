# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(easystats)

# setup: STAN --------------------------------------------------------------------
# here we set up the sampling. 
# num_chains:  how many processor cores you want to run in parallel (always leave some of your computer's processors unused!)
# num_warmup: the warmup samples are those samples that are at the beginning of the chain that
# you want to discard. You do that, because at the beginning, the algorithm is still figuring
# out what the parameter space is, and therefore these samples might contain bad parameters.
# So you just get rid of the first couple of them to make sure you only end up with good ones
# (and you get the pretty fat hairy caterpillar, which you will check in your model diagnostics)
# num_thin: if that’s 2, you only take every second sample. Because it’s possible that there
# is high auto-correlation in the samples, and then you’d want to get rid of it. Usually 
# it’s not a problem, it’s taken care of by the warm up too. So it’s fine to take 1.

num_chains <- 4 # number of chains = number of processor cores
num_iter <- 80000 # number of samples per chain: because I use Savage-Dickey for hypothesis testing, so we need a LOT of samples
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain

# load data  --------------------------------------------------------------------
# I need this hack because otherwise it does not find the codebooks
# setwd(here("data"))
# load_data()
# setwd(here())

# Set priors ------------------------------------------------------------
priors <- c(set_prior("normal(3.5, 20)", 
                      class = "Intercept"),
            set_prior("normal(0, 10)",  
                      class = "b"),
            set_prior("normal(0, 20)",  
                      class = "sigma")) 

# Run the model ------------------------------------------------------
model_acq = brm(MMR ~ 1 + TestSpeaker * Group +
        mumDist +
        nrSpeakersDaily +
        sleepState +
        age +
        (1 + TestSpeaker | Subj),
      data = data_acq,
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
      file = here("data", "model_output", "A2_model_acq.rds"),
      file_refit = "on_change",
      save_pars = save_pars(all = TRUE)
  )


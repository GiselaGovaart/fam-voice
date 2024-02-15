
# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# install packages --------------------------------------------------------------------

# install.packages("here")
# install.packages("tidyverse")
# install.packages("brms")

# load packages --------------------------------------------------------------------

library(here)
library(tidyverse)
library(brms)



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
num_iter <- 4000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain


# load data  --------------------------------------------------------------------
# I need this weird hack because otherwise it does not find the codebooks
# setwd(here("data"))
# load_data()
# setwd(here())

# centering the covariates -----------------------------------------------------
# (dat <- dat %>%
#     mutate(mumDistTrainS = mumDistTrainS - mean(mumDistTrainS)))
# (dat <- dat %>%
#     mutate(mumDistNovelS = mumDistNovelS - mean(mumDistNovelS)))
# (dat <- dat %>%
#     mutate(timeVoiceFam = timeVoiceFam - mean(timeVoiceFam)))
# (dat <- dat %>%
#     mutate(nrSpeakersDaily = nrSpeakersDaily - mean(nrSpeakersDaily)))
# # same:
# dat$mumDistTrainS_centered <- scale(dat$mumDistTrainS, scale = FALSE)
# dat$mumDistNovelS_centered <- scale(dat$mumDistNovelS, scale = FALSE)
# dat$timeVoiceFam_centered <- scale(dat$timeVoiceFam, scale = FALSE)
# dat$nrSpeakersDaily_centered <- scale(dat$nrSpeakersDaily, scale = FALSE)

# Center and scale: this subtracts the mean from each value and then divides by the SD
dat$mumDistTrainS <- scale(dat$mumDistTrainS)
dat$mumDistNovelS <- scale(dat$mumDistNovelS)
dat$timeVoiceFam <- scale(dat$timeVoiceFam)
dat$nrSpeakersDaily <- scale(dat$nrSpeakersDaily)

dat_rec$mumDistTrainS <- scale(dat_rec$mumDistTrainS)
dat_rec$mumDistNovelS <- scale(dat_rec$mumDistNovelS)
dat_rec$timeVoiceFam <- scale(dat_rec$timeVoiceFam)
dat_rec$nrSpeakersDaily <- scale(dat_rec$nrSpeakersDaily)


# Before we enter the continuous IQ variable, we center it, by subtracting its mean. Centering covariates is generally good practice. Moreover, it is often important to  
# z -transform the covariate, i.e., to not only subtract the mean, but also to divide by its standard deviation (this can be done as follows: df_contrasts5$IQ.s <- scale(df_contrasts5$IQ)). 
# The reason why this is often important is that the sampler doesn’t work well if predictors have different scales. For the simple models we use here, the sampler works without  
# z -transformation. However, for more realistic and more complex models,  
# z -transformation of covariates is often very important.
# https://vasishth.github.io/bayescogsci/book/ch-coding2x2.html

# Set priors ------------------------------------------------------------
# priors 0.4 Hz filter
priors <- c(set_prior("normal(2.92, 14)", 
                      class = "Intercept"),
            set_prior("normal(0, 14)", 
                      class = "b"),
            set_prior("normal(0, 14)", 
                      class = "sigma")) 

# priors 1 Hz filter



# Setting up contrasts for during the model fitting -------------
# not necessary??


# sampling --------------------------------------------------------------------

modelMMR <-
  brm(MMR ~ 1 + TestSpeaker * Group + 
        mumDistTrainS * TestSpeaker + 
        mumDistNovelS * TestSpeaker + 
        timeVoiceFam * TestSpeaker * Group +
        nrSpeakersDaily * TestSpeaker * Group + 
        (1 | Subj) + (1 | TestSpeaker*Group),  # or: (1 + TestSpeaker * Group | Subj)
      data = dat,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors,
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
      file = here("data", "model_output", "samples_MMR.rds"),
      file_refit = "on_change" 
  )

modelMMRtestcovs <-
  brm(MMR ~ 1 + TestSpeaker * Group + 
        mumDistTrainS+ 
        mumDistNovelS + 
        timeVoiceFam  +
        nrSpeakersDaily + 
        (1 | Subj) + (1 | TestSpeaker*Group),  # or: (1 + TestSpeaker * Group | Subj)
      data = dat,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors,
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
      file = here("data", "model_output", "samples_MMR_testcovs.rds"),
      file_refit = "on_change" 
  )

# NB the values of your parameter space are the values of your posterior distribution! MCC just gives you your
# posterior distribution.
# You have several posterior distributions, for each fixed effect, and for each random effect. 
# For each effect that you’d in a frequentist framework get a p-value, you here get a distribution.


modelMMR_nested <-
  brm(MMR ~ 1 + TestSpeaker / Group + 
        mumDistTrainS * TestSpeaker + 
        mumDistNovelS * TestSpeaker + 
        timeVoiceFam * TestSpeaker * Group +
        nrSpeakersDaily * TestSpeaker * Group + 
        (1 | Subj) + (1 | TestSpeaker/Group),  # or: (1 + TestSpeaker * Group | Subj)
      data = dat,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors,
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
      file = here("data", "model_output", "samples_MMR_nested.rds"),
      file_refit = "on_change"
  )


# model REC

modelMMR_rec <-
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

modelMMR_rec_sleep <-
  brm(MMR ~ 1 + TestSpeaker * Group + 
        mumDistTrainS * TestSpeaker + 
        mumDistNovelS * TestSpeaker + 
        timeVoiceFam * TestSpeaker * Group +
        nrSpeakersDaily * TestSpeaker * Group + 
        sleepState +
        (1 | Subj) + (1 | TestSpeaker*Group),  # or: (1 + TestSpeaker * Group | Subj)
      data = dat_rec,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors,
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
      file = here("data", "model_output", "samples_MMR_rec_sleep.rds"),
      file_refit = "on_change" 
  )


# END  --------------------------------------------------------------------







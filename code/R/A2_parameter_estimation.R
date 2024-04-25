
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
num_iter <- 4000 # number of samples per chain: because I use Savage-Dickey for hypothesis testing, we probably need to set this nr way up. We now have 8000, we might need to go up to 40.000
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
dat$mumDist<- scale(dat$mumDist)
dat$age <- scale(dat$age)
dat$nrSpeakersDaily <- scale(dat$nrSpeakersDaily)

dat_rec$mumDist<- scale(dat_rec$mumDist)
dat_rec$age <- scale(dat_rec$age)
dat_rec$nrSpeakersDaily <- scale(dat_rec$nrSpeakersDaily)


# Centering covariates is generally good practice. Moreover, it is often important to  
# z -transform the covariate, i.e., to not only subtract the mean, but also to divide by its standard deviation. 
# The reason why this is often important is that the sampler doesn’t work well if predictors have different scales. 
# For the simple models we use here, the sampler works without  
# z -transformation. However, for more realistic and more complex models,  
# z -transformation of covariates is often very important.
# https://vasishth.github.io/bayescogsci/book/ch-coding2x2.html

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



# Setting up contrasts for during the model fitting -------------
# not necessary??
contrasts(dat_acq$TestSpeaker) <- contr.equalprior
contrasts(dat_acq$Group) <- contr.equalprior
contrasts(dat_acq$sleepState) <- contr.equalprior

contrasts(dat_rec$TestSpeaker) <- contr.equalprior
contrasts(dat_rec$Group) <- contr.equalprior
contrasts(dat_rec$sleepState) <- contr.equalprior


## Add that in the  analysis. we will try whether TestSpeaker * Group | Subj converges


# sampling --------------------------------------------------------------------
### Model ACQUISITION
model_acq <-
  brm(MMR ~ 1 + TestSpeaker * Group + 
        mumDist +
        nrSpeakersDaily  + 
        sleepState + 
        age +
        (1 + TestSpeaker | Subj),
      data = dat_acq,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors_acq,
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
      file = here("data", "model_output", "A2_parameter_estimation_acq.rds"),
      file_refit = "on_change",
      save_pars = save_pars(all = TRUE)
  )

### Model RECOGNITION
model_rec <-
  brm(MMR ~ 1 + TestSpeaker * Group + 
        mumDist  + 
        nrSpeakersDaily +
        sleepState +
        age +
        (1 + TestSpeaker * Group | Subj),
      data = dat_rec,
      family = gaussian(), # the likelihood of the data that you are given to the model. 
      # Here you say you expect the data to have a normal distribution.
      # I can check that in my pilot data.
      prior = priors_rec_low,
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
      file = here("data", "model_output", "samples_MMR_rec_orig.rds"),
      file_refit = "on_change",      
      save_pars = save_pars(all = TRUE)
  )


# END  --------------------------------------------------------------------

# Convergence problems:
#  Does not converge:
# (1 + TestSpeaker * Group | Subj) 
# (1 + TestSpeaker * Group || Subj) 

# Does converge:
# (1| Subj) + (1 | TestSpeaker * Group) --> but why did I ever choose this?
# (1 + TestSpeaker + Group | Subj) 
# when taking out the correlations of mumDistTrainS * TestSpeaker, mumDistNovelS * TestSpeaker, and TimeVoiceFam * Group, and  (1 + TestSpeaker * Group | Subj),
# This last one also works when including age


MMR_m <- readRDS(here("data", "model_output", "samples_MMR_rec.rds"))
MCMC_MMR_m <-
  plot(MMR_m, ask = FALSE) 




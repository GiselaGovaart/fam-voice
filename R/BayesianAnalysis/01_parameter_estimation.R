
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


# priors  --------------------------------------------------------------------

priors <-
  c(
    prior("normal(0, 10)", class = "b") # weakly informative prior on intercept & slopes: b stand for beta
  )
# here, A only sets a prior for the intercept and slopes. It's a prior that assumes a normal
# distribution centered around 0, with an SD of 10 microvolt.
# The priors for the random effects are thus just the default priors from brms (you need 
# priors for all the parameters, otherwise the model does not run). 
# Weakly informative means you might not know what you expect exactly, 
# but you know what you do NOT expect.

# I can set an informative prior, based on my pilot. I just take all of the amplitude values of my pilot, 
# and then plot the distribution of those values. I would then make that prior a bit broader 
# (= increase the SD), such that I do not exclude informative values 


# load data  --------------------------------------------------------------------

load(here("data", "preprocessed", "P3_mean.RData"))

# sampling: P3, mean amplitude --------------------------------------------------------------------

P3_m <-
  brm(
    Amplitude ~ 1 + Valence * Expectancy + (1 + Valence * Expectancy | Laboratory / Subject),
    # Random: we want both lab and subject varying for our fixed effects 
    # / means that subject is nested in lab
    data = P3_mean,
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
    # I will take random.
      control = list(
      adapt_delta = .99, 
      max_treedepth = 15
      # These are the parameters of the algorithms. Here A changed the default values (to make more precise but less fast).
      # Check which ones are possible!
    ),
    chains = num_chains,
    iter = num_iter,
    warmup = num_warmup,
    thin = num_thin,
    algorithm = "sampling", 
    # we use the NoUTurn algorithm. Because it's efficient. 
    # but check ?brm, because there is now also brms.algorithm, maybe that's better?
    cores = num_chains, # you want to use one core per chain, so keep same value as num_chains here
    seed = project_seed,
    file = here("data", "model_output", "samples_P3_mean.rds"),
    file_refit = "on_change"
  )

# NB the values of your parameter space are the values of your posterior distribution! MCC just gives you your
# posterior distribution.
# You have several posterior distributions, for teach fixed effect, and for each random effect. 
# For each effect that you’d in a frequentist framework get a p-value, you here get a distribution.


# END  --------------------------------------------------------------------

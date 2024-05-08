# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(easystats) # Small tidyverse only for stats
library(bayesplot)
library(viridis) # just a color palette
library(corrplot)

# cividis color palette for bayesplot
#color_scheme_set("viridisE")

# load and prepare data --------------------------------------------------------------------
dat_acq <-
  dat_acq %>%
  unite( # unite columns for posterior predictive checks
    # unites the two columns TestSpeaker and Group Because brms made a posterior distribution
    # with TestSpeaker_Group, because it looks at an interaction. 
    "TestSpeaker_Group",
    c("TestSpeaker", "Group"),
    sep = "_",
    remove = FALSE,
    na.rm = FALSE
  ) %>%
  select(Subj, TestSpeaker_Group, TestSpeaker, Group, MMR)

# results of model fit
model_acq <- readRDS(here("data", "model_output", "A2_model_acq.rds"))

# model diagnostics: trace plots of MCMC draws --------------------------------------------------------
# these are the caterpillar plots. It gives you a caterpillar for each effect
# it takes that samples that were shown in ESS
# Here you have all your samples (the ones from ESS). 
MCMC_model_acq <-
  plot(model_acq, ask = FALSE) 

# here you get only the density plots without the caterpillars. and you can specify which ones
mcmc_dens(model_acq, pars = variables(MMR_m)[1:9])

# model diagnostics: posterior predictive checks --------------------------------------------------------
# If you extract the post pred samples from your posterior distributions 
# “predictive”: this is the range of values that you would expect if you run the exp very often.
# The yellow stuff: the sampling points. The violet line: the actual value you observed (the 
# mean). The purple line should be in the middle of the distribution (this is a check for your model.)
# Here we get a normal distr for the fixed effects. That’s good, because you expected that.
# For the random effects, these are always standard deviations, so they cannot go below 0, 
# so they will not be a normal distr. That’s okay, because we did not set the prior for the 
# random effects, so it was set by default, and this is an exponential distribution. 
# You need to check that in your data.

# posterior samples of the posterior predictive distribution
# you need the posterior distribution to compute with, so you need to still extract this information
# before, we only had summaries
posterior_predict_model_acq <-
  model_acq %>%
  posterior_predict(ndraws = 2000) # 2000 samples per observation
# We get a dataframe of size 2000:128, because there were 128 observations. 
# And now we have for each observation a distribution with 2000 sampling points!

PPC_MMR_m <-
  posterior_predict_model_acq %>%
  ppc_stat_grouped(
    y = pull(dat_exp_acq, MMR),
    group = pull(dat_exp_acq, TestSpeaker_Group),
    stat = "mean"
  ) +
  ggtitle("Posterior predictive samples")

PPC_MMR_m

# model performance: Bayesian R2 --------------------------------------------------------

# Conditional R2 takes into account both fixed and random effects
# Marginal R2 only considers the variance of the fixed effects (without the random effects)
R2_MMR_m <- r2(MMR_m)
R2_MMR_m
# If marginal is very low, that means if you only look at the fixed effects, your model 
# does not explain a lot of your data. 
# You would always expect marginal to be lower than Conditional, but not so much lower.
# R2 goes from 0-1, the higher, the better, shows how much you data is explaining. The diffference between 
# conditional and marginal is small in my simdata, which is good: it means that the random stuff is not explaining everyhing. 
# It does not tell us much, so we leave it out

# summary of posterior distributions of model parameters + model diagnostics: Rhat --------------------------------------------------------
# This is just a nice and fast way to create your table for the paper.
params_model_acq <-
  model_parameters(
    model_acq,
    centrality = "mean",
    # do we care about the mean or the median? Since we know that the posterior distributions are normal, 
    # we want the mean. If during the post pred checks you see that it’s not normal, you might wanna use “median”
    dispersion = TRUE, # This just tells you that it will show the column sd. 
    ci = .95,
    ci_method = "eti",
    test = NULL,
    diagnostic = c("Rhat", "ESS"), # options: "ESS", "Rhat", "MCSE", "all". 
    effects = "fixed" # options: "fixed", "random", "all". 
  )

params_model_acq

# save as .RData (compressed)
save(
  params_model_acq,
  file = here("data", "model_output", "params_model_acq.RData")
)


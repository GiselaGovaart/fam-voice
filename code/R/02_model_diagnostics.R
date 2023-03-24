
# RNG --------------------------------------------------------

project_seed <- 2049
set.seed(project_seed) # set seed

# install packages --------------------------------------------------------------------

# install.packages("here")
# install.packages("tidyverse")
# install.packages("brms")
# install.packages("easystats")
# install.packages("bayesplot")
# install.packages("viridis")

# load packages --------------------------------------------------------------------

library(here)
library(tidyverse)
library(brms)
library(easystats) # Small tidyverse only for stats
library(bayesplot)
library(viridis) # just a color palette

# setup: plots --------------------------------------------------------------------

# custom ggplot theme
source(here("code", "functions", "custom_ggplot_theme.R"))

# cividis color palette for bayesplot
color_scheme_set("viridisE")

# load and prepare data --------------------------------------------------------------------

# ERP data
load(here("data", "preprocessed", "P3_mean.RData"))

P3_mean <-
  P3_mean %>%
  unite( # unite columns for posterior predictive checks
    # unites the two columns valence and expectancy. Because brms made a posterior distribution
    # with Valuence_Expectancy, because it looks at an interaction. 
    # And you need to be able to compare
    "Valence_Expectancy",
    c("Valence", "Expectancy"),
    sep = "_",
    remove = FALSE,
    na.rm = FALSE
  ) %>%
  select(Laboratory, Subject, Valence_Expectancy, Valence, Expectancy, Amplitude)

# results of model fit
# for notes on the output, see notes in Notes_meeting_Antonio_20221216.docx
P3_m <- readRDS(here("data", "model_output", "samples_P3_mean.rds"))


# posterior samples of the posterior predictive distribution
# you need the posterior distribution to compute with, so you need to still extract this information
# before, we only had summaries
posterior_predict_P3_m <-
  P3_m %>%
  posterior_predict(ndraws = 2000) # 2000 samples per observation
# We get a dataframe of size 2000:986, because there were 986 observations. 
# And now we have for each observation a distribution with 2000 sampling points!


# model diagnostics: trace plots of MCMC draws --------------------------------------------------------
# these are the caterpillar plots. It gives you a caterpillar for each effect
# it takes that samples that were shown in ESS
# Here you have all your samples (the ones from ESS). 
MCMC_P3_m <-
  plot(P3_m, ask = FALSE) +
  theme_custom

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

PPC_P3_m <-
  posterior_predict_P3_m %>%
  ppc_stat_grouped(
    y = pull(P3_mean, Amplitude),
    group = pull(P3_mean, Valence_Expectancy),
    stat = "mean"
  ) +
  ggtitle("Posterior predictive samples") +
  theme_custom

PPC_P3_m

# model performance: Bayesian R2 --------------------------------------------------------

# Conditional R2 takes into account both fixed and random effects
# Marginal R2 only considers the variance of the fixed effects (without the random effects)
R2_P3_m <- r2(P3_m)
R2_P3_m

# Here, marginal for Antonio was very low. That means if you only look at the fixed effects, your model 
# does not explain a lot of your data. In this case that’s fine, because very few datapoints 
# You would always expect marginal to be lower than Conditional, but not so much lower.

# summary of posterior distributions of model parameters + model diagnostics: Rhat --------------------------------------------------------
# This is just a nice and fast way to create your table for the paper.
params_P3_m <-
  model_parameters(
    P3_m,
    centrality = "mean",
    # do we care about the mean or the median? Since we know that the posterior distributions are normal, 
    # we want the mean. If during the post pred checks uyou see that it’s not normal, you might wanna use “median”
    dispersion = TRUE, # This just tells you that it will show the column sd. sd is measure of dispersion. 
    ci = .95,
    ci_method = "eti",
    test = NULL,
    diagnostic = "Rhat", # options: "ESS", "Rhat", "MCSE", "all". Rhat is enough
    effects = "fixed" # options: "fixed", "random", "all". You only need fixed.
  )

params_P3_m

# save as .RData (compressed)
save(
  params_P3_m,
  file = here("data", "model_output", "params_P3_m.RData")
)

# END --------------------------------------------------------

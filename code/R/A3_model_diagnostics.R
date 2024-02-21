
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
library(corrplot)


# cividis color palette for bayesplot
color_scheme_set("viridisE")

# load and prepare data --------------------------------------------------------------------

# ERP data
#load(here("data", "preprocessed", "P3_mean.RData"))

dat <-
  dat %>%
  unite( # unite columns for posterior predictive checks
    # unites the two columns TestSpeaker and Group Because brms made a posterior distribution
    # with TestSpeaker_Group, because it looks at an interaction. 
    # And you need to be able to compare
    "TestSpeaker_Group",
    c("TestSpeaker", "Group"),
    sep = "_",
    remove = FALSE,
    na.rm = FALSE
  ) %>%
  select(Subj, TestSpeaker_Group, TestSpeaker, Group, MMR)

# results of model fit
MMR_m <- readRDS(here("data", "model_output", "samples_MMR.rds"))
# for notes on the output, see notes in Notes_meeting_Antonio_20221216.docx


# posterior samples of the posterior predictive distribution
# you need the posterior distribution to compute with, so you need to still extract this information
# before, we only had summaries
posterior_predict_MMR_m <-
  MMR_m %>%
  posterior_predict(ndraws = 2000) # 2000 samples per observation
# We get a dataframe of size 2000:986, because there were 986 observations. 
# And now we have for each observation a distribution with 2000 sampling points!


# model diagnostics: trace plots of MCMC draws --------------------------------------------------------
# these are the caterpillar plots. It gives you a caterpillar for each effect
# it takes that samples that were shown in ESS
# Here you have all your samples (the ones from ESS). 
MCMC_MMR_m <-
  plot(MMR_m, ask = FALSE) 

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

PPC_MMR_m <-
  posterior_predict_MMR_m %>%
  ppc_stat_grouped(
    y = pull(dat, MMR),
    group = pull(dat, TestSpeaker_Group),
    stat = "mean"
  ) +
  ggtitle("Posterior predictive samples")

PPC_MMR_m

# model performance: Bayesian R2 --------------------------------------------------------

# Conditional R2 takes into account both fixed and random effects
# Marginal R2 only considers the variance of the fixed effects (without the random effects)
R2_MMR_m <- r2(MMR_m)
R2_MMR_m
# Here, marginal for Antonio was very low. That means if you only look at the fixed effects, your model 
# does not explain a lot of your data. In this case that’s fine, because very few datapoints 
# You would always expect marginal to be lower than Conditional, but not so much lower.
# @A: which values are acceptable?

# summary of posterior distributions of model parameters + model diagnostics: Rhat --------------------------------------------------------
# This is just a nice and fast way to create your table for the paper.
params_MMR_m <-
  model_parameters(
    MMR_m,
    centrality = "mean",
    # do we care about the mean or the median? Since we know that the posterior distributions are normal, 
    # we want the mean. If during the post pred checks you see that it’s not normal, you might wanna use “median”
    dispersion = TRUE, # This just tells you that it will show the column sd. sd is measure of dispersion. 
    ci = .95,
    ci_method = "eti",
    test = NULL,
    diagnostic = c("Rhat", "ESS"), # options: "ESS", "Rhat", "MCSE", "all". Rhat is enough
    effects = "fixed" # options: "fixed", "random", "all". You only need fixed.
  )

params_MMR_m

# save as .RData (compressed)
save(
  params_MMR_m,
  file = here("data", "model_output", "params_MMR_m.RData")
)





# 8/2: look at whether you need to implement this: https://www.flutterbys.com.au/stats/tut/tut7.5b.html




# check for collinearity ----------------------------------------------
# Make correlation matrix
correlation_matrix <- cor(dat[, c("mumDistTrainS", "mumDistNovelS", "timeVoiceFam", "nrSpeakersDaily")])
print(correlation_matrix)
corrplot(correlation_matrix, method = "circle")
# check with in-built check_collinearity function --> 
# It calculates the variance inflation factors (VIF) for each covariate, 
# with values greater than 10 indicating potential collinearity issues.
collinearity_results <- check_collinearity(MMR_m)
print(collinearity_results)

# END --------------------------------------------------------

# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(easystats) # Small tidyverse only for stats
library(bayesplot)
library(corrplot)


## load and prepare data --------------------------------------------------------------------
data_recfam_modeldiag_n <-
  data_recfam_normal %>%
  select(Subj, TestSpeaker, MMR)

data_recfam_modeldiag_f <-
  data_recfam_frontal %>%
  select(Subj, TestSpeaker, MMR)

# results of model fit
model_recfam_n <- readRDS(here("data", "model_output", "Rfam2_model_recfam_normal.rds"))
model_recfam_f <- readRDS(here("data", "model_output", "Rfam2_model_recfam_frontal.rds"))

## model diagnostics: trace plots of MCMC draws --------------------------------------------------------
# these are the caterpillar plots. It gives you a caterpillar for each effect
# it takes that samples that were shown in ESS
# Here you have all your samples (the ones from ESS). 
# MCMC_model_rec <-
#  plot(model_rec, ask = FALSE) 
# Save
pdf(file = here("data", "model_output", "Rfam3_normal_modeldiagnostics_traceplots.pdf"),
    width = 12, height = 8)  
plot(model_recfam_n, ask = FALSE)
dev.off()

pdf(file = here("data", "model_output", "Rfam3_frontal_modeldiagnostics_traceplots.pdf"),
    width = 12, height = 8)  
plot(model_recfam_f, ask = FALSE)
dev.off()

# here you get only the density plots without the caterpillars. and you can specify which ones
#mcmc_dens(model_rec, pars = variables(model_rec)[1:9])

## model diagnostics: posterior predictive checks --------------------------------------------------------
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
posterior_predict_model_rec_n <-
  model_recfam_n %>%
  posterior_predict(ndraws = 2000) # 2000 samples per observation
# We get a dataframe of size 2000:128, because there were 128 observations. 
# And now we have for each observation a distribution with 2000 sampling points!
posterior_predict_model_rec_f <-
  model_recfam_f %>%
  posterior_predict(ndraws = 2000) 

PPS_rec_n <-
  posterior_predict_model_rec_n %>%
  ppc_stat_grouped(
    y = pull(data_recfam_modeldiag_n, MMR),
    group = pull(data_recfam_modeldiag_n, TestSpeaker),
    stat = "mean"
  ) +
  ggtitle("Posterior predictive samples")

PPS_rec_n
# Save
plot(PPS_rec_n)
png(file=here("data", "model_output", "Rfam3_modeldiagnostics_posteriorsamples_normal.png"),
    width=4500, height=3000,res=600)
plot(PPS_rec_n)
dev.off()

PPS_rec_f <-
  posterior_predict_model_rec_f %>%
  ppc_stat_grouped(
    y = pull(data_recfam_modeldiag_f, MMR),
    group = pull(data_recfam_modeldiag_f, TestSpeaker),
    stat = "mean"
  ) +
  ggtitle("Posterior predictive samples")

PPS_rec_f
# Save
plot(PPS_rec_f)
png(file=here("data", "model_output", "Rfam3_modeldiagnostics_posteriorsamples_frontal.png"),
    width=4500, height=3000,res=600)
plot(PPS_rec_f)
dev.off()

## model performance: Bayesian R2 --------------------------------------------------------
# Conditional R2 takes into account both fixed and random effects
# Marginal R2 only considers the variance of the fixed effects (without the random effects)
# R2_rec <- r2(model_rec)
# R2_rec
# If marginal is very low, that means if you only look at the fixed effects, your model 
# does not explain a lot of your data. 
# You would always expect marginal to be lower than Conditional, but not so much lower.
# R2 goes from 0-1, the higher, the better, shows how much you data is explaining. The diffference between 
# conditional and marginal is small in my simdata, which is good: it means that the random stuff is not explaining everyhing. 
# It does not tell us much, so we leave it out

## summary of posterior distributions of model parameters + model diagnostics: Rhat --------------------------------------------------------
# This is just a nice and fast way to create your table for the paper.
params_model_recfam_normal <-
  model_parameters(
    model_recfam_n,
    centrality = "mean",
    # do we care about the mean or the median? Since we know that the posterior distributions are normal, 
    # we want the mean. If during the post pred checks you see that it’s not normal, you might wanna use “median”
    dispersion = TRUE, # This just tells you that it will show the column sd. 
    ci = .95,
    ci_method = "eti",
    test = NULL,
    diagnostic = c("Rhat", "ESS"),, # options: "ESS", "Rhat", "MCSE", "all". 
    effects = "fixed" # options: "fixed", "random", "all". 
  ) %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))

params_model_recfam_normal
write.table(params_model_recfam_normal, file = here("data","tables","R3_params_model_recfam_normal.txt"), sep = ",", quote = FALSE, row.names = FALSE, col.names = TRUE)
## save as .RData (compressed)
save(
  params_model_recfam_normal,
  file = here("data", "model_output", "params_model_recfam_normal.RData")
)


params_model_recfam_frontal <-
  model_parameters(
    model_recfam_f,
    centrality = "mean",
    # do we care about the mean or the median? Since we know that the posterior distributions are normal, 
    # we want the mean. If during the post pred checks you see that it’s not normal, you might wanna use “median”
    dispersion = TRUE, # This just tells you that it will show the column sd. 
    ci = .95,
    ci_method = "eti",
    test = NULL,
    diagnostic = c("Rhat", "ESS"),, # options: "ESS", "Rhat", "MCSE", "all". 
    effects = "fixed" # options: "fixed", "random", "all". 
  ) %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))

params_model_recfam_frontal
write.table(params_model_recfam_frontal, file = here("data","tables","R3_params_model_recfam_frontal.txt"), sep = ",", quote = FALSE, row.names = FALSE, col.names = TRUE)
## save as .RData (compressed)
save(
  params_model_recfam_frontal,
  file = here("data", "model_output", "params_model_recfam_frontal.RData")
)



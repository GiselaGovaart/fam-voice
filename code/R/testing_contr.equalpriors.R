##### Testing contr.equalprior_pairs

# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages -----------------------------------------------------------------------------------------------------------------------------------

library(here)
library(tidyverse)
library(brms)
library(emmeans)
library(easystats)

# set vars ---------------------------------------------------------------------------------------------------------------------------------------
# num_chains <- 4 # number of chains = number of processor cores
# num_iter <- 4000 # number of samples per chain
# num_warmup <- num_iter / 2 # number of warm-up samples per chain
# num_thin <- 1 # thinning: extract one out of x samples per chain

# load models ----------------------------------------------------------------------------------------------------------------------------------
MMR_m_orig <- readRDS(here("data", "model_output", "samples_MMR_orig.rds"))
MMR_m_epoptions <- readRDS(here("data", "model_output", "samples_MMR_equalprior-options.rds"))

MMR_m_rec_orig <- readRDS(here("data", "model_output", "samples_MMR_rec_orig.rds"))
MMR_m_rec_epoptions <- readRDS(here("data", "model_output", "samples_MMR_rec_equalprior-options.rds"))

MMR_m_rec_sleep <- readRDS(here("data", "model_output", "samples_MMR_rec_sleep.rds"))

# options ---------------
# the default contrasts used in model fitting such as with aov or lm. 
# A character vector of length two, the first giving the function to be used with unordered factors 
# and the second the function to be used with ordered factors. By default the elements are named 
# c("unordered", "ordered"), but the names are unused.

# backup_options <- options()
# options(contrasts = c("contr.equalprior", "ordered"))
# options(backup_options)
# getOption("contrasts")


### ACQ -----------------------------------------------------------------------------------------------------------------------------
# with default options:
options(contrasts = c("contr.treatment", "contr.poly"))
        
MMR_m_orig_prior <- unupdate(MMR_m_orig) # sample priors from model
MMR_m_orig_prior_pairwise <-
  MMR_m_orig_prior %>%
  emmeans(~ Group:TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_orig_prior_pairwise, centr = "mean", disp = TRUE)
#--> different prior distributions for the different contrasts!

MMR_m_epoptions_prior <- unupdate(MMR_m_epoptions) # sample priors from model
MMR_m_epoptions_prior_pairwise <-
  MMR_m_epoptions_prior %>%
  emmeans(~ Group:TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons
point_estimate(MMR_m_epoptions_prior_pairwise, centr = "mean", disp = TRUE)
#--> different prior distributions for the different contrasts!

# with contrast set in options
options(contrasts = c("contr.equalprior", "ordered"))

MMR_m_orig_prior <- unupdate(MMR_m_orig) # sample priors from model
MMR_m_orig_prior_pairwise <-
  MMR_m_orig_prior %>%
  emmeans(~ Group:TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_orig_prior_pairwise, centr = "mean", disp = TRUE)
#--> different prior distributions for the different contrasts!

# CONCLUSION Acquisition
# for all of the above, we find the same non-equal priors, namely: 
# Point Estimate
# Parameter                               | Mean |    SD
# ------------------------------------------------------
# fam TestSpeaker1 - unfam TestSpeaker1   | 0.16 | 24.25
# fam TestSpeaker1 - fam TestSpeaker2     | 0.31 | 24.85
# fam TestSpeaker1 - unfam TestSpeaker2   | 0.54 | 28.29
# unfam TestSpeaker1 - fam TestSpeaker2   | 0.15 | 28.26
# unfam TestSpeaker1 - unfam TestSpeaker2 | 0.38 | 24.39
# fam TestSpeaker2 - unfam TestSpeaker2   | 0.24 | 24.04
#
## This actually makes sense, because for the 3rd and 4th row, both group and speaker are different, 
# whereas for the rest, only one of the two factors differs.
# Since both factors only have two levels, there in general does not seem to be a problem here.

# For used contrast:
MMR_m_orig_prior <- unupdate(MMR_m_orig) # sample priors from model
MMR_m_orig_prior_pairwise <-
  MMR_m_orig_prior %>%
  emmeans(~  Group|TestSpeaker)
est = pairs(MMR_m_orig_prior_pairwise) 

point_estimate(est, centr = "mean", disp = TRUE)
## here the priors are also equal


### REC --------------------------------------------------------------------------------------------------------------------------------------
## with default contrasts:
options(contrasts = c("contr.treatment", "contr.poly"))
        
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
#--> different prior distributions for the different contrasts of testspeaker!

MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ Group:TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
#--> so of course also different prior distributions for the different contrasts!

MMR_m_rec_epoptions_prior <- unupdate(MMR_m_rec_epoptions) # sample priors from model
MMR_m_rec_epoptions_prior_pairwise <-
  MMR_m_rec_epoptions_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_epoptions_prior_pairwise, centr = "mean", disp = TRUE)
#--> STILL different prior distributions for the different contrasts of testspeaker!

# with contrast set in options
options(contrasts = c("contr.equalprior", "ordered"))
MMR_m_rec_epoptions_prior <- unupdate(MMR_m_rec_epoptions) # sample priors from model
MMR_m_rec_epoptions_prior_pairwise <-
  MMR_m_rec_epoptions_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_epoptions_prior_pairwise, centr = "mean", disp = TRUE)
#--> ONLY now the prior distributions are the same!

MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# And it even works here.
# Point Estimate
# Parameter                   |     Mean |    SD
# ----------------------------------------------
# TestSpeaker1 - TestSpeaker2 |    -0.07 | 19.66
# TestSpeaker1 - TestSpeaker3 | 7.13e-03 | 19.53
# TestSpeaker2 - TestSpeaker3 |     0.08 | 19.88

# now I try with contr.equalprior_pairs:
options(contrasts = c("contr.equalprior_pairs", "ordered"))

MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# Here I also get equal priors, but they have different values:
# Point Estimate
# Parameter                   |     Mean |    SD
# ----------------------------------------------
# TestSpeaker1 - TestSpeaker2 |    -0.20 | 13.92
# TestSpeaker1 - TestSpeaker3 |    -0.20 | 13.98
# TestSpeaker2 - TestSpeaker3 | 1.39e-03 | 14.26

# now with the following:
options(contrasts = c("contr.equalprior", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# more or less the same as with options(contrasts = c("contr.equalprior_pairs", "ordered"))
# Point Estimate
# Parameter                   |  Mean |    SD
# -------------------------------------------
# TestSpeaker1 - TestSpeaker2 | -0.07 | 19.60
# TestSpeaker1 - TestSpeaker3 |  0.04 | 19.77
# TestSpeaker2 - TestSpeaker3 |  0.11 | 19.32

# Now test you custom contrasts:
options(contrasts = c("contr.equalprior", "contr.poly"))

unfam2 = c(0,0,0,1,0,0)
fam1 = c(1,0,0,0,0,0)
unfam3 = c(0,0,0,0,0,1)
unfam1 = c(0,1,0,0,0,0)

# MMR_rec.emm2 = modelMMR_rec %>%
#   emmeans(~ Group:TestSpeaker)

custom_contrasts <- list(
  list("unfam2-fam1" = unfam2 - fam1),
  list("unfam2-unfam3" = unfam2 - unfam3),
  list("unfam1-unfam2" = unfam1 - unfam2)
)

MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ Group:TestSpeaker)

contrast(MMR_m_rec_orig_prior_pairwise, method = list("unfam2-fam1" = unfam2 - fam1))
est = contrast(MMR_m_rec_orig_prior_pairwise, method = custom_contrasts)
point_estimate(est, centr = "mean", disp = TRUE)

# Point Estimate
# Parameter     |  Mean |    SD
# -----------------------------
# unfam2-fam1   | -0.14 | 28.97
# unfam2-unfam3 | -0.10 | 23.81
# unfam1-unfam2 | -0.07 | 24.40
## --> non-equal priors, also here probaly because in row one, both speaker and group differ

## with contr.equalprior_pairs
options(contrasts = c("contr.equalprior_pairs", "contr.poly"))

MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ Group:TestSpeaker)

est = contrast(MMR_m_rec_orig_prior_pairwise, method = custom_contrasts)
point_estimate(est, centr = "mean", disp = TRUE)

# Point Estimate
# Parameter     |  Mean |    SD
# -----------------------------
# unfam2-fam1   | -0.15 | 20.20
# unfam2-unfam3 | -0.04 | 15.70
# unfam1-unfam2 |  0.13 | 15.70
## --> same as with contr.equal_pairs, just that the values are different.


### Sleep
## "contr.equalprior"
options(contrasts = c("contr.equalprior", "contr.poly"))

custom_contrasts <- list(
  list("awake - activesleep and quietsleep" = c(1, -1/2, -1/2)),
  list("quietsleep - awake and activesleep" = c(-1/2, -1/2, 1)),
  list("quietsleep vs activesleep" =c(0, 1, -1))
)

modelMMR_rec_sleep_prior <- unupdate(MMR_m_rec_sleep) # sample priors from model
modelMMR_rec_sleep_prior_pair <-
  modelMMR_rec_sleep_prior %>%
  emmeans(~ sleepState)
est = pairs(modelMMR_rec_sleep_prior_pair)
point_estimate(est, centr = "mean", disp = TRUE)
est = contrast(modelMMR_rec_sleep_prior_pair, method = custom_contrasts)
point_estimate(est, centr = "mean", disp = TRUE)

# Parameter                |  Mean |    SD
# ----------------------------------------
# activesleep - awake      |  0.11 | 19.71
# activesleep - quietsleep | -0.13 | 19.91
# awake - quietsleep       | -0.24 | 19.67

# Parameter                          |      Mean |    SD
# ------------------------------------------------------
# awake - activesleep and quietsleep | -6.97e-03 | 17.19
# quietsleep - awake and activesleep |      0.19 | 17.16
# quietsleep vs activesleep          |     -0.24 | 19.67


## "contr.equalprior_pairs"
options(contrasts = c("contr.equalprior_pairs", "contr.poly"))

custom_contrasts <- list(
  list("awake - activesleep and quietsleep" = c(1, -1/2, -1/2)),
  list("quietsleep - awake and activesleep" = c(-1/2, -1/2, 1)),
  list("quietsleep vs activesleep" =c(0, 1, -1))
)

modelMMR_rec_sleep_prior <- unupdate(MMR_m_rec_sleep) # sample priors from model
modelMMR_rec_sleep_prior_pair <-
  modelMMR_rec_sleep_prior %>%
  emmeans(~ sleepState)
est = pairs(modelMMR_rec_sleep_prior_pair)
point_estimate(est, centr = "mean", disp = TRUE)
est = contrast(modelMMR_rec_sleep_prior_pair, method = custom_contrasts)
point_estimate(est, centr = "mean", disp = TRUE)

# Point Estimate
# Parameter                |  Mean |    SD
# ----------------------------------------
# activesleep - awake      | -0.06 | 13.99
# activesleep - quietsleep | -0.16 | 14.30
# awake - quietsleep       | -0.11 | 14.19

# Point Estimate
# Parameter                          |  Mean |    SD
# --------------------------------------------------
# awake - activesleep and quietsleep | -0.11 | 12.24
# quietsleep - awake and activesleep |  0.13 | 12.41
# quietsleep vs activesleep          | -0.11 | 14.19











# possible visualisation:
(pairs_bayes_orig <- pairs(emmeans(modelMMR_rec_orig, ~TestSpeaker)))

ggplot(stack(insight::get_parameters(pairs_bayes_orig)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values without contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")

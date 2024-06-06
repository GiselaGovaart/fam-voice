# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(easystats)
library(emmeans) 
library(logspline)

# setup --------------------------------------------------------------------

# options
# backup_options <- options()
# options(contrasts = c("contr.equalprior", "ordered"))
# # the default contrasts used in model fitting such as with aov or lm. 
# # A character vector of length two, the first giving the function to be used with unordered factors 
# # and the second the function to be used with ordered factors. By default the elements are named 
# # c("unordered", "ordered"), but the names are unused.
# options(backup_options)

# https://easystats.github.io/bayestestR/articles/bayes_factors.html#appendices
# orthonormal factor coding (see Rouder, Morey, Speckman, & Province, 2012, sec. 7.2)
# important when working with factors with 3 or more levels
# @G: check this!
# options(contrasts = c("contr.orthonorm", "contr.poly"))

# load data --------------------------------------------------------------------
model_rec <- readRDS(here("data", "model_output", "04_model_posteriorpredcheck_rec.rds"))
#model_rec <- readRDS(here("data", "model_output", "A2_model_rec.rds"))


# Hypotheses -------------------------------------------------------------------
# For the Recognition RQ, we want the following comparisons
# S1 = S1, S2 = S4, S3 = S3
# RQ1: unfam S2 - fam S1
# RQ2: unfam S2 - unfam S3
# RQ3: unfam S1 - unfam S2
# general:
# RQ4: nrSpeakersDaily
# Check:
# (unfam2-unfam3)-(fam2-fam3): if significant, this shows us that the effect of unfam2 - unfam3 is not solely because of order in experiment

# MAP-Based p-Value (pMAP) --------------------------------------------------------
# We use p-values here, but just to check the robustness, to check with other experiments with frequentist methods.
# https://easystats.github.io/bayestestR/reference/p_map.html
# Bayesian equivalent of the p-value, related to the odds that a parameter (described by its posterior distribution) has against the null hypothesis (h0) using Mills' (2014, 2017) Objective Bayesian Hypothesis Testing framework. It corresponds to the density value at 0 divided by the density at the Maximum A Posteriori (MAP).
# https://doi.org/10.3389/fpsyg.2019.02767
# The MAP-based p-value is related to the odds that a parameter has against the null hypothesis (Mills and Parent, 2014; Mills, 2017). It is mathematically defined as the density value at 0 divided by the density at the Maximum A Posteriori (MAP), i.e., the equivalent of the mode for continuous distributions.

# make custom contrasts (from https://aosmith.rbind.io/2019/04/15/custom-contrasts-emmeans/)
fam1 =   c(1,0,0,0,0,0)
unfam1 = c(0,1,0,0,0,0)
fam2 =   c(0,0,1,0,0,0)
unfam2 = c(0,0,0,1,0,0)
fam3 =   c(0,0,0,0,1,0)
unfam3 = c(0,0,0,0,0,1)


custom_contrasts <- list(
  list("unfam2-fam1" = unfam2 - fam1),
  list("unfam2-unfam3" = unfam2 - unfam3),
  list("unfam2-unfam1" = unfam2 - unfam1),
  list("unfam1-unfam3" = unfam1 - unfam3),
#  list("(unfam1-unfam3)-(fam1-fam3)" = (unfam1 - unfam3) - (fam1 - fam3)) # this is the interaction that, if significant, shows us that a possible effect of unfam3 being more negative than unfam1 is not solely because of order in experiment. 
) 

##  Effect all ------------------------
# pMAP_all_rec = 
#   model_rec %>%
#   p_map() %>%
#   mutate(
#     "p < .05" = ifelse(p_MAP < .05, "*", "")
#   )

## Effects Custom contrasts ------------------------
pMAP_customcontrasts_rec = 
  model_rec %>%
  emmeans(~ Group:TestSpeaker) %>%
  contrast(method = custom_contrasts) %>%
  p_map() %>%
  mutate(
    "p < .05" = ifelse(p_MAP < .05, "*", "")
  )
pMAP_customcontrasts_rec


# Bayes Factors --------------------------------------------------------
# https://doi.org/10.3389/fpsyg.2019.02767
# The Bayes factor indicates the degree by which the mass of the posterior distribution has shifted further away from or closer 
# to the null value (0) relative to the prior distribution, thus indicating if the null hypothesis has become less or more likely given 
# the observed data. The BF is computed as a Savage-Dickey density ratio, which is also an approximation of a Bayes factor comparing the 
# marginal likelihoods of the model against a model in which the tested parameter has been restricted to the point-null (Wagenmakers et al., 2010).

model_rec_prior <- unupdate(model_rec) # sample priors from model
# just samples from the prior distribution. Because you want to compare prior and posterior distributions
# you want to know how much your data influenced the posterior distribution. For that, you compare 
# the prior and the posterior distributions.

# ##  Effect all ------------------------
# # Bayes Factors (Savage-Dickey density ratio)
# BF_all_rec <-
#   model_rec %>%
#   bf_parameters(prior = model_rec_prior) %>%
#   arrange(log_BF) # sort according to BF
# 
# # add rule-of-thumb interpretation
# BF_all_rec <-
#   BF_all_rec %>%
#   add_column(
#     "interpretation" = interpret_bf(
#       BF_all_rec$log_BF,
#       rules = "raftery1995",
#       log = TRUE,
#       include_value = TRUE,
#       protect_ratio = TRUE,
#       exact = TRUE
#     ),
#     .after = "log_BF"
#   )

## Effects Custom contrasts ------------------------
# pairwise comparisons of prior distributions
customcontrasts_pairwise_prior_rec =
  model_rec_prior %>%
  emmeans(~ Group:TestSpeaker) %>% # estimated marginal means
  contrast(method = custom_contrasts) 

# pairwise comparisons of posterior distributions
customcontrasts_pairwise_rec <-
  model_rec %>%
  emmeans(~ Group:TestSpeaker) %>%
  contrast(method = custom_contrasts) 

# Bayes Factors (Savage-Dickey density ratio)
# Calculates the density around 0 for the subtracted (posterior - prior) distributions. 
# So if that density is very high, you have no support for your Ha. (because there are a lot
# of values around zero)
BF_customcontrasts_rec <-
  customcontrasts_pairwise_rec %>%
  bf_parameters(prior = customcontrasts_pairwise_prior_rec) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
# Add rule of thumb interpretation: looks at value and tells use what it means according to the
# rules of raftery1995. You add the column for interpretability, but you want to keep the other 
# stuff too because the cool thing is that BA gives you something continuous. So don’t just cut 
# if off with a rule of thumb!
BF_customcontrasts_rec <-
  BF_customcontrasts_rec %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_customcontrasts_rec$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_customcontrasts_rec

## check whether the priors were equal 
ggplot(stack(insight::get_parameters(customcontrasts_pairwise_prior_rec)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values") +
  theme(legend.position = "none")

point_estimate(customcontrasts_pairwise_prior_rec, centr = "mean", disp = TRUE)

# output BF: 
# - “Evidence against the null: 0” this does not have to be 0. Can be another model for example
# BA(10): first looking at alternative and then null. 
# This is what’s always is used in the table. So if there is strong evidence against ha, 
# there is strong evidence for null. So then you need to calculate 1/BF 
# (then you get BA(01), first looking at the null, then at the alternative). 
# And then you get your Bayes factor for the null hypothesis.
# this is also explained well in JASP

# merge info and save to file --------------------------------------------------------
# pMAP_all_rec = subset(pMAP_all_rec,select= -c(Effects, Component))
# BF_all_rec = subset(BF_all_rec,select= -c(Effects, Component))
# 
# pMAP_BF_all <-
#   full_join(
#     pMAP_all_rec,
#     BF_all_rec,
#     by = "Parameter"
#   ) %>% 
#   as_tibble()

pMAP_BF_customcontrasts <-
  full_join(
    pMAP_customcontrasts_rec,
    BF_customcontrasts_rec,
    by = "Parameter"
  ) %>% 
  as_tibble()

# pMAP_BF_all = 
#   rbind(pMAP_BF_all, pMAP_BF_customcontrasts)

pMAP_BF_all = pMAP_BF_customcontrasts

# save as .rds
saveRDS(
  pMAP_BF_all,
  file = here("data", "hypothesis_testing", "pMAP_BF_rec.rds")
)

# END --------------------------------------------------------

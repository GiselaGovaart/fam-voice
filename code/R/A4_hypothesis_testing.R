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

# Hypotheses -------------------------------------------------------------------
# For the Acquisition RQ, we want the following comparisons
# 1. For test_speaker = Speaker1, the mmr is different for group=fam vs group = unfam.
# 2. For test_speaker = Speaker2, the mmr is different for group=fam vs group = unfam.
# 3. For both groups together: mmr is larger for test_speaker = S1 as for test_speaker = S2
# 4. For both groups and speakers together: if nrSpeakersDaily is higher, MMR is larger
# This means we want the following contrasts:
# for Group:TestSpeaker:
# RQ1: fam TestSpeaker1 - unfam TestSpeaker1
# RQ2: fam TestSpeaker2 - unfam TestSpeaker2
# for TestSpeaker:
# RQ3: TestSpeaker1 - TestSpeaker2
# general:
# RQ4: nrSpeakersDaily
# RQ5: sleepState

## MAP-Based p-Value (pMAP) --------------------------------------------------------
# We use p-values here, but just to check the robustness, to check with other experiments with frequentist methods.
# https://easystats.github.io/bayestestR/reference/p_map.html
# Bayesian equivalent of the p-value, related to the odds that a parameter (described by its posterior distribution) has against the null hypothesis (h0) using Mills' (2014, 2017) Objective Bayesian Hypothesis Testing framework. It corresponds to the density value at 0 divided by the density at the Maximum A Posteriori (MAP).
# https://doi.org/10.3389/fpsyg.2019.02767
# The MAP-based p-value is related to the odds that a parameter has against the null hypothesis (Mills and Parent, 2014; Mills, 2017). It is mathematically defined as the density value at 0 divided by the density at the Maximum A Posteriori (MAP), i.e., the equivalent of the mode for continuous distributions.
# caveats: 
# 1) p_MAP allows to assess the presence of an effect, not its *magnitude* or *importance* (https://easystats.github.io/bayestestR/articles/probability_of_direction.html)
# 2) p_MAP is sensitive only to the amount of evidence for the *alternative hypothesis* (i.e., when an effect is truly present). It is *not* able to reflect the amount of evidence in favor of the *null hypothesis*. A high value suggests that the effect exists, but a low value indicates uncertainty regarding its existence (but not certainty that it is non-existent) (https://doi.org/10.3389/fpsyg.2019.02767).

## Bayes Factors --------------------------------------------------------
# https://doi.org/10.3389/fpsyg.2019.02767
# The Bayes factor indicates the degree by which the mass of the posterior distribution has shifted further away from or closer 
# to the null value (0) relative to the prior distribution, thus indicating if the null hypothesis has become less or more likely given 
# the observed data. The BF is computed as a Savage-Dickey density ratio, which is also an approximation of a Bayes factor comparing the 
# marginal likelihoods of the model against a model in which the tested parameter has been restricted to the point-null (Wagenmakers et al., 2010).
# Bayes Factors (Savage-Dickey density ratio)
# Calculates the density around 0 for the subtracted (posterior - prior) distributions. 
# So if that density is very high, you have no support for your Ha. (because there are a lot
# of values around zero)
# Add rule of thumb interpretation: looks at value and tells use what it means according to the
# rules of raftery1995. You add the column for interpretability, but you want to keep the other 
# stuff too because the cool thing is that BA gives you something continuous. So don’t just cut 
# if off with a rule of thumb!
# output BF: 
# - “Evidence against the null: 0” this does not have to be 0. Can be another model for example
# BA(10): first looking at alternative and then null. 
# This is what’s always is used in the table. So if there is strong evidence against ha, 
# there is strong evidence for null. So then you need to calculate 1/BF 
# (then you get BA(01), first looking at the null, then at the alternative). 
# And then you get your Bayes factor for the null hypothesis.
# this is also explained well in JASP


model_acq <- readRDS(here("data", "model_output", "A2_model_acq.rds"))

# MAP-Based p-Value (pMAP) --------------------------------------------------------
# Effect all
pMAP_all_acq <- model_acq %>%
  p_map() %>%
  mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# Mean MMR per subset
pMAP_subsetMMR_acq <- model_acq %>%
  emmeans(~ Group * TestSpeaker) %>%
  p_map() %>%
  mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# Simple Effect Group 
pMAP_Group_simple_acq <- model_acq %>%
  emmeans(~ Group | TestSpeaker) %>%
  pairs() %>%
  p_map() %>%
  mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# Effect Speaker 
pMAP_Speaker_acq <- model_acq %>%
  emmeans(~ TestSpeaker) %>%
  pairs() %>%
  p_map() %>%
  mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# Bayes Factors -------------------------------------------------------------------
model_acq_prior <- unupdate(model_acq) # sample priors from model

# Effect all
BF_all_acq <- model_acq %>%
  bf_parameters(prior = model_acq_prior) %>%
  arrange(log_BF) %>%
  add_column("interpretation" = interpret_bf(
    .$log_BF,
    rules = "raftery1995",
    log = TRUE,
    include_value = TRUE,
    protect_ratio = TRUE,
    exact = TRUE
  ), .after = "log_BF")

# Mean MMR per subset
subsetMMR_prior_acq <- model_acq_prior %>%
  emmeans(~ Group * TestSpeaker) 

subsetMMR_acq <- model_acq %>%
  emmeans(~ Group * TestSpeaker) 

BF_subsetMMR_acq <- subsetMMR_acq %>%
  bf_parameters(prior = subsetMMR_prior_acq) %>%
  arrange(log_BF) %>%
  add_column("interpretation" = interpret_bf(
    .$log_BF,
    rules = "raftery1995",
    log = TRUE,
    include_value = TRUE,
    protect_ratio = TRUE,
    exact = TRUE
  ), .after = "log_BF")

# Simple Effect Group
Group_simple_pairwise_prior_acq <- model_acq_prior %>%
  emmeans(~ Group | TestSpeaker) %>%
  pairs()

Group_simple_pairwise_acq <- model_acq %>%
  emmeans(~ Group | TestSpeaker) %>%
  pairs()

BF_Group_simple_acq <- Group_simple_pairwise_acq %>%
  bf_parameters(prior = Group_simple_pairwise_prior_acq) %>%
  arrange(log_BF) %>%
  add_column("interpretation" = interpret_bf(
    .$log_BF,
    rules = "raftery1995",
    log = TRUE,
    include_value = TRUE,
    protect_ratio = TRUE,
    exact = TRUE
  ), .after = "log_BF")

# Effect Speaker
Speaker_pairwise_prior_acq <- model_acq_prior %>%
  emmeans(~ TestSpeaker) %>%
  pairs()

Speaker_pairwise_acq <- model_acq %>%
  emmeans(~ TestSpeaker) %>%
  pairs()

BF_Speaker_acq <- Speaker_pairwise_acq %>%
  bf_parameters(prior = Speaker_pairwise_prior_acq) %>%
  arrange(log_BF) %>%
  add_column("interpretation" = interpret_bf(
    .$log_BF,
    rules = "raftery1995",
    log = TRUE,
    include_value = TRUE,
    protect_ratio = TRUE,
    exact = TRUE
  ), .after = "log_BF")

# Merge and save results ---------------------------------------------------------
pMAP_all_acq <- subset(pMAP_all_acq, select = -c(Effects, Component))
BF_all_acq <- subset(BF_all_acq, select = -c(Effects, Component))

pMAP_BF_all <- full_join(pMAP_all_acq, BF_all_acq, by = "Parameter") %>%
  as_tibble()

pMAP_BF_subsetMMR <- full_join(pMAP_subsetMMR_acq, BF_subsetMMR_acq, by = "Parameter") %>%
  as_tibble()

pMAP_BF_Group <- full_join(pMAP_Group_simple_acq, BF_Group_simple_acq, by = "Parameter") %>%
  as_tibble()

pMAP_BF_Speaker <- full_join(pMAP_Speaker_acq, BF_Speaker_acq, by = "Parameter") %>%
  as_tibble()

pMAP_BF_all <- rbind(pMAP_BF_all, pMAP_BF_subsetMMR, pMAP_BF_Group, pMAP_BF_Speaker)

# Save the results
saveRDS(pMAP_BF_all, file = here("data", "hypothesis_testing", "pMAP_BF_acq.rds"))

# Save as text file
output_filename <- here("data", "hypothesis_testing", "pMAP_BF_acq.rds")
output_filename <- substr(output_filename, 1, nchar(output_filename) - 4) # Remove the last 4 characters

# Round all numeric columns to 3 decimal places
for(col in names(pMAP_BF_all)){
  if(is.numeric(pMAP_BF_all[[col]])){
    pMAP_BF_all[[col]] <- round(pMAP_BF_all[[col]], 3)
  }
}
write.table(pMAP_BF_all, file = paste(output_filename, ".txt", sep=""), sep = ",", quote = FALSE, row.names = FALSE)


  
  
  
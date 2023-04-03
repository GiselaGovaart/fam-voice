
# RNG --------------------------------------------------------

project_seed <- 2049
set.seed(project_seed) # set seed

# install packages --------------------------------------------------------------------

# install.packages("here")
# install.packages("tidyverse")
# install.packages("easystats")
# install.packages("emmeans")

# load packages --------------------------------------------------------------------

library(here)
library(tidyverse)
library(easystats)
library(emmeans) # just makes it easier to do the comparisons

# setup --------------------------------------------------------------------

# https://easystats.github.io/bayestestR/articles/bayes_factors.html#appendices
# orthonormal factor coding (see Rouder, Morey, Speckman, & Province, 2012, sec. 7.2)
# important when working with factors with 3 or more levels
# @G: check this!
options(contrasts = c("contr.orthonorm", "contr.poly"))

# load data --------------------------------------------------------------------

# results of model fit
P3_m <- readRDS(here("data", "model_output", "samples_P3_mean.rds"))

# MAP-Based p-Value (pMAP) --------------------------------------------------------

# We use p-values here, but just to check the robustness, to check with other experiments with frequentist methods.
# Read the below papers!

# https://easystats.github.io/bayestestR/reference/p_map.html
# Bayesian equivalent of the p-value, related to the odds that a parameter (described by its posterior distribution) has against the null hypothesis (h0) using Mills' (2014, 2017) Objective Bayesian Hypothesis Testing framework. It corresponds to the density value at 0 divided by the density at the Maximum A Posteriori (MAP).

# https://doi.org/10.3389/fpsyg.2019.02767
# The MAP-based p-value is related to the odds that a parameter has against the null hypothesis (Mills and Parent, 2014; Mills, 2017). It is mathematically defined as the density value at 0 divided by the density at the Maximum A Posteriori (MAP), i.e., the equivalent of the mode for continuous distributions.

# loop over density estimation method (to assess robustness)
pMAP_method <- c("kernel", "logspline", "KernSmooth")

# preallocate empty dataframes
pMAP_Expectancy_Valence_P3_m <- NULL

# Expectancy x Valence interaction
for (i in pMAP_method) {
  temp <-
    P3_m %>%
    emmeans(~ Expectancy:Valence) %>%
    # here we create all the all the pairs between the two levels of your two factors
    # if you only want to look at the effect of Expectancy, just use (~ Expectancy)
    # so for Gisela's data, do this 3 times, once with (~Group:TestVoice), once with (~Group) and once with (~TestVoice)
    pairs() %>%
    p_map(
      method = i
    ) %>%
    mutate(
      "method" = i,
      "p < .05" = ifelse(p_MAP < .05, "*", "")
    )

  pMAP_Expectancy_Valence_P3_m <-
    rbind(
      pMAP_Expectancy_Valence_P3_m,
      temp
    ) %>%
    arrange(p_MAP)

  rm(temp)
}

pMAP_Expectancy_Valence_P3_m

# caveats --------------------------------------------------------

# 1) p_MAP allows to assess the presence of an effect, not its *magnitude* or *importance* (https://easystats.github.io/bayestestR/articles/probability_of_direction.html)
# 2) p_MAP is sensitive only to the amount of evidence for the *alternative hypothesis* (i.e., when an effect is truly present). It is *not* able to reflect the amount of evidence in favor of the *null hypothesis*. A high value suggests that the effect exists, but a low value indicates uncertainty regarding its existence (but not certainty that it is non-existent) (https://doi.org/10.3389/fpsyg.2019.02767).

# Bayes Factors --------------------------------------------------------

# https://doi.org/10.3389/fpsyg.2019.02767
# The Bayes factor indicates the degree by which the mass of the posterior distribution has shifted further away from or closer to the null value (0) relative to the prior distribution, thus indicating if the null hypothesis has become less or more likely given the observed data. The BF is computed as a Savage-Dickey density ratio, which is also an approximation of a Bayes factor comparing the marginal likelihoods of the model against a model in which the tested parameter has been restricted to the point-null (Wagenmakers et al., 2010).

P3_m_prior <- unupdate(P3_m) # sample priors from model
# just samples 8000 times from the prior distribution. Because you want to compare prior and posterior distributions
# you want to know how much your data influenced the posterior distribution. For that, you compare 
# the prior and the posterior distributions.

# pairwise comparisons of prior distributions
Expectancy_Valence_P3_m_prior_pairwise <-
  P3_m_prior %>%
  emmeans(~ Expectancy:Valence) %>% # estimated marginal means
  pairs() # pairwise comparisons

# pairwise comparisons of posterior distributions
Expectancy_Valence_P3_m_pairwise <-
  P3_m %>%
  emmeans(~ Expectancy:Valence) %>%
  pairs()

# Bayes Factors (Savage-Dickey density ratio)
# Calculates the density around 0 for the subtracted (posterior - prior) distributions. 
# So if that density is very high, you have no support for your Ha. (because there are a lot
# of values around zero)
BF_Expectancy_Valence_P3_m <-
  Expectancy_Valence_P3_m_pairwise %>%
  bf_parameters(prior = Expectancy_Valence_P3_m_prior_pairwise) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
# Add rule of thumb interpretation: looks at value and tells use what it means according to the
# rules of raftery1995. You add the column for interpretability, but you want to keep the other 
# stuff too because the cool thing is that BA gives you something continuous. So don’t just cut 
# if off with a rule of thumb!
BF_Expectancy_Valence_P3_m <-
  BF_Expectancy_Valence_P3_m %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_Expectancy_Valence_P3_m$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_Expectancy_Valence_P3_m
# output: 
# - “Evidence against the null: 0” this does not have to be 0. Can be another model for example
# BA(10): first looking at alternative and then null. 
# This is what’s always is used in the table. So if there is strong evidence against ha, 
# there is strong evidence for null. So then you need to calculate 1/BF 
# (then you get BA(01), first looking at the null, then at the alternative). 
# And then you get your Bayes factor for the null hypothesis.
# this is also explained well in JASP

# merge info and save to file --------------------------------------------------------

P3_pMAP_BF <-
  full_join(
    pMAP_Expectancy_Valence_P3_m,
    BF_Expectancy_Valence_P3_m,
    by = "Parameter"
  ) %>% 
  as_tibble()

# save as .rds
saveRDS(
  P3_pMAP_BF,
  file = here("data", "hypothesis_testing", "P3_pMAP_BF.rds")
)

# END --------------------------------------------------------


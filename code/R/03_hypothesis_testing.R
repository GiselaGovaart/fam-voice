
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
library(logspline)
# setup --------------------------------------------------------------------

# https://easystats.github.io/bayestestR/articles/bayes_factors.html#appendices
# orthonormal factor coding (see Rouder, Morey, Speckman, & Province, 2012, sec. 7.2)
# important when working with factors with 3 or more levels
# @G: check this!
# options(contrasts = c("contr.orthonorm", "contr.poly"))

# load data --------------------------------------------------------------------

# results of model fit
MMR_m <- readRDS(here("data", "model_output", "samples_MMR.rds"))
MMR_m_rec <- readRDS(here("data", "model_output", "samples_MMR_rec.rds"))


# Trying out different contrasts:
# ACQ
# Hypotheses -------------------------------------------------------------------
# For the Acquisition RQ, we want the following comparisons
# 1. For test_speaker = Speaker1, the mmr is different for group=fam vs group = unfam. 
# 2. For test_speaker = Speaker2, the mmr is different for group=fam vs group = unfam. 
# 3. For both groups together: mmr is larger for test_speaker = S1 as for test_speaker = S2
# This means we want the following contrasts:
# for Group:TestSpeaker:
# RQ1: fam TestSpeaker1 - unfam TestSpeaker1
# RQ2: fam TestSpeaker2 - unfam TestSpeaker2
# for TestSpeaker:
# RQ3: TestSpeaker1 - TestSpeaker2


# Testing contrasts
MMR.emm = MMR_m %>%
  emmeans(~  Group | TestSpeaker)
contrast(MMR.emm, "trt.vs.ctrl", adjust = "none") # no difference with default or adjust="none"
coef(contrast(MMR.emm, "trt.vs.ctrl"))

plot(MMR.emm)

# this does the exact same:
MMR.emm2 = MMR_m %>%
  emmeans(~  Group|TestSpeaker)
pairs(MMR.emm2) 

# Also same:
MMR.emm3 = MMR_m %>%
  emmeans(~  Group:TestSpeaker)
pairs(MMR.emm3, simple = "Group") # same as pairs(MMR.emm2, by = "TestSpeaker") 



# REC
# Hypotheses -------------------------------------------------------------------
# S1 = S1, S2 = S4, S3 = S3
# RQ1: unfam S2 - fam S1
# RQ2: unfam S2 - unfam S3
# RQ3: unfam S1 - unfam S2

# make custom contrasts (from https://aosmith.rbind.io/2019/04/15/custom-contrasts-emmeans/)
unfam2 = c(0,0,0,1,0,0)
fam1 = c(1,0,0,0,0,0)
unfam3 = c(0,0,0,0,0,1)
unfam1 = c(0,1,0,0,0,0)

MMR_rec.emm2 = MMR_m_rec %>%
  emmeans(~ Group:TestSpeaker)

contrast(MMR_rec.emm2, method = list("unfam2-fam1" = unfam2 - fam1))
contrast(MMR_rec.emm2, method = list("unfam2-unfam3" = unfam2 - unfam3))
contrast(MMR_rec.emm2, method = list("unfam1-unfam2" = unfam1 - unfam2))
# I checked, this gives the same output as (at least for the last two, the first one is given the other way around:) :
MMR_rec.emm2 = MMR_m_rec %>%
  emmeans(~ Group:TestSpeaker) %>%
  pairs()
MMR_rec.emm2

MMR_rec.emm3 = MMR_m_rec %>%
  emmeans(~ Group:TestSpeaker) 
contrast(MMR_rec.emm3, "poly")



# options
backup_options <- options()
options(contrasts = c("contr.equalprior", "contr.poly"))
# the default contrasts used in model fitting such as with aov or lm. 
# A character vector of length two, the first giving the function to be used with unordered factors 
# and the second the function to be used with ordered factors. By default the elements are named 
# c("unordered", "ordered"), but the names are unused.
options(backup_options)





##### from Antonio:
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
pMAP_Group_Speaker_MMR_m <- NULL
pMAP_Group_Speaker_nested_MMR_m <- NULL
pMAP_Speaker_MMR_m <- NULL
# Group:Testspeaker interaction
for (i in pMAP_method) {
  temp <-
    MMR_m %>%
    emmeans(~ Group:TestSpeaker) %>%
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

  pMAP_Group_Speaker_MMR_m <-
    rbind(
      pMAP_Group_Speaker_MMR_m,
      temp
    ) %>%
    arrange(p_MAP)

  rm(temp)
}

pMAP_Group_Speaker_MMR_m

# Group:Testspeaker interaction for nested model
for (i in pMAP_method) {
  temp <-
    fit_Nest %>%
    emmeans(~ Group:TestSpeaker) %>% # or: Group/TestSpeaker ??
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
  
  pMAP_Group_Speaker_nested_MMR_m <-
    rbind(
      pMAP_Group_Speaker_nested_MMR_m,
      temp
    ) %>%
    arrange(p_MAP)
  
  rm(temp)
}

pMAP_Group_Speaker_nested_MMR_m


# NB: if we compare these two outputs (once interaction model, once nested model, we do see there is a difference. 
# so then the nested model does not make sense I think)


# Speaker effect
for (i in pMAP_method) {
  temp <-
    MMR_m %>%
    emmeans(~ TestSpeaker) %>%
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
  
  pMAP_Speaker_MMR_m <-
    rbind(
      pMAP_Speaker_MMR_m,
      temp
    ) %>%
    arrange(p_MAP)
  
  rm(temp)
}

pMAP_Speaker_MMR_m

# caveats --------------------------------------------------------

# 1) p_MAP allows to assess the presence of an effect, not its *magnitude* or *importance* (https://easystats.github.io/bayestestR/articles/probability_of_direction.html)
# 2) p_MAP is sensitive only to the amount of evidence for the *alternative hypothesis* (i.e., when an effect is truly present). It is *not* able to reflect the amount of evidence in favor of the *null hypothesis*. A high value suggests that the effect exists, but a low value indicates uncertainty regarding its existence (but not certainty that it is non-existent) (https://doi.org/10.3389/fpsyg.2019.02767).



# Bayes Factors --------------------------------------------------------

# https://doi.org/10.3389/fpsyg.2019.02767
# The Bayes factor indicates the degree by which the mass of the posterior distribution has shifted further away from or closer to the null value (0) relative to the prior distribution, thus indicating if the null hypothesis has become less or more likely given the observed data. The BF is computed as a Savage-Dickey density ratio, which is also an approximation of a Bayes factor comparing the marginal likelihoods of the model against a model in which the tested parameter has been restricted to the point-null (Wagenmakers et al., 2010).

MMR_m_prior <- unupdate(MMR_m) # sample priors from model
# just samples 8000 times from the prior distribution. Because you want to compare prior and posterior distributions
# you want to know how much your data influenced the posterior distribution. For that, you compare 
# the prior and the posterior distributions.

# pairwise comparisons of prior distributions
Group_Speaker_MMR_m_prior_pairwise <-
  MMR_m_prior %>%
  emmeans(~ Group:TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

# pairwise comparisons of posterior distributions
Group_Speaker_MMR_m_pairwise <-
  MMR_m %>%
  emmeans(~ Group:TestSpeaker) %>%
  pairs()

# Bayes Factors (Savage-Dickey density ratio)
# Calculates the density around 0 for the subtracted (posterior - prior) distributions. 
# So if that density is very high, you have no support for your Ha. (because there are a lot
# of values around zero)
BF_Group_Speaker_MMR_m <-
  Group_Speaker_MMR_m_pairwise %>%
  bf_parameters(prior = Group_Speaker_MMR_m_prior_pairwise) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
# Add rule of thumb interpretation: looks at value and tells use what it means according to the
# rules of raftery1995. You add the column for interpretability, but you want to keep the other 
# stuff too because the cool thing is that BA gives you something continuous. So don’t just cut 
# if off with a rule of thumb!
BF_Group_Speaker_MMR_m <-
  BF_Group_Speaker_MMR_m %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_Group_Speaker_MMR_m$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_Group_Speaker_MMR_m

# Model for only TestSpeaker
# pairwise comparisons of prior distributions
Speaker_MMR_m_prior_pairwise <-
  MMR_m_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

# pairwise comparisons of posterior distributions
Speaker_MMR_m_pairwise <-
  MMR_m %>%
  emmeans(~ TestSpeaker) %>%
  pairs()

# Bayes Factors (Savage-Dickey density ratio)
# Calculates the density around 0 for the subtracted (posterior - prior) distributions. 
# So if that density is very high, you have no support for your Ha. (because there are a lot
# of values around zero)
BF_Speaker_MMR_m <-
  Speaker_MMR_m_pairwise %>%
  bf_parameters(prior = Speaker_MMR_m_prior_pairwise) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
# Add rule of thumb interpretation: looks at value and tells use what it means according to the
# rules of raftery1995. You add the column for interpretability, but you want to keep the other 
# stuff too because the cool thing is that BA gives you something continuous. So don’t just cut 
# if off with a rule of thumb!
BF_Speaker_MMR_m <-
  BF_Speaker_MMR_m %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_Speaker_MMR_m$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_Speaker_MMR_m


# TESTING priors equal
MMR_m_prior <- unupdate(MMR_m) # sample priors from model

MMR_m_prior_rq12 <-
  MMR_m_prior %>%
  emmeans(~  Group|TestSpeaker) %>%
  pairs() 

MMR_m_rq12 <-
  MMR_m %>%
  emmeans(~  Group|TestSpeaker) %>%
  pairs() 

# Bayes Factors (Savage-Dickey density ratio)
BF_rq12 <-
  MMR_m_rq12 %>%
  bf_parameters(prior = MMR_m_prior_rq12) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
BF_rq12 <-
  BF_rq12 %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_rq12$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_rq12

# check priors equal?  --> only if we set contrasts(dat_rec$TestSpeaker) <- contr.equalprior_pairs before running the model in parameter_estimation.R
ggplot(stack(insight::get_parameters(MMR_m_prior_rq12)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values with contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")



##### Model for REC ------------------------
rec_MMR_m_prior <- unupdate(MMR_m_rec) # sample priors from model

#### RQ1
#  comparison of prior distributions
rec_MMR_m_prior_rq1 <-
  rec_MMR_m_prior %>%
  emmeans(~ Group:TestSpeaker)
rec_MMR_m_prior_rq1 = contrast(rec_MMR_m_prior_rq1, method = list("unfam2-fam1" = unfam2 - fam1))

#  comparison of posterior distributions
rec_MMR_m_rq1 <-
  MMR_m_rec %>%
  emmeans(~ TestSpeaker:Group) 
rec_MMR_m_rq1 = contrast(rec_MMR_m_rq1, method = list("unfam2-fam1" = unfam2 - fam1))

# Bayes Factors (Savage-Dickey density ratio)
BF_rec_rq1 <-
  rec_MMR_m_rq1 %>%
  bf_parameters(prior = rec_MMR_m_prior_rq1) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
BF_rec_rq1 <-
  BF_rec_rq1 %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_rec_rq1$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_rec_rq1

# check priors equal?  --> here there is only one comparison, so yes, the prior is equal...
ggplot(stack(insight::get_parameters(rec_MMR_m_prior_rq1)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values without contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")


#### All pairs
# pairwise comparisons of prior distributions
rec_MMR_m_prior_pairwise <-
  rec_MMR_m_prior %>%
  emmeans(~ Group:TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

# pairwise comparisons of posterior distributions
rec_MMR_m_pairwise <-
  MMR_m_rec %>%
  emmeans(~ Group:TestSpeaker) %>%
  pairs()

# Bayes Factors (Savage-Dickey density ratio)
BF_rec_pairwise <-
  rec_MMR_m_pairwise %>%
  bf_parameters(prior = rec_MMR_m_prior_pairwise) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
BF_rec_pairwise <-
  BF_rec_pairwise %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_rec_pairwise$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_rec_pairwise

# check priors equal? --> no they're not
ggplot(stack(insight::get_parameters(rec_MMR_m_prior_pairwise)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values without contr.equalprior_pairs on $TestSpeaker") +
  theme(legend.position = "none")




# output: 
# - “Evidence against the null: 0” this does not have to be 0. Can be another model for example
# BA(10): first looking at alternative and then null. 
# This is what’s always is used in the table. So if there is strong evidence against ha, 
# there is strong evidence for null. So then you need to calculate 1/BF 
# (then you get BA(01), first looking at the null, then at the alternative). 
# And then you get your Bayes factor for the null hypothesis.
# this is also explained well in JASP


# merge info and save to file --------------------------------------------------------
MMR_pMAP_BF <-
  full_join(
    pMAP_Group_Speaker_MMR_m,
    BF_Group_Speaker_MMR_m,
    by = "Parameter"
  ) %>% 
  as_tibble()

# save as .rds
saveRDS(
  MMR_pMAP_BF,
  file = here("data", "hypothesis_testing", "MMR_GroupSpeaker_pMAP_BF.rds")
)

MMR_pMAP_BF <-
  full_join(
    pMAP_Speaker_MMR_m,
    BF_Speaker_MMR_m,
    by = "Parameter"
  ) %>% 
  as_tibble()

# save as .rds
saveRDS(
  MMR_pMAP_BF,
  file = here("data", "hypothesis_testing", "MMR_Speaker_pMAP_BF.rds")
)

# END --------------------------------------------------------


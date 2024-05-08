# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(easystats)
library(emmeans) 
library(logspline)

# load data --------------------------------------------------------------------
model_rec <- readRDS(here("data", "model_output", "samples_MMR_rec_orig.rds"))


#### RECOGNITION

# make custom contrasts (from https://aosmith.rbind.io/2019/04/15/custom-contrasts-emmeans/)
unfam2 = c(0,0,0,1,0,0)
fam1 = c(1,0,0,0,0,0)
unfam3 = c(0,0,0,0,0,1)
unfam1 = c(0,1,0,0,0,0)

custom_contrasts <- list(
  list("unfam2-fam1" = unfam2 - fam1),
  list("unfam2-unfam3" = unfam2 - unfam3),
  list("unfam1-unfam2" = unfam1 - unfam2)
) 
# I checked, the custom contrasts give the same output as (at least for the last two, the first one is given the other way around:) :

(unfam2 - unfam3) - (fam2 - fam3) # this is the interaction that, if significant, shows us that the effect of unfam2 - unfam3 is not solely because of order in experiment. 



MMR_rec.emm1 = MMR_m_rec %>%
  emmeans(~ Group:TestSpeaker) %>%
  contrast(method = custom_contrasts)
MMR_rec.emm1

MMR_rec.emm2 = MMR_m_rec %>%
  emmeans(~ Group:TestSpeaker) %>%
  pairs()
MMR_rec.emm2


# preallocate empty dataframes
pMAP_rec_custom_m <- NULL
pMAP_rec_nrSpeaker_m <- NULL
pMAP_rec_sleepState_m <- NULL


# Custom contrast
for (i in pMAP_method) {
  temp <-
    MMR_m_rec %>%
    emmeans(~ Group:TestSpeaker) %>%
    contrast(method = custom_contrasts) %>%
    p_map(
      method = i
    ) %>%
    mutate(
      "method" = i,
      "p < .05" = ifelse(p_MAP < .05, "*", "")
    )
  
  pMAP_rec_custom_m <-
    rbind(
      pMAP_rec_custom_m,
      temp
    ) %>%
    arrange(p_MAP)
  
  rm(temp)
}

pMAP_rec_custom_m

# # nrSpeakersDailyLife effect
# for (i in pMAP_method) {
#   temp <-
#     MMR_m_rec %>%
#     emmeans(~ nrSpeakersDaily) %>%
#     # pairs() %>% # no pairs because continuous variable
#     p_map(
#       method = i
#     ) %>%
#     mutate(
#       "method" = i,
#       "p < .05" = ifelse(p_MAP < .05, "*", "")
#     )
#   
#   pMAP_rec_nrSpeaker_m <-
#     rbind(
#       pMAP_rec_nrSpeaker_m,
#       temp
#     ) %>%
#     arrange(p_MAP)
#   
#   rm(temp)
# }
# 
# pMAP_rec_nrSpeaker_m

# sleepState effect
for (i in pMAP_method) {
  temp <-
    MMR_m_rec %>%
    emmeans(~ sleepState) %>%
    contrast(method = custom_contrasts_sleep) %>%
    p_map(
      method = i
    ) %>%
    mutate(
      "method" = i,
      "p < .05" = ifelse(p_MAP < .05, "*", "")
    )
  
  pMAP_rec_sleepState_m <-
    rbind(
      pMAP_rec_sleepState_m,
      temp
    ) %>%
    arrange(p_MAP)
  
  rm(temp)
}

pMAP_rec_sleepState_m


# caveats --------------------------------------------------------

# 1) p_MAP allows to assess the presence of an effect, not its *magnitude* or *importance* (https://easystats.github.io/bayestestR/articles/probability_of_direction.html)
# 2) p_MAP is sensitive only to the amount of evidence for the *alternative hypothesis* (i.e., when an effect is truly present). It is *not* able to reflect the amount of evidence in favor of the *null hypothesis*. A high value suggests that the effect exists, but a low value indicates uncertainty regarding its existence (but not certainty that it is non-existent) (https://doi.org/10.3389/fpsyg.2019.02767).


##### Model for REC ------------------------
rec_MMR_m_prior <- unupdate(MMR_m_rec) # sample priors from model

#### Custom contrasts
#  comparison of prior distributions
rec_MMR_m_prior <-
  rec_MMR_m_prior %>%
  emmeans(~ Group:TestSpeaker)
rec_MMR_m_prior = contrast(rec_MMR_m_prior, method = custom_contrasts)

#  comparison of posterior distributions
rec_MMR_m <-
  MMR_m_rec %>%
  emmeans(~ TestSpeaker:Group) 
rec_MMR_m = contrast(rec_MMR_m, method = custom_contrasts)
contrasts(rec_MMR_m)

contrasts(custom_contrasts) <- contr.equalprior_pairs


# Bayes Factors (Savage-Dickey density ratio)
BF_rec <-
  rec_MMR_m %>%
  bf_parameters(prior = rec_MMR_m_prior) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
BF_rec <-
  BF_rec %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_rec$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_rec

# check priors equal?
# --> they're not, because unfam2-fam1 differ both for group and TestSpeaker. 
# I have no idea how to set that such that the priors would also be equal here
ggplot(stack(insight::get_parameters(rec_MMR_m_prior)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values") +
  theme(legend.position = "none")

point_estimate(rec_MMR_m_prior, centr = "mean", disp = TRUE)

# # Model for the continuous factors:
# Nr speakers
# Bayes Factors (Savage-Dickey density ratio)
BF_rec_nrSpeakers_MMR_m = bf_parameters(MMR_m_rec, parameters = "b_nrSpeakersDaily", direction = ">")

BF_rec_nrSpeakers_MMR_m <-
  BF_rec_nrSpeakers_MMR_m %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_rec_nrSpeakers_MMR_m$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )
BF_rec_nrSpeakers_MMR_m
plot(BF_rec_nrSpeakers_MMR_m)



# rec_MMR_m_prior <- unupdate(MMR_m_rec) # sample priors from model
# 
# # pairwise comparisons of prior distributions
# nrSpeakers_rec_MMR_m_prior_pairwise <-
#   rec_MMR_m_prior %>%
#   emmeans(~ nrSpeakersDaily) 
# 
# # pairwise comparisons of posterior distributions
# nrSpeakers_rec_MMR_m_pairwise <-
#   MMR_m_rec %>%
#   emmeans(~ nrSpeakersDaily) 
# 
# # Bayes Factors (Savage-Dickey density ratio)
# # Calculates the density around 0 for the subtracted (posterior - prior) distributions. 
# # So if that density is very high, you have no support for your Ha. (because there are a lot
# # of values around zero)
# BF_rec_nrSpeakers_MMR_m <-
#   nrSpeakers_rec_MMR_m_pairwise %>%
#   bf_parameters(prior = nrSpeakers_rec_MMR_m_prior_pairwise) %>%
#   arrange(log_BF) # sort according to BF
# 
# # add rule-of-thumb interpretation
# # Add rule of thumb interpretation: looks at value and tells use what it means according to the
# # rules of raftery1995. You add the column for interpretability, but you want to keep the other 
# # stuff too because the cool thing is that BA gives you something continuous. So don’t just cut 
# # if off with a rule of thumb!
# BF_rec_nrSpeakers_MMR_m <-
#   BF_rec_nrSpeakers_MMR_m %>%
#   add_column(
#     "interpretation" = interpret_bf(
#       BF_rec_nrSpeakers_MMR_m$log_BF,
#       rules = "raftery1995",
#       log = TRUE,
#       include_value = TRUE,
#       protect_ratio = TRUE,
#       exact = TRUE
#     ),
#     .after = "log_BF"
#   )
# 
# BF_rec_nrSpeakers_MMR_m


## Sleep State
rec_MMR_m_prior <- unupdate(MMR_m_rec) # sample priors from model

#  comparison of prior distributions
sleep_rec_MMR_m_prior <-
  rec_MMR_m_prior %>%
  emmeans(~ sleepState)
sleep_rec_MMR_m_prior = contrast(sleep_rec_MMR_m_prior, method = custom_contrasts_sleep)

#  comparison of posterior distributions
rec_sleep_MMR_m <-
  MMR_m_rec %>%
  emmeans(~ sleepState) 
rec_sleep_MMR_m = contrast(rec_sleep_MMR_m, method = custom_contrasts_sleep)

# Bayes Factors (Savage-Dickey density ratio)
BF_rec_sleep <-
  rec_sleep_MMR_m %>%
  bf_parameters(prior = sleep_rec_MMR_m_prior) %>%
  arrange(log_BF) # sort according to BF

# add rule-of-thumb interpretation
BF_rec_sleep <-
  BF_rec_sleep %>%
  add_column(
    "interpretation" = interpret_bf(
      BF_rec_sleep$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

BF_rec_sleep
plot(BF_rec_sleep)

# check priors equal?
# --> they're not, because the first two combine two states. 
# I have no idea how to set that such that the priors would also be equal here
# but I don't compare the 3rd contrast against the other two, so I think it's fine here
ggplot(stack(insight::get_parameters(sleep_rec_MMR_m_prior)), aes(x = values, fill = ind)) +
  geom_density(linewidth = 1) +
  facet_grid(ind ~ .) +
  labs(x = "prior difference values") +
  theme(legend.position = "none")

point_estimate(sleep_rec_MMR_m_prior, centr = "mean", disp = TRUE)




# output BF: 
# - “Evidence against the null: 0” this does not have to be 0. Can be another model for example
# BA(10): first looking at alternative and then null. 
# This is what’s always is used in the table. So if there is strong evidence against ha, 
# there is strong evidence for null. So then you need to calculate 1/BF 
# (then you get BA(01), first looking at the null, then at the alternative). 
# And then you get your Bayes factor for the null hypothesis.
# this is also explained well in JASP





## ADAPT
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
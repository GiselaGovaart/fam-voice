
library(emmeans)
library(easystats)
library(brms)
library(tidyverse)
library(here)
library(see)

# set-up:
project_seed = 2049
set.seed(project_seed) 

# Make df, with 12 subjects, with:
# Group (between subj factor): levels "fam" and "unfam"
# TestSpeaker (within): levels 1,2,3
# sleepState (between): levels awake, activesleep, quietsleep
# MMR: dependent variable
df = structure(list(Subj = structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 
                                       3L, 3L, 4L, 4L, 4L, 5L, 5L, 5L, 6L, 6L, 6L, 7L, 7L, 7L, 8L, 8L, 
                                       8L, 9L, 9L, 9L, 10L, 10L, 10L, 11L, 11L, 11L, 12L, 12L, 12L), 
                                     levels = c("Subj01","Subj02", "Subj03", "Subj04", "Subj05", "Subj06", 
                                                "Subj07", "Subj08","Subj09", "Subj10", "Subj11", "Subj12"), 
                                     class = "factor"),
                    Group = structure(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
                                        1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
                                        2L, 2L, 2L), levels = c("fam", "unfam"), class = "factor"), 
                    TestSpeaker = structure(c(1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 
                                              3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 
                                              1L, 2L, 3L), levels = c("1", "2", "3"), class = "factor"),
                    MMR = c(38.3193739833394,-26.3345733319488, -36.5391489690257, 17.6727210461579, 13.0723969801114, 
                            -4.24116674572545, 21.2481968372323, 11.4709975141478, 1.82856457361663, 
                            43.7294164718069, 20.3131479540544, 0.785675781481198, -2.15902787287105, 
                            -25.4903371611785, 61.873025266565, 9.06733331354276, -18.7574284113092, 
                            6.33216574768327, -34.9097027199614, -3.96327639212982, 15.9747552016853, 
                            -38.801070417319, -6.46518128748102, -22.630432474398, 21.9291933267653, 
                            24.4946719999554, -31.2847387815119, -8.04032285881707, 14.2321054924562, 
                            8.80183458992482, 18.9550435474235, 33.2621031208136, -11.4198082197363, 
                            -14.7150081652997, 29.2510483128696, -31.1494998323233), 
                    sleepState = structure(c(2L,2L, 2L, 3L, 3L, 3L, 2L, 2L, 2L, 2L, 2L, 2L, 3L, 3L, 3L, 1L, 1L, 
                                             1L, 1L, 1L, 1L, 1L, 1L, 1L, 3L, 3L, 3L, 1L, 1L, 1L, 2L, 2L, 2L, 
                                             1L, 1L, 1L), levels = c("awake", "activesleep", "quietsleep"), class = "factor")),
               row.names = c(NA,-36L), class = c("tbl_df", "tbl", "data.frame"))

### MODEL 1: With  contr.equalprior set globally
options(contrasts = c("contr.equalprior", "contr.poly"))

m1 = brm(MMR ~ 1 + TestSpeaker * Group +
        sleepState * TestSpeaker +
        (1 + TestSpeaker * Group | Subj),
      data = df,
      family = gaussian(),
      prior = c(set_prior("normal(5.97, 23.34)",
                          class = "Intercept"),
                set_prior("normal(0, 23.34)",
                          class = "b"),
                set_prior("normal(0, 23.34)",
                          class = "sigma")),
      init = "random",
      control = list(
        adapt_delta = .99,
        max_treedepth = 15
      ),
      chains = 4,
      iter = 4000,
      warmup = 2000,
      thin = 1,
      algorithm = "sampling",
      cores = 4,
      seed = project_seed,
      save_pars = save_pars(all = TRUE)
)

### MODEL 2: With  contr.equalprior_pairs set globally
options(contrasts = c("contr.equalprior_pairs", "contr.poly"))
m2 = brm(MMR ~ 1 + TestSpeaker * Group +
        sleepState * TestSpeaker +
        (1 + TestSpeaker * Group | Subj),
      data = df,
      family = gaussian(),
      prior = c(set_prior("normal(5.97, 23.34)",
                          class = "Intercept"),
                set_prior("normal(0, 23.34)",
                          class = "b"),
                set_prior("normal(0, 23.34)",
                          class = "sigma")),
      init = "random",
      control = list(
        adapt_delta = .99,
        max_treedepth = 15
      ),
      chains = 4,
      iter = 4000,
      warmup = 2000,
      thin = 1,
      algorithm = "sampling",
      cores = 4,
      seed = project_seed,
      save_pars = save_pars(all = TRUE)
  )


## Question 1 -------
# The contrast matrices are different:
contrasts(df$TestSpeaker) <- contr.equalprior_pairs
contrasts(df$TestSpeaker)
contrasts(df$TestSpeaker) <- contr.equalprior
contrasts(df$TestSpeaker)

# Both contr.equalprior and contr.equalprior_pairs give me equal priors:
m_prior <- unupdate(m1, verbose=FALSE) # sample priors from model
m_prior_pairwise <-
  m_prior %>%
  emmeans(~ TestSpeaker)  %>%
  pairs()
# Priors for m1:
point_estimate(m_prior_pairwise, centr = "mean", disp = TRUE)

m_prior <- unupdate(m2, verbose=FALSE) # sample priors from model
m_prior_pairwise <-
  m_prior %>%
  emmeans(~ TestSpeaker)  %>%
  pairs()
# Priors for m2:
point_estimate(m_prior_pairwise, centr = "mean", disp = TRUE)


## Question 2 --------
### Question 2A
# I compare some pairs of the interaction between TestSpeaker*Group. 
# create a custom contrast matrix:
MMR.emm1 = m2 %>%
  emmeans(~ Group:TestSpeaker) 
MMR.emm1 # to set the custom contrast correctly

fam1 = c(1,0,0,0,0,0)
unfam1 = c(0,1,0,0,0,0)
fam2 = c(0,0,1,0,0,0)
unfam2 = c(0,0,0,1,0,0)
fam3 = c(0,0,0,0,1,0)
unfam3 = c(0,0,0,0,0,1)

custom_contrasts <- list(
  list("unfam2-fam1" = unfam2 - fam1),
  list("unfam2-unfam3" = unfam2 - unfam3),
  list("unfam1-unfam2" = unfam1 - unfam2),
  list("fam2-fam3" = fam2-fam3),
  list("((unfam2-unfam3)-(fam2-fam3))" = ((unfam2 - unfam3) - (fam2 - fam3)))
) 

# Compute the BF for these contrasts
# For m1:
#  comparison of prior distributions
m1_prior <- unupdate(m1, verbose=FALSE) # sample priors from model
m1_prior_pairs <-
  m1_prior %>%
  emmeans(~ Group:TestSpeaker)
m1_prior_pairs = contrast(m1_prior_pairs, method = custom_contrasts)
#  comparison of posterior distributions
m1_post_pairs <-
  m1 %>%
  emmeans(~ TestSpeaker:Group) 
m1_post_pairs = contrast(m1_post_pairs, method = custom_contrasts)
# Bayes Factors (Savage-Dickey density ratio)
BF_m1 <-
  m1_post_pairs %>%
  bf_parameters(prior = m1_prior_pairs) %>%
  arrange(log_BF) # sort according to BF
BF_m1
plot(BF_m1)

# For m2:
#  comparison of prior distributions
m2_prior <- unupdate(m2, verbose=FALSE) # sample priors from model
m2_prior_pairs <-
  m2_prior %>%
  emmeans(~ Group:TestSpeaker)
m2_prior_pairs = contrast(m2_prior_pairs, method = custom_contrasts)
#  comparison of posterior distributions
m2_post_pairs <-
  m2 %>%
  emmeans(~ TestSpeaker:Group) 
m2_post_pairs = contrast(m2_post_pairs, method = custom_contrasts)
# Bayes Factors (Savage-Dickey density ratio)
BF_m2 <-
  m2_post_pairs %>%
  bf_parameters(prior = m2_prior_pairs) %>%
  arrange(log_BF) # sort according to BF
BF_m2
plot(BF_m2)

# Check priors on the contrasts:
point_estimate(m1_prior_pairs, centr = "mean", disp = TRUE)
point_estimate(m2_prior_pairs, centr = "mean", disp = TRUE)

### Question 2B
# Contrasts for the factor sleepState:
# make custom contrast:
MMR.emm2 = m2 %>%
  emmeans(~ sleepState) 
MMR.emm2 # to set the custom contrast correctly
# set custom contrast sleep
custom_contrasts_sleep <- list(
  list("awake - activesleep and quietsleep" = c(1, -1/2, -1/2)),
  list("quietsleep - awake and activesleep" = c(-1/2, -1/2, 1)),
  list("quietsleep vs activesleep" =c(0, 1, -1))
)

# Compute BFs (only for model 2)
#  comparison of prior distributions
m2_prior <- unupdate(m2, verbose=FALSE) # sample priors from model
m2_prior_sleep <-
  m2_prior %>%
  emmeans(~ sleepState)
m2_prior_sleep = contrast(m2_prior_sleep, method = custom_contrasts_sleep)
#  comparison of posterior distributions
m2_post_sleep <-
  m2 %>%
  emmeans(~ sleepState) 
m2_post_sleep = contrast(m2_post_sleep, method = custom_contrasts_sleep)
# Bayes Factors (Savage-Dickey density ratio)
BF_m2_sleep <-
  m2_post_sleep %>%
  bf_parameters(prior = m2_prior_sleep) %>%
  arrange(log_BF) # sort according to BF
BF_m2_sleep
plot(BF_m2_sleep)

# Check the priors:
point_estimate(m2_prior_sleep, centr = "mean", disp = TRUE)





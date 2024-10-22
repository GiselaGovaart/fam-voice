MMR_m_rec_orig <- readRDS(here("data", "model_output", "samples_MMR_rec_orig.rds"))
MMR_m_rec_orig_saveparsfalse <- readRDS(here("data", "model_output", "samples_MMR_rec_orig_saveparsfalse.rds"))
MMR_m_rec_epoptions <- readRDS(here("data", "model_output", "samples_MMR_rec_equalpriors.rds"))


# With ORIG
options(contrasts = c("contr.treatment", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# Parameter                   |  Mean |    SD
# -------------------------------------------
# TestSpeaker1 - TestSpeaker2 | -0.16 | 25.83
# TestSpeaker1 - TestSpeaker3 | -0.46 | 26.06
# TestSpeaker2 - TestSpeaker3 | -0.31 | 36.88


options(contrasts = c("contr.equalprior", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# Parameter                   |  Mean |    SD
# -------------------------------------------
# TestSpeaker1 - TestSpeaker2 | -0.10 | 26.07
# TestSpeaker1 - TestSpeaker3 |  0.15 | 26.29
# TestSpeaker2 - TestSpeaker3 |  0.25 | 36.82


options(contrasts = c("contr.equalprior", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig_saveparsfalse) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)

# Parameter                   |  Mean |    SD
# -------------------------------------------
# TestSpeaker1 - TestSpeaker2 |  0.12 | 32.96
# TestSpeaker1 - TestSpeaker3 | -0.15 | 33.25
# TestSpeaker2 - TestSpeaker3 | -0.27 | 32.62

options(contrasts = c("contr.equalprior_pairs", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig_saveparsfalse) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# Parameter                   |  Mean |    SD
# -------------------------------------------
# TestSpeaker1 - TestSpeaker2 |  0.10 | 33.24
# TestSpeaker1 - TestSpeaker3 | -0.17 | 32.81
# TestSpeaker2 - TestSpeaker3 | -0.27 | 32.20

options(contrasts = c("contr.treatment", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_epoptions) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ TestSpeaker) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)

# Parameter                   |  Mean |    SD
# -------------------------------------------
# TestSpeaker1 - TestSpeaker2 | -0.27 | 33.07
# TestSpeaker1 - TestSpeaker3 | -0.14 | 33.14
# TestSpeaker2 - TestSpeaker3 |  0.12 | 33.34



# FOR SLEEP
options(contrasts = c("contr.treatment", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ sleepState) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# Parameter                |  Mean |    SD
# ----------------------------------------
# activesleep - awake      | -0.12 | 23.96
# activesleep - quietsleep | -0.03 | 22.91
# awake - quietsleep       |  0.09 | 32.99

options(contrasts = c("contr.equalprior", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig_saveparsfalse) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ sleepState) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)
# Parameter                |  Mean |    SD
# ----------------------------------------
# activesleep - awake      | -0.32 | 32.77
# activesleep - quietsleep |  0.04 | 32.46
# awake - quietsleep       |  0.36 | 32.29


options(contrasts = c("contr.equalprior_pairs", "contr.poly"))
MMR_m_rec_orig_prior <- unupdate(MMR_m_rec_orig_saveparsfalse) # sample priors from model
MMR_m_rec_orig_prior_pairwise <-
  MMR_m_rec_orig_prior %>%
  emmeans(~ sleepState) %>% # estimated marginal means
  pairs() # pairwise comparisons

point_estimate(MMR_m_rec_orig_prior_pairwise, centr = "mean", disp = TRUE)

# Parameter                |  Mean |    SD
# ----------------------------------------
# activesleep - awake      |  0.51 | 32.83
# activesleep - quietsleep |  0.08 | 32.80
# awake - quietsleep       | -0.43 | 33.18



# with custom contrasts

options(contrasts = c("contr.equalprior", "contr.poly"))
m_prior_equalpriorpairs <- unupdate(MMR_m_rec_orig_saveparsfalse) # sample priors from model
m_prior_equalpriorpairs_pairwise <-
  m_prior_equalpriorpairs %>%
  emmeans(~ Group:TestSpeaker) 

contrast(m_prior_equalpriorpairs_pairwise, method = custom_contrasts_group_speaker)
est = contrast(m_prior_equalpriorpairs_pairwise, method = custom_contrasts_group_speaker)
point_estimate(est, centr = "mean", disp = TRUE)

# Parameter     |  Mean |    SD
# -----------------------------
# unfam2-fam1   | -0.02 | 48.73
# unfam2-unfam3 | -0.45 | 39.91
# unfam1-unfam2 |  0.46 | 39.85


options(contrasts = c("contr.equalprior_pairs", "contr.poly"))
m_prior_equalpriorpairs <- unupdate(MMR_m_rec_orig_saveparsfalse) # sample priors from model
m_prior_equalpriorpairs_pairwise <-
  m_prior_equalpriorpairs %>%
  emmeans(~ Group:TestSpeaker) 

contrast(m_prior_equalpriorpairs_pairwise, method = custom_contrasts_group_speaker)
est = contrast(m_prior_equalpriorpairs_pairwise, method = custom_contrasts_group_speaker)
point_estimate(est, centr = "mean", disp = TRUE)

# Parameter     |  Mean |    SD
# -----------------------------
# unfam2-fam1   | -0.28 | 47.64
# unfam2-unfam3 | -0.38 | 40.34
# unfam1-unfam2 |  0.52 | 40.50



options(contrasts = c("contr.treatment", "contr.poly"))
m_prior_treatment <- unupdate(MMR_m_rec_orig_saveparsfalse) # sample priors from model
m_prior_treatment_pairwise <-
  m_prior_treatment %>%
  emmeans(~ Group:TestSpeaker) 

contrast(m_prior_treatment_pairwise, method = custom_contrasts_group_speaker)
est = contrast(m_prior_treatment_pairwise, method = custom_contrasts_group_speaker)
point_estimate(est, centr = "mean", disp = TRUE) # give me the priors on the contrasts:

# Parameter     |  Mean |    SD
# -----------------------------
# unfam2-fam1   |  0.20 | 49.16
# unfam2-unfam3 | -0.12 | 40.88
# unfam1-unfam2 | -0.03 | 39.94




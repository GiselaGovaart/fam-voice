# sensitivity analysis for BF

# code adapted from Nicenboim, Bruno, Daniel Schad, and Shravan Vasishth. "An introduction to Bayesian data analysis for cognitive science.
# https://vasishth.github.io/bayescogsci/book/

# We will most likely find something like:
# What we see is that if we assume a very low effect size (SD is low), 
# we have support for M1, but if we assume a very big effect size (SD is very high) we find support for the M0.
# This is always the case --> if you assume a very big effect size (a very broad prior) we will per definition
# find support for the H0.
# So we just need to describe what we see in this plot to make sure that our BF is not solely dependent on our priors

# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed


# load packages ------------------------
library(brms)
library(emmeans)
library(bayestestR)
library(dplyr)
library(here)
library(ggplot2)
library(papaja)

# set values ----------------------------
num_chains <- 4 # number of chains = number of processor cores
num_iter <- 80000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain

# Run the model with different sds 
prior_sd <- c(1, 5, 8, 10, 15, 20, 30, 40, 50)

# ROI normal ----------
# Run the models
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- brm(MMR ~ 1 + TestSpeaker + 
               mumDist + 
               nrSpeakersDaily +
               sleepState +
               age +
               (1 + TestSpeaker | Subj),
             data = data_recfam_normal,
             prior = c(
               set_prior("normal(3.5, 20)", class = "Intercept"),
               set_prior(paste0("normal(0,", psd, ")"), class = "b"),
               set_prior("normal(0, 20)", class = "sigma")
             ),
             family = gaussian(), 
             control = list(
               adapt_delta = .99, 
               max_treedepth = 15
             ),
             iter = num_iter, 
             chains = num_chains, 
             warmup = num_warmup,
             thin = num_thin,
             cores = num_chains, 
             seed = project_seed,
             save_pars = save_pars(all = TRUE),
             file=here("data", "sensitivity_analysis", paste0("Rfam5_normal_sensAnal_BF_priorsd_", psd, ".rds"))             
  )
}

# Custom contrasts
fam1 =   c(1,0,0)
fam3 =   c(0,1,0)
fam4 =   c(0,0,1)

custom_contrasts <- list(
  list("fam1-fam4" = fam1 - fam4),
  list("fam3-fam4" = fam3 - fam4),
  list("fam1-fam3" = fam1 - fam3)
)

## BFs-------------------------
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- readRDS(here("data", "sensitivity_analysis", paste0("Rfam5_normal_sensAnal_BF_priorsd_", psd, ".rds")))
  fit_priors <- unupdate(fit)

  m_prior <- fit_priors %>%
    emmeans(~ TestSpeaker) %>%
    contrast(method = custom_contrasts)
  
  m_post <- fit %>%
    emmeans(~ TestSpeaker) %>%
    contrast(method = custom_contrasts)
  
  BF_current <- bf_parameters(m_post, prior = m_prior) %>%
    filter(Parameter == "fam1-fam4")
  BF_current <- as.numeric(BF_current)
  
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF = log10(BF))
save(res, file = here("data", "sensitivity_analysis", "Rfam5_normal_sensAnal_BF_fam1-fam4.rda"))
# res_groupS2_acq = load(here("data", "sensitivity_analysis","Rfam5_normal_sensAnal_BF_fam1-fam4.rda"))

## Plot --------------------------------
breaks <- c(1 / 100, 1 / 50, 1 / 20, 1 / 10,1 / 5, 1 / 3,1,  3, 5, 10, 20, 50, 100)
p = ggplot(res, aes(x = prior_sd, y = BF)) +
  geom_point(size = 2) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous("Normal prior width (SD)\n") +
  scale_y_log10(expression("BF"[10]), breaks = breaks, labels = MASS::fractions(breaks)) +
  coord_cartesian(ylim = c(1 / 100, 100), xlim = c(0, tail(prior_sd, n = 1))) +
  annotate("text", x = 40, y = 30, label = expression("Evidence in favor of H"[1]), size = 5) +
  annotate("text", x = 40, y = 1 / 30, label = expression("Evidence in favor of H"[0]), size = 5) +
  theme(axis.text.y = element_text(size = 8)) +
  # ggtitle("Bayes factors for contrast fam1-fam4 (ROI normal") +
  theme_apa()

# Save
plot(p)
png(file=here("data", "sensitivity_analysis", "Rfam5_normal_sensAnal_BF_fam1-fam4.png"),
    width=3800, height=3000,res=600)
plot(p)
dev.off()


# ROI frontal ----------
# Run the models
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- brm(MMR ~ 1 + TestSpeaker  + 
               mumDist + 
               nrSpeakersDaily +
               sleepState +
               age +
               (1 + TestSpeaker | Subj),
             data = data_recfam_frontal,
             prior = c(
               set_prior("normal(3.5, 20)", class = "Intercept"),
               set_prior(paste0("normal(0,", psd, ")"), class = "b"),
               set_prior("normal(0, 20)", class = "sigma")
             ),
             family = gaussian(), 
             control = list(
               adapt_delta = .99, 
               max_treedepth = 15
             ),
             iter = num_iter, 
             chains = num_chains, 
             warmup = num_warmup,
             thin = num_thin,
             cores = num_chains, 
             seed = project_seed,
             save_pars = save_pars(all = TRUE),
             file=here("data", "sensitivity_analysis", paste0("Rfam5_frontal_sensAnal_BF_priorsd_", psd, ".rds"))             
  )
}

# Custom contrasts
fam1 =   c(1,0,0)
fam3 =   c(0,1,0)
fam4 =   c(0,0,1)

custom_contrasts <- list(
  list("fam1-fam4" = fam1 - fam4),
  list("fam3-fam4" = fam3 - fam4),
  list("fam1-fam3" = fam1 - fam3)
)

## BFs-------------------------
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- readRDS(here("data", "sensitivity_analysis", paste0("Rfam5_frontal_sensAnal_BF_priorsd_", psd, ".rds")))
  fit_priors <- unupdate(fit)
  
  m_prior <- fit_priors %>%
    emmeans(~ TestSpeaker) %>%
    contrast(method = custom_contrasts)
  
  m_post <- fit %>%
    emmeans(~ TestSpeaker) %>%
    contrast(method = custom_contrasts)
  
  BF_current <- bf_parameters(m_post, prior = m_prior) %>%
    filter(Parameter == "fam1-fam4")
  BF_current <- as.numeric(BF_current)
  
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF = log10(BF))
save(res, file = here("data", "sensitivity_analysis", "Rfam5_frontal_sensAnal_BF_fam1-fam4.rda"))
#res = load(here("data", "sensitivity_analysis","Rfam5_frontal_sensAnal_BF_fam1-fam4.rda"))

## Plot --------------------------------
breaks <- c(1 / 100, 1 / 50, 1 / 20, 1 / 10,1 / 5, 1 / 3,1,  3, 5, 10, 20, 50, 100)
p = ggplot(res, aes(x = prior_sd, y = BF)) +
  geom_point(size = 2) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous("Normal prior width (SD)\n") +
  scale_y_log10(expression("BF"[10]), breaks = breaks, labels = MASS::fractions(breaks)) +
  coord_cartesian(ylim = c(1 / 100, 100), xlim = c(0, tail(prior_sd, n = 1))) +
  annotate("text", x = 40, y = 30, label = expression("Evidence in favor of H"[1]), size = 5) +
  annotate("text", x = 40, y = 1 / 30, label = expression("Evidence in favor of H"[0]), size = 5) +
  theme(axis.text.y = element_text(size = 8)) +
  # ggtitle("Bayes factors for contrast fam1-fam4 (ROI frontal") +
  theme_apa()

# Save
plot(p)
png(file=here("data", "sensitivity_analysis", "Rfam5_frontal_sensAnal_BF_fam1-fam4.png"),
    width=3800, height=3000,res=600)
plot(p)
dev.off()
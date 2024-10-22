# sensitivity analysis for BF

# code adapted from Nicenboim, Bruno, Daniel Schad, and Shravan Vasishth. "An introduction to Bayesian data analysis for cognitive science.
# https://vasishth.github.io/bayescogsci/book/

# We will most likely find something like:
# What we see is that if we assume a very low effect size (SD is low), 
# we have support for M1, but if we assume a very big effect size (SD is very high) we find support for the M0.
# This is always the case --> if you assume a very big effect size (a very broad prior) we will per definition
# find support for the H0.
# So we just need to describe what we see in this plot to make sure that our BF is not solely dependent on our priors


### load packages ------------------------
library(brms)
library(emmeans)
library(bayestestR)
library(dplyr)
library(here)
library(ggplot2)

### set values ----------------------------
num_chains <- 4 # number of chains = number of processor cores
num_iter <- 20000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain


# RECOGNITION ----------------------------------------
# Run the model with different sds
# prior_sd <- c(1, 5, 8, 10, 15, 20, 30, 40, 50)
prior_sd <- c(5, 20)

# Run the models
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- brm(MMR ~ 1 + TestSpeaker * Group + 
               mumDist + 
               nrSpeakersDaily +
               sleepState +
               age +
               (1 + TestSpeaker | Subj),
             data = dat_rec,
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
             file=here("data", "sensitivity_analysis", paste0("R5_sensAnal_BF_priorsd_", psd, ".rds"))             
  )
}

### Contrast 1: unfam2-fam1 -------------------------
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- readRDS(here("data", "sensitivity_analysis", paste0("R5_sensAnal_BF_priorsd_", psd, ".rds")))
  fit_priors <- unupdate(fit)
  
  m_prior <- fit_priors %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam2-fam1" = unfam2 - fam1))
  
  m_post <- fit %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam2-fam1" = unfam2 - fam1))
  
  BF_current <- bf_parameters(m_post, prior = m_prior) 
  BF_current <- as.numeric(BF_current)
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF = log10(BF))
save(res, file=here("data", "sensitivity_analysis","R5_sensAnal_BF_unfam2-fam1.rda"))
#load("R5_sensAnal_BF_unfam2-fam1.rda)

breaks <- c(1 / 100, 1 / 50, 1 / 20, 1 / 10, 1 / 3, 1, 3, 5, 10, 20, 50, 100)
ggplot(res, aes(x = prior_sd, y = BF)) +
  geom_point(size = 2) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous("Normal prior width (SD)\n") +
  scale_y_log10("BF10", breaks = breaks, labels = MASS::fractions(breaks)) +
  coord_cartesian(ylim = c(1 / 100, 100), xlim = c(0, tail(prior_sd, n = 1) + 40)) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 30, label = "Evidence in favor of H1", size = 5) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 1 / 30, label = "Evidence in favor of H0", size = 5) +
  theme(axis.text.y = element_text(size = 8)) +
  ggtitle("Bayes factors for unfam2-fam1")


### Contrast 2: unfam2-unfam3 -------------------------
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- readRDS(here("data", "sensitivity_analysis", paste0("R5_sensAnal_BF_priorsd_", psd, ".rds")))
  fit_priors <- unupdate(fit)
  
  m_prior <- fit_priors %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam2-unfam3" = unfam2 - unfam3))
  m_post <- fit %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam2-unfam3" = unfam2 - unfam3))
  
  BF_current <- bf_parameters(m_post, prior = m_prior) 
  BF_current <- as.numeric(BF_current)
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF = log10(BF))
save(res, file=here("data", "sensitivity_analysis","R5_sensAnal_BF_unfam2-unfam3.rda"))
#load("R5_sensAnal_BF_unfam2-unfam3.rda)

breaks <- c(1 / 100, 1 / 50, 1 / 20, 1 / 10, 1 / 3, 1, 3, 5, 10, 20, 50, 100)
ggplot(res, aes(x = prior_sd, y = BF)) +
  geom_point(size = 2) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous("Normal prior width (SD)\n") +
  scale_y_log10("BF10", breaks = breaks, labels = MASS::fractions(breaks)) +
  coord_cartesian(ylim = c(1 / 100, 100), xlim = c(0, tail(prior_sd, n = 1) + 40)) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 30, label = "Evidence in favor of H1", size = 5) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 1 / 30, label = "Evidence in favor of H0", size = 5) +
  theme(axis.text.y = element_text(size = 8)) +
  ggtitle("Bayes factors for unfam2-unfam3")


### Contrast 3: unfam2-unfam1 -------------------------
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- readRDS(here("data", "sensitivity_analysis", paste0("R5_sensAnal_BF_priorsd_", psd, ".rds")))
  fit_priors <- unupdate(fit)
  
  m_prior <- fit_priors %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam2-unfam1" = unfam2 - unfam1))
  m_post <- fit %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam2-unfam1" = unfam2 - unfam1))
  
  BF_current <- bf_parameters(m_post, prior = m_prior) 
  BF_current <- as.numeric(BF_current)
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF = log10(BF))
save(res, file=here("data", "sensitivity_analysis","R5_sensAnal_BF_unfam2-unfam1.rda"))
#load("R5_sensAnal_BF_unfam2-unfam1.rda)

breaks <- c(1 / 100, 1 / 50, 1 / 20, 1 / 10, 1 / 3, 1, 3, 5, 10, 20, 50, 100)
ggplot(res, aes(x = prior_sd, y = BF)) +
  geom_point(size = 2) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous("Normal prior width (SD)\n") +
  scale_y_log10("BF10", breaks = breaks, labels = MASS::fractions(breaks)) +
  coord_cartesian(ylim = c(1 / 100, 100), xlim = c(0, tail(prior_sd, n = 1) + 40)) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 30, label = "Evidence in favor of H1", size = 5) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 1 / 30, label = "Evidence in favor of H0", size = 5) +
  theme(axis.text.y = element_text(size = 8)) +
  ggtitle("Bayes factors for unfam2-unfam1")


### Contrast 4: unfam1-unfam3 -------------------------
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- readRDS(here("data", "sensitivity_analysis", paste0("R5_sensAnal_BF_priorsd_", psd, ".rds")))
  fit_priors <- unupdate(fit)
  
  m_prior <- fit_priors %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam1-unfam3" = unfam1 - unfam3))
  m_post <- fit %>%
    emmeans(~ Group : TestSpeaker) %>%
    contrast(method = list("unfam1-unfam3" = unfam1 - unfam3))
  
  BF_current <- bf_parameters(m_post, prior = m_prior) 
  BF_current <- as.numeric(BF_current)
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF = log10(BF))
save(res, file=here("data", "sensitivity_analysis","R5_sensAnal_BF_unfam1-unfam3.rda"))
#load("R5_sensAnal_BF_unfam1-unfam3.rda)

breaks <- c(1 / 100, 1 / 50, 1 / 20, 1 / 10, 1 / 3, 1, 3, 5, 10, 20, 50, 100)
ggplot(res, aes(x = prior_sd, y = BF)) +
  geom_point(size = 2) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous("Normal prior width (SD)\n") +
  scale_y_log10("BF10", breaks = breaks, labels = MASS::fractions(breaks)) +
  coord_cartesian(ylim = c(1 / 100, 100), xlim = c(0, tail(prior_sd, n = 1) + 40)) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 30, label = "Evidence in favor of H1", size = 5) +
  annotate("text", x = tail(prior_sd, n = 1) + 20, y = 1 / 30, label = "Evidence in favor of H0", size = 5) +
  theme(axis.text.y = element_text(size = 8)) +
  ggtitle("Bayes factors for unfam1-unfam3")


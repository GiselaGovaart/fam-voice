# Code for Exploratory analysis 


# load packages --------------------------------------------------------------------
library(worcs)
library(here)
library(tidyr)
library(dplyr)
library(easystats)

here()

# load data  -------------------------------------------------------------------

data_acq_earlyTW = read_csv(here("data/data_acq_earlyTW.csv"))


# 1. Prior Predictive Checks -----------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

library(brms)
library(here)

# Set priors 
priors <- c(set_prior("normal(3.5, 20)",  
                      class = "Intercept"),
            set_prior("normal(0, 10)",  
                      class = "b"),
            set_prior("normal(0, 20)",  
                      class = "sigma"))

# Set up sampling
num_chains <- 4 
num_iter <- 4000 
num_warmup <- num_iter / 2 
num_thin <- 1 

priorpredcheck_acq_earlyTW <- brm(MMR ~ 1 + TestSpeaker * Group + 
                            mumDist +
                            nrSpeakersDaily  + 
                            sleepState + 
                            age +
                            (1 + TestSpeaker | Subj),
                          data = data_acq_earlyTW,
                          prior = priors,
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
                          file = here("data", "model_output", "E0_model_priorpredcheck_acq_earlyTW.rds"),
                          file_refit = "on_change",
                          save_pars = save_pars(all = TRUE),
                          sample_prior = "only"
)

priorpredcheck_acq_earlyTW <- readRDS(here("data", "model_output", "E0_model_priorpredcheck_acq_earlyTW.rds"))
pp <- posterior_predict(priorpredcheck_acq_earlyTW) 
pp <- t(pp)
# distribution of mean MMR
meanMMR = colMeans(pp)
hist(meanMMR, breaks = 40)

summary(priorpredcheck_acq_earlyTW)


# 2. PARAMETER ESTIMATION --------------------------------------------------------

# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(easystats)

# setup: STAN --------------------------------------------------------------------
# here we set up the sampling. 
# num_chains:  how many processor cores you want to run in parallel (always leave some of your computer's processors unused!)
# num_warmup: the warmup samples are those samples that are at the beginning of the chain that
# you want to discard. You do that, because at the beginning, the algorithm is still figuring
# out what the parameter space is, and therefore these samples might contain bad parameters.
# So you just get rid of the first couple of them to make sure you only end up with good ones
# (and you get the pretty fat hairy caterpillar, which you will check in your model diagnostics)
# num_thin: if that’s 2, you only take every second sample. Because it’s possible that there
# is high auto-correlation in the samples, and then you’d want to get rid of it. Usually 
# it’s not a problem, it’s taken care of by the warm up too. So it’s fine to take 1.

num_chains <- 4 # number of chains = number of processor cores
num_iter <- 80000 # number of samples per chain: because I use Savage-Dickey for hypothesis testing, so we need a LOT of samples
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain

# Set priors ------------------------------------------------------------
priors <- c(set_prior("normal(3.5, 20)", 
                      class = "Intercept"),
            set_prior("normal(0, 10)",  
                      class = "b"),
            set_prior("normal(0, 20)",  
                      class = "sigma")) 

# Run the model ------------------------------------------------------
model_acq_earlyTW = brm(MMR ~ 1 + TestSpeaker * Group +
                  mumDist +
                  nrSpeakersDaily +
                  sleepState +
                  age +
                  (1 + TestSpeaker | Subj),
                data = data_acq_earlyTW,
                prior = priors,
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
                file = here("data", "model_output", "E2_model_acq_earlyTW.rds"),
                file_refit = "on_change",
                save_pars = save_pars(all = TRUE)
)


# 3. HYPOTHESIS TESTING --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(easystats)
library(emmeans) 
library(logspline)

# setup --------------------------------------------------------------------

# Hypotheses -------------------------------------------------------------------
# For this exploratory Acquisition RQ, we want the following comparisons
# 2. For test_speaker = Speaker2, the mmr is different for group=fam vs group = unfam.


model_acq_earlyTW <- readRDS(here("data", "model_output", "E2_model_acq_earlyTW.rds"))

# MAP-Based p-Value (pMAP) --------------------------------------------------------
# # Effect all
# pMAP_all_acq_earlyTW <- model_acq_earlyTW %>%
#   p_map() %>%
#   mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))
# 
# # Mean MMR per subset
# pMAP_subsetMMR_acq_earlyTW <- model_acq_earlyTW %>%
#   emmeans(~ Group * TestSpeaker) %>%
#   p_map() %>%
#   mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# Simple Effect Group
pMAP_Group_simple_acq_earlyTW <- model_acq_earlyTW %>%
  emmeans(~ Group | TestSpeaker) %>%
  pairs() %>%
  p_map() %>%
  mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# # Effect Speaker
# pMAP_Speaker_acq_earlyTW <- model_acq_earlyTW %>%
#   emmeans(~ TestSpeaker) %>%
#   pairs() %>%
#   p_map() %>%
#   mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# Bayes Factors -------------------------------------------------------------------
model_acq_earlyTW_prior <- unupdate(model_acq_earlyTW) # sample priors from model

# # Effect all
# BF_all_acq_earlyTW <- model_acq_earlyTW %>%
#   bf_parameters(prior = model_acq_earlyTW_prior) %>%
#   arrange(log_BF) %>%
#   add_column("interpretation" = interpret_bf(
#     .$log_BF,
#     rules = "raftery1995",
#     log = TRUE,
#     include_value = TRUE,
#     protect_ratio = TRUE,
#     exact = TRUE
#   ), .after = "log_BF")
# 
# # Mean MMR per subset
# subsetMMR_prior_acq_earlyTW <- model_acq_earlyTW_prior %>%
#   emmeans(~ Group * TestSpeaker)
# 
# subsetMMR_acq_earlyTW <- model_acq_earlyTW %>%
#   emmeans(~ Group * TestSpeaker)
# 
# BF_subsetMMR_acq_earlyTW <- subsetMMR_acq_earlyTW %>%
#   bf_parameters(prior = subsetMMR_prior_acq_earlyTW) %>%
#   arrange(log_BF) %>%
#   add_column("interpretation" = interpret_bf(
#     .$log_BF,
#     rules = "raftery1995",
#     log = TRUE,
#     include_value = TRUE,
#     protect_ratio = TRUE,
#     exact = TRUE
#   ), .after = "log_BF")

# Simple Effect Group
Group_simple_pairwise_prior_acq_earlyTW <- model_acq_earlyTW_prior %>%
  emmeans(~ Group | TestSpeaker) %>%
  pairs()

Group_simple_pairwise_acq_earlyTW <- model_acq_earlyTW %>%
  emmeans(~ Group | TestSpeaker) %>%
  pairs()

BF_Group_simple_acq_earlyTW <- Group_simple_pairwise_acq_earlyTW %>%
  bf_parameters(prior = Group_simple_pairwise_prior_acq_earlyTW) %>%
  arrange(log_BF) %>%
  add_column("interpretation" = interpret_bf(
    .$log_BF,
    rules = "raftery1995",
    log = TRUE,
    include_value = TRUE,
    protect_ratio = TRUE,
    exact = TRUE
  ), .after = "log_BF")

# # Effect Speaker
# Speaker_pairwise_prior_acq_earlyTW <- model_acq_earlyTW_prior %>%
#   emmeans(~ TestSpeaker) %>%
#   pairs()
# 
# Speaker_pairwise_acq_earlyTW <- model_acq_earlyTW %>%
#   emmeans(~ TestSpeaker) %>%
#   pairs()
# 
# BF_Speaker_acq_earlyTW <- Speaker_pairwise_acq_earlyTW %>%
#   bf_parameters(prior = Speaker_pairwise_prior_acq_earlyTW) %>%
#   arrange(log_BF) %>%
#   add_column("interpretation" = interpret_bf(
#     .$log_BF,
#     rules = "raftery1995",
#     log = TRUE,
#     include_value = TRUE,
#     protect_ratio = TRUE,
#     exact = TRUE
#   ), .after = "log_BF")

# Merge and save results ---------------------------------------------------------
pMAP_BF_Group_earlyTW <- full_join(pMAP_Group_simple_acq_earlyTW, BF_Group_simple_acq_earlyTW, by = "Parameter") %>%
  as_tibble()

# Save the results
saveRDS(pMAP_BF_Group_earlyTW, file = here("data", "hypothesis_testing", "pMAP_BF_acq_earlyTW.rds"))

# # Merge and save results ---------------------------------------------------------
# pMAP_all_acq_earlyTW <- subset(pMAP_all_acq_earlyTW, select = -c(Effects, Component))
# BF_all_acq_earlyTW <- subset(BF_all_acq_earlyTW, select = -c(Effects, Component))
# 
# pMAP_BF_all_earlyTW <- full_join(pMAP_all_acq_earlyTW, BF_all_acq_earlyTW, by = "Parameter") %>%
#   as_tibble()
# 
# pMAP_BF_subsetMMR_earlyTW <- full_join(pMAP_subsetMMR_acq_earlyTW, BF_subsetMMR_acq_earlyTW, by = "Parameter") %>%
#   as_tibble()
# 
# pMAP_BF_Group_earlyTW <- full_join(pMAP_Group_simple_acq_earlyTW, BF_Group_simple_acq_earlyTW, by = "Parameter") %>%
#   as_tibble()
# 
# pMAP_BF_Speaker_earlyTW <- full_join(pMAP_Speaker_acq_earlyTW, BF_Speaker_acq_earlyTW, by = "Parameter") %>%
#   as_tibble()
# 
# pMAP_BF_all_earlyTW <- rbind(pMAP_BF_all_earlyTW, pMAP_BF_subsetMMR_earlyTW, pMAP_BF_Group_earlyTW, pMAP_BF_Speaker_earlyTW)
# 
# # Save the results
# saveRDS(pMAP_BF_all_earlyTW, file = here("data", "hypothesis_testing", "pMAP_BF_acq_earlyTW.rds"))

# Save as text file
output_filename <- here("data", "hypothesis_testing", "pMAP_BF_acq_earlyTW.rds")
output_filename <- substr(output_filename, 1, nchar(output_filename) - 4) # Remove the last 4 characters

# Round all numeric columns to 3 decimal places
for(col in names(pMAP_BF_Group_earlyTW)){
  if(is.numeric(pMAP_BF_Group_earlyTW[[col]])){
    pMAP_BF_Group_earlyTW[[col]] <- round(pMAP_BF_Group_earlyTW[[col]], 3)
  }
}
write.table(pMAP_BF_Group_earlyTW, file = paste(output_filename, ".txt", sep=""), sep = ",", quote = FALSE, row.names = FALSE)


# 4. SENSITIVITY ANALYSIS BFS ------------------

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


# Run the model with different sds ------------------
prior_sd <- c(1, 5, 8, 10, 15, 20, 30, 40, 50)

# Run the models
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- brm(MMR ~ 1 + TestSpeaker * Group + 
               mumDist + 
               nrSpeakersDaily +
               sleepState +
               age +
               (1 + TestSpeaker | Subj),
             data = data_acq_earlyTW,
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
             file=here("data", "sensitivity_analysis", paste0("E5_earlyTW_sensAnal_BF_priorsd_", psd, ".rds"))             
  )
}

## Simple effect Group for speaker 4 -------------------------
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  fit <- readRDS(here("data", "sensitivity_analysis", paste0("E5_earlyTW_sensAnal_BF_priorsd_", psd, ".rds")))
  fit_priors <- unupdate(fit)
  
  m_prior <- fit_priors %>%
    emmeans(~ Group | TestSpeaker) %>%
    pairs()
  
  m_post <- fit %>%
    emmeans(~ Group | TestSpeaker) %>%
    pairs()
  
  BF_current <- bf_parameters(m_post, prior = m_prior) %>%
    filter(Parameter == "fam - unfam, S4")
  BF_current <- as.numeric(BF_current)
  
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF = log10(BF))
save(res, file = here("data", "sensitivity_analysis", "E5_earlyTW_sensAnal_BF_simpleGroup-S4.rda"))

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
  # ggtitle("Bayes factors for simple effect of Group for Novel Speaker") +
  theme_apa()


# Save
plot(p)
png(file=here("data", "sensitivity_analysis", "E5_earlyTW_sensAnal_BF_simpleGroup-S4.png"),
    width=4500, height=3000,res=600)
plot(p)
dev.off()







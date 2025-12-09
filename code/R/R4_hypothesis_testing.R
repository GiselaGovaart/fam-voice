# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# Load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(easystats)
library(emmeans) 
library(logspline)

# Setup --------------------------------------------------------------------
# Custom contrasts
fam1 =   c(1,0,0,0,0,0)
unfam1 = c(0,1,0,0,0,0)
fam3 =   c(0,0,1,0,0,0)
unfam3 = c(0,0,0,1,0,0)
fam4 =   c(0,0,0,0,1,0)
unfam4 = c(0,0,0,0,0,1)

custom_contrasts <- list(
  list("unfam4-fam1" = unfam4 - fam1),
  list("unfam4-unfam3" = unfam4 - unfam3),
  list("unfam4-unfam1" = unfam4 - unfam1),
  list("unfam1-unfam3" = unfam1 - unfam3)
  #,list("(unfam1-unfam3)-(fam1-fam3)" = (unfam1 - unfam3) - (fam1 - fam3))
)

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


# Function to perform analysis ----------------------------------------------------
model_rec <- readRDS(here("data", "model_output", "R2_model_rec.rds"))


## MAP-Based p-Value (pMAP) 
# We use p-values here, but just to check the robustness, to check with other experiments with frequentist methods.
# https://easystats.github.io/bayestestR/reference/p_map.html
# Bayesian equivalent of the p-value, related to the odds that a parameter (described by its posterior distribution) has against the null hypothesis (h0) using Mills' (2014, 2017) Objective Bayesian Hypothesis Testing framework. It corresponds to the density value at 0 divided by the density at the Maximum A Posteriori (MAP).
# https://doi.org/10.3389/fpsyg.2019.02767
# The MAP-based p-value is related to the odds that a parameter has against the null hypothesis (Mills and Parent, 2014; Mills, 2017). It is mathematically defined as the density value at 0 divided by the density at the Maximum A Posteriori (MAP), i.e., the equivalent of the mode for continuous distributions.

# Effect all
pMAP_all_rec <- model_rec %>%
  p_map() %>%
  mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

# Custom contrasts
pMAP_customcontrasts_rec <- 
  model_rec %>%
  emmeans(~ Group:TestSpeaker) %>%
  contrast(method = custom_contrasts) %>%
  p_map() %>%
  mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

## Bayes Factors
# https://doi.org/10.3389/fpsyg.2019.02767
# The Bayes factor indicates the degree by which the mass of the posterior distribution has shifted further away from or closer 
# to the null value (0) relative to the prior distribution, thus indicating if the null hypothesis has become less or more likely given 
# the observed data. The BF is computed as a Savage-Dickey density ratio, which is also an approximation of a Bayes factor comparing the 
# marginal likelihoods of the model against a model in which the tested parameter has been restricted to the point-null (Wagenmakers et al., 2010).


model_rec_prior <- unupdate(model_rec) 

# Effect all
BF_all_rec <- model_rec %>%
  bf_parameters(prior = model_rec_prior) %>%
  arrange(log_BF) %>%
  add_column("interpretation" = interpret_bf(
    .$log_BF,
    rules = "raftery1995",
    log = TRUE,
    include_value = TRUE,
    protect_ratio = TRUE,
    exact = TRUE
  ), .after = "log_BF")

# Custom contrasts
customcontrasts_pairwise_prior_rec <- 
  model_rec_prior %>%
  emmeans(~ Group:TestSpeaker) %>%
  contrast(method = custom_contrasts) 

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
  arrange(log_BF) %>%
  add_column(
    "interpretation" = interpret_bf(
      .$log_BF,
      rules = "raftery1995",
      log = TRUE,
      include_value = TRUE,
      protect_ratio = TRUE,
      exact = TRUE
    ),
    .after = "log_BF"
  )

# Merge and save results
pMAP_all_rec <- subset(pMAP_all_rec, select = -c(Effects, Component))
BF_all_rec <- subset(BF_all_rec, select = -c(Effects, Component))

pMAP_BF_all <- full_join(pMAP_all_rec, BF_all_rec, by = "Parameter") %>%
  as_tibble()

pMAP_BF_contrast <- full_join(pMAP_customcontrasts_rec, BF_customcontrasts_rec, by = "Parameter") %>%
  as_tibble()

pMAP_BF_all <- rbind(pMAP_BF_all, pMAP_BF_contrast)

# Save the results
saveRDS(pMAP_BF_all, file = here("data", "hypothesis_testing", "pMAP_BF_rec.rds"))


# Save as text file
output_filename <- here("data", "hypothesis_testing", "pMAP_BF_rec.rds")
output_filename <- substr(output_filename, 1, nchar(output_filename) - 4) # Remove the last 4 characters

# Round all numeric columns to 3 decimal places
for(col in names(pMAP_BF_all)){
  if(is.numeric(pMAP_BF_all[[col]])){
    pMAP_BF_all[[col]] <- round(pMAP_BF_all[[col]], 3)
  }
}
write.table(pMAP_BF_all, file = paste(output_filename, ".txt", sep=""), sep = ",", quote = FALSE, row.names = FALSE)


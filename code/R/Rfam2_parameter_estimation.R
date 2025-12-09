# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# Load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(easystats)

# Setup: STAN --------------------------------------------------------------------
num_chains <- 4 # number of chains = number of processor cores
num_iter <- 80000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain

# Set priors ------------------------------------------------------------
priors <- c(set_prior("normal(3.5, 20)", class = "Intercept"),
            set_prior("normal(0, 10)", class = "b"),
            set_prior("normal(0, 20)", class = "sigma")) 

# Function to fit the model ----------------------------------------------------
fit_model <- function(data, output_file) {
  brm(MMR ~ 1 + TestSpeaker +
        mumDist +
        nrSpeakersDaily +
        sleepState +
        age +
        (1 + TestSpeaker | Subj),
      data = data,
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
      file = output_file,
      file_refit = "on_change",
      save_pars = save_pars(all = TRUE)
  )
}


datasets <- list(
  list(data = data_recfam_normal, output_file = here("data", "model_output", "Rfam2_model_recfam_normal.rds")),
  list(data = data_recfam_frontal, output_file = here("data", "model_output", "Rfam2_model_recfam_frontal.rds"))
)

# Loop through datasets and run models
for (dataset in datasets) {
  fit_model(dataset$data, dataset$output_file)
}



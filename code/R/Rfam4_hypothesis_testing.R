# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(easystats)
library(emmeans) 
library(logspline)

# FOR REC FAM -------------------
# Setup --------------------------------------------------------------------
# Custom contrasts
fam1 =   c(1,0,0)
fam3 =   c(0,1,0)
fam4 =   c(0,0,1)

custom_contrasts <- list(
  list("fam1-fam4" = fam1 - fam4),
  list("fam3-fam4" = fam3 - fam4),
  list("fam1-fam3" = fam1 - fam3)
)

# Function to perform analysis ----------------------------------------------------
run_analysis <- function(model_file, output_file) {
  model_rec <- readRDS(model_file)

  # MAP-Based p-Value (pMAP) for custom contrasts
  pMAP_customcontrasts_rec <-
    model_rec %>%
    emmeans(~ TestSpeaker) %>%
    contrast(method = custom_contrasts) %>%
    p_map() %>%
    mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))
  
  # MAP-Based p-Value (pMAP) for Effect all
  pMAP_all_rec <- model_rec %>%
    p_map() %>%
    mutate("p < .05" = ifelse(p_MAP < .05, "*", ""))

  # Bayes Factors custom contrast
  model_rec_prior <- unupdate(model_rec)

  customcontrasts_pairwise_prior_rec <-
    model_rec_prior %>%
    emmeans(~ TestSpeaker) %>%
    contrast(method = custom_contrasts)

  customcontrasts_pairwise_rec <-
    model_rec %>%
    emmeans(~ TestSpeaker) %>%
    contrast(method = custom_contrasts)

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
  
  # Bayes Factors All
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
  
  
  # Merge and save results
  pMAP_all_rec <- subset(pMAP_all_rec, select = -c(Effects, Component))
  BF_all_rec <- subset(BF_all_rec, select = -c(Effects, Component))
  
  pMAP_BF_all <- full_join(pMAP_all_rec, BF_all_rec, by = "Parameter") %>%
    as_tibble()
  
  pMAP_BF_contrast <- full_join(pMAP_customcontrasts_rec, BF_customcontrasts_rec, by = "Parameter") %>%
    as_tibble()
  
  pMAP_BF_all <- rbind(pMAP_BF_all, pMAP_BF_contrast)
  
  # Save the results as .rds
  saveRDS(pMAP_BF_all, file = output_file)
}

# Run analyses for different models ------------------------------------------------
models <- list(
  list(file = here("data", "model_output", "Rfam2_model_recfam_normal.rds"),
       output = here("data", "hypothesis_testing", "pMAP_BF_recfam_normal.rds")),
  list(file = here("data", "model_output", "Rfam2_model_recfam_frontal.rds"),
       output = here("data", "hypothesis_testing", "pMAP_BF_recfam_frontal.rds"))
)

# Execute the analysis for each model
for (model in models) {
  run_analysis(model$file, model$output)
}

# Load all outputs ---------------------------------------------------------------
outputs <- lapply(models, function(model) {
  readRDS(model$output)
})

# Display outputs
for (i in seq_along(outputs)) {
  cat("Output from file:", models[[i]]$output, "\n")
  print(outputs[[i]])
}


# Save as text file -------------------------
# normal
output_filename <- here("data", "hypothesis_testing", "pMAP_BF_recfam_normal.rds")
output_filename <- substr(output_filename, 1, nchar(output_filename) - 4) # Remove the last 4 characters
pMAP_BF_all = readRDS(here("data", "hypothesis_testing", "pMAP_BF_recfam_normal.rds"))
# Round all numeric columns to 3 decimal places
for(col in names(pMAP_BF_all)){
  if(is.numeric(pMAP_BF_all[[col]])){
    pMAP_BF_all[[col]] <- round(pMAP_BF_all[[col]], 3)
  }
}
write.table(pMAP_BF_all, file = paste(output_filename, ".txt", sep=""), sep = ",", quote = FALSE, row.names = FALSE)

# frontal
output_filename <- here("data", "hypothesis_testing", "pMAP_BF_recfam_frontal.rds")
output_filename <- substr(output_filename, 1, nchar(output_filename) - 4) # Remove the last 4 characters
pMAP_BF_all = readRDS(here("data", "hypothesis_testing", "pMAP_BF_recfam_frontal.rds"))

# Round all numeric columns to 3 decimal places
for(col in names(pMAP_BF_all)){
  if(is.numeric(pMAP_BF_all[[col]])){
    pMAP_BF_all[[col]] <- round(pMAP_BF_all[[col]], 3)
  }
}
write.table(pMAP_BF_all, file = paste(output_filename, ".txt", sep=""), sep = ",", quote = FALSE, row.names = FALSE)




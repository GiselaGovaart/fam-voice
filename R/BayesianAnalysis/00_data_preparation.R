
# RNG --------------------------------------------------------

project_seed <- 2049
set.seed(project_seed) # set seed

# install packages --------------------------------------------------------------------

# install.packages("here")
# install.packages("tidyverse")

# load packages --------------------------------------------------------------------

library(here)
library(tidyverse)

# data cleaning --------------------------------------------------------------------

# load data
# the data loaded here is the raw data from Katharina. This contains FRN and P3, the rest
# of the analyses are only for P3.
dat <-
  read_csv(
    here("data", "raw", "test_FRN_P3_Pilots.csv"),
    col_names = TRUE,
    col_types = c("ffffffffddddddddddd") # all columns are factors except amplitude
  ) %>%
  as_tibble() %>%
  mutate( # recode factor levels for better readability
    Expectancy = recode(
      Expectancy,
      "Exp" = "expected",
      "Unx" = "unexpected",
      "NoExp" = "notexpected"
    ),
    Valence = recode(
      Valence,
      "NoReward" = "negative",
      "Reward" = "positive",
      "Diff" = "negative_minus_positive"
    )
  ) %>%
  rename(
    Laboratory = Lab, 
    Subject = ID,
    Location = Electrode,
    Amplitude = ERP
    )%>%
  arrange(Laboratory, Subject) # sort by lab and participant

# save as .RData (compressed)
save(
  dat,
  file = here("data", "raw", "test_FRN_P3.RData")
)

# FRN, mean amplitude --------------------------------------------------------------------

FRN_mean <-
  dat %>%
  filter(
    Component == "FRN" &
      Valence == "negative_minus_positive" &
      Quantification == "Mean"
  ) %>%
  droplevels()

# save as .RData (compressed)
save(
  FRN_mean,
  file = here("data", "preprocessed", "FRN_mean.RData")
)

# P3, mean amplitude --------------------------------------------------------------------
# The rest of the code is always only for P3
P3_mean <-
  dat %>%
  filter(
    Component == "P3" &
      Valence %in% c("negative", "positive") &
      Location == "PZ" &
      Quantification == "Mean"
  ) %>%
  droplevels()

# save as .RData (compressed)
# this is the data we will work with, with Amplitude per pp per condition per trial
save(
  P3_mean,
  file = here("data", "preprocessed", "P3_mean.RData")
)


# END --------------------------------------------------------------------

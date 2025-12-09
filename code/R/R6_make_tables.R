
# load packages --------------------------------------------------------------------
library(tidyverse)
library(dplyr)
library(tidyr)
library(plotrix)

data_rec = data_rec_noncentered

# Descriptive Table Demographics
descr_demographics <- data_rec %>%
  distinct(Subj, .keep_all = TRUE) %>%  # Keep only one observation per subject
  group_by(Group) %>%
  summarise(
    n = n(),
    age_mean = mean(age, na.rm = TRUE),
    age_sd = sd(age, na.rm = TRUE),
    num_females = sum(sex == 'f', na.rm = TRUE),
    .groups = 'drop'
  )%>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))  # Round all numeric values to 2 

descr_demographics_t <- descr_demographics %>%
  as.data.frame() %>%
  t()

print(descr_demographics_t)
write.table(descr_demographics_t, file = here("data","tables","descriptive_demographics_rec.txt"), sep = ",", quote = FALSE, row.names = TRUE, col.names = FALSE)


# Descriptive Table methods
descr_methods_group <- data_rec %>%
  distinct(Subj, .keep_all = TRUE) %>%  # Keep only one observation per subject
  group_by(Group) %>%
  summarise(
    nrSpeakersDaily_mean = mean(nrSpeakersDaily, na.rm = TRUE),
    nrSpeakersDaily_sd = sd(nrSpeakersDaily, na.rm = TRUE),
    daysVoicetraining_mean = mean(daysVoicetraining, na.rm = TRUE),
    daysVoicetraining_sd = sd(daysVoicetraining, na.rm = TRUE),
    .groups = 'drop'
  )%>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))  # Round all numeric values to 2 
descr_methods_group_t <- descr_methods_group %>%
  as.data.frame() %>%
  t()
print(descr_methods_group_t)
write.table(descr_methods_group_t, file = here("data","tables","descriptive_methodsgroup_rec.txt"), sep = ",", quote = FALSE, row.names = TRUE, col.names = FALSE)

descr_methods_groupTS <- data_rec %>%
  group_by(TestSpeaker, Group) %>%
  filter(TestSpeaker %in% c("S1", "S3", "S4")) %>%
  summarise(
    mumDist_mean = mean(mumDist, na.rm = TRUE),
    mumDist_sd = sd(mumDist, na.rm = TRUE),
    num_asleep = sum(sleepState == "asleep", na.rm = TRUE),  # Count infants asleep per group
    .groups = 'drop'
  ) %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))  # Round all numeric values to 2 
descr_methods_groupTS_t <- descr_methods_groupTS %>%
  as.data.frame() %>%
  t()
print(descr_methods_groupTS_t)
write.table(descr_methods_groupTS_t, file = here("data","tables","descriptive_methodsgroupTS_rec.txt"), sep = ",", quote = FALSE, row.names = TRUE, col.names = FALSE)

descr_methods_trials<- data_rec %>%
  group_by(TestSpeaker, Group) %>%
  filter(TestSpeaker %in% c("S1", "S3", "S4")) %>%
  summarise(
    TrialsDev_mean = mean(TrialsDev, na.rm = TRUE),
    TrialsDev_sd = sd(TrialsDev, na.rm = TRUE),
    TrialsStan_mean = mean(TrialsStan, na.rm = TRUE),
    TrialsStan_sd = sd(TrialsStan, na.rm = TRUE),
    .groups = 'drop'
  )  %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))  # Round all numeric values to 2 
descr_methods_trials_t <- descr_methods_trials %>%
  as.data.frame() %>%
  t()
print(descr_methods_trials_t)
write.table(descr_methods_trials_t, file = here("data","tables","descriptive_methodsTrials_rec.txt"), sep = ",", quote = FALSE, row.names = TRUE, col.names = FALSE)


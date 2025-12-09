
# load packages --------------------------------------------------------------------
library(tidyverse)
library(dplyr)
library(tidyr)
library(plotrix)

# Calculate the sign of MMR by sex
data <- data_acq %>%
  mutate(sign = case_when(
    MMR > 0 ~ "Positive",
    MMR < 0 ~ "Negative",
    TRUE ~ "Zero"
  ))
result <- data %>%
  group_by(sex, sign) %>%
  summarise(count = n(), .groups = 'drop') %>%
  pivot_wider(names_from = sign, values_from = count, values_fill = 0)
print(result)

# mean and sd
mean(data_acq$MMR, na.rm = TRUE)
sd(data_acq$MMR, na.rm = TRUE)
print(std.error(data_acq$MMR))

# effect of Group
testdatfam = subset(data_acq, Group == "fam")
testdatunfam = subset(data_acq, Group == "unfam")
mean(testdatfam$MMR, na.rm = TRUE) - mean(testdatunfam$MMR, na.rm = TRUE)

# effect of TestSpeaker
testdat1 = subset(data_acq, TestSpeaker == "S1") 
testdat4 = subset(data_acq, TestSpeaker == "S4") 
mean(testdat1$MMR, na.rm = TRUE) - mean(testdat4$MMR, na.rm = TRUE)

# Plotting
plot(density(data_acq$MMR, na.rm = TRUE),
     main="Data ",xlab="MMR")

ggplot(aes(y = MMR, x = age, color = TestSpeaker), data = data_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(y = MMR, x = age), data = data_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(y = MMR, x = sleepState, color = Group), data = data_acq) +
  geom_boxplot() 

ggplot(aes(y = MMR, x = nrSpeakersDaily), data = data_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(y = MMR, x = age, color = Group), data = data_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(y = MMR, x = mumDist, color = TestSpeaker), data = data_acq) +
  geom_point() + 
  stat_smooth(method = "lm", 
              formula = y ~ x, 
              geom = "smooth") 

ggplot(aes(y = MMR, x = Group, color = TestSpeaker), data = data_acq) +
  geom_boxplot()

ggplot(aes(y = MMR, x = Group, color = TestSpeaker), data = data_acq) +
  geom_violin()

ggplot(aes(y = MMR, x = Group), data = data_acq) +
  geom_boxplot() 

ggplot(aes(y = MMR, x = Group), data = data_acq) +
  geom_violin() 


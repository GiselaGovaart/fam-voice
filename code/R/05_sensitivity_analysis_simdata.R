# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(ggplot2)
library(brms)
library(ggmcmc)
library(RColorBrewer)

# set colors --------------------------------------------------------------------
col1 = "#F8766D"
col2 = "#FCAE00"
col3 = "#00BFC4"
col4 = "#C77CFF"

# formula ----------
formula = MMR ~ 1 + TestSpeaker * Group + 
  mumDist +
  nrSpeakersDaily  + 
  sleepState + 
  age +
  (1 + TestSpeaker | Subj)

# Set up sampling ------------------------------------------------------------
num_chains <- 4 
num_iter <- 20000 
num_warmup <- num_iter / 2 
num_thin <- 1 

# ACQUISITION
# priors for sensitivity analysis:
priors_orig <- 
  c(set_prior("normal(3.5, 20)",  
              class = "Intercept"),
    set_prior("normal(0, 20)",  
              class = "b"),
    set_prior("normal(0, 20)",  
              class = "sigma"))

priors1 <- 
  c(set_prior("normal(0, 20)",  # changing the mean of the intercept to 0
              class = "Intercept"),
    set_prior("normal(0, 20)",  
              class = "b"),
    set_prior("normal(0, 20)",  
              class = "sigma"))
priors2 <-
  c(set_prior("normal(0, 30)",  
              class = "Intercept"),
    set_prior("normal(0, 30)",  
              class = "b"), # weakly informative prior on intercept & slopes: this is still biologically plausible
    set_prior("normal(0, 30)", 
              class = "sigma")) 

priors3 <-
  c(set_prior("normal(0, 50)",  
              class = "Intercept"),
    set_prior("normal(0, 50)",  
              class = "b"), # uninformative prior on intercept & slopes: this is not biologically plausible
    set_prior("normal(0, 50)", 
              class = "sigma")) 

# Plot the priors (code adapted from https://osf.io/eyd4r/)
legend_colors <- c("Orig: normal(3.5, 20)" = col1, "Alt 1: normal(0, 20)" = col2, "Alt 2: normal(0, 30)" = col3, "Alt 3: normal(0, 50)" = col4)
# Save the x-axis limits in a dataframe
df <- data.frame(x = c(-50, 50))
p <- ggplot(df, aes(x=x)) +
  # First, add the prior distribution of the original prior. 
  # The first line creates an area (filled in with color), the second line creates a line graph
  stat_function(fun = dnorm, n = 1001, args = list(mean = 3.5, sd = sqrt(20)), geom = "area", aes(fill = "Orig: normal(3.5, 20)"), alpha = .5) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 3.5, sd = sqrt(20))) +
  # Repeat the above for each of the two alternative priors
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(20)), geom = "area", aes(fill = "Alt 1: normal(0, 20)"), alpha = .5) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(20))) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(30)), geom = "area", aes(fill = "Alt 2: normal(0, 30)"), alpha = .5) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(30))) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(50)), geom = "area", aes(fill = "Alt 3: normal(0, 50)"), alpha = .5) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(50))) +
  scale_fill_manual(name='Priors', values = legend_colors,
                    breaks = c("Orig: normal(3.5, 20)", "Alt 1: normal(0, 20)",
                               "Alt 2: normal(0, 30)", "Alt 3: normal(0, 50)")) +
  ggtitle("Comparison of Priors") +
  xlab(bquote(beta[Intercept])) +
  theme_light() +    
  theme(legend.position = c(0.8, 0.8),
        axis.title.x=element_text(family = "sans", size = 18),
        axis.title.y=element_blank(),
        plot.title = element_text(hjust = 0.5, family="sans", size = 18))
# Print the plot
p

# model orig prior 
m_sens_orig <- readRDS(here("data", "model_output", "04_model_posteriorpredcheck_acq.rds"))

plot(m_sens_orig) # looks good

# model alternative priors 1 
m_sens_1 <- brm(MMR ~ 1 + TestSpeaker * Group + 
                  mumDist +
                  nrSpeakersDaily +
                  sleepState +
                  age +
                  (1 + TestSpeaker | Subj),
                data = dat_acq,
                prior = priors1,
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
                file = here("data", "model_output", "05_model_sensitivity_altern1_acq.rds"),
                file_refit = "on_change",
                save_pars = save_pars(all = TRUE)
)
# 294 divergent transitions.
plot(m_sens_1) # looks okay, Rhat is 1.01 in some cases, but the estimates are still good

# model alternative priors 2
m_sens_2 <- brm(MMR ~ 1 + TestSpeaker * Group + 
                 mumDist +
                 nrSpeakersDaily +
                 sleepState +
                 age +
                 (1 + TestSpeaker | Subj),
               data = dat_acq,
               prior = priors2,
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
               file = here("data", "model_output", "05_model_sensitivity_altern2_acq.rds"),
               file_refit = "on_change",
               save_pars = save_pars(all = TRUE)
)
# 29 divergent transitions.
plot(m_sens_2) # looks good

# model alternative priors 3 
m_sens_3 <- brm(MMR ~ 1 + TestSpeaker * Group + 
                  mumDist +
                  nrSpeakersDaily +
                  sleepState +
                  age +
                  (1 + TestSpeaker | Subj),
                data = dat_acq,
                prior = priors3,
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
                file = here("data", "model_output", "05_model_sensitivity_altern3_acq.rds"),
                file_refit = "on_change",
                save_pars = save_pars(all = TRUE)
)
# 6 divergent transitions
plot(m_sens_3) # looks good

summary(m_sens_orig) # Rhat and ESS'es look good, Rhat of max 1.01. 15 divergent transitions
summary(m_sens_1) # Rhat and ESS'es look , Rhat of max 1.00. 88 divergent transitions
summary(m_sens_2) # Rhat and ESS'es look good, Rhat of max 1.01. 643 divergent transitions
summary(m_sens_3) # Rhat and ESS'es look good, Rhat of max 1.01. 222 divergent transitions

posterior_summary(m_sens_orig, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_sens_1, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_sens_2, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_sens_3, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))

# Visualize posterior distributions
m_sens_orig_tranformed <- ggs(m_sens_orig) # the ggs function transforms the brms output into a longformat tibble, that we can use to make different types of plots.
m_sens_1_tranformed <- ggs(m_sens_1)
m_sens_2_tranformed <- ggs(m_sens_2)
m_sens_3_tranformed <- ggs(m_sens_3)

# plot posterior density for Intercept
ggplot() + 
  geom_density(data = filter(m_sens_orig_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Orig: normal(3.5, 20)"), alpha = 1) +
  geom_density(data = filter(m_sens_1_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 1: normal(0, 20)"), alpha = .5) +
  geom_density(data = filter(m_sens_2_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 2: normal(0, 30)"), alpha = .5) +
  geom_density(data = filter(m_sens_3_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 3: normal(0, 50)"),  alpha = .5) +
  scale_x_continuous(name   = "Value",
                     limits = c(-3, 13)) + 
  scale_fill_manual(name='Priors', values = legend_colors, 
                    breaks = c("Orig: normal(3.5, 20)", "Alt 1: normal(0, 20)",
                               "Alt 2: normal(0, 30)", "Alt 3: normal(0, 50)")) +
  # set v-lines for the CIs
  geom_vline(xintercept = summary(m_sens_orig)$fixed[1,3],
             col = col1,
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_orig)$fixed[1,4],
             col = col1,
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_1)$fixed[1,3],
             col = col2,
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_1)$fixed[1,4],
             col = col2,
             linetype = 2) +  
  geom_vline(xintercept = summary(m_sens_2)$fixed[1,3],
             col = col3,
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_2)$fixed[1,4],
             col = col3,
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[1,3],
             col = col4,
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[1,4],
             col = col4,
             linetype = 2) +
  theme_light() +
  theme(legend.position = c(0.8, 0.8)) +
  labs(title = "Posterior Density of the Intercept for different priors")


# plot posterior density for effect TestSpeaker
ggplot() + 
  geom_density(data = filter(m_sens_orig_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Orig: normal(3.5, 20)"), alpha = .5) +
  geom_density(data = filter(m_sens_1_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 1: normal(0, 20)"), alpha = .5) +
  geom_density(data = filter(m_sens_2_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 2: normal(0, 30)"), alpha = .5) +
  geom_density(data = filter(m_sens_3_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 3: normal(0, 50)"),  alpha = .5) +
  scale_x_continuous(name   = "Value",
                     limits = c(-13, 8)) + 
  scale_fill_manual(name='Priors', values = legend_colors,
                    breaks = c("Orig: normal(3.5, 20)", "Alt 1: normal(0, 20)", 
                               "Alt 2: normal(0, 30)", "Alt 3: normal(0, 50)")) +
  #set v-lines for the CIs
  geom_vline(xintercept = summary(m_sens_orig)$fixed[2,3],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_orig)$fixed[2,4],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_1)$fixed[2,3],
             col = "#F8766D",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_1)$fixed[2,4],
             col = "#F8766D",
             linetype = 2) +  
  geom_vline(xintercept = summary(m_sens_2)$fixed[2,3],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_2)$fixed[2,4],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[2,3],
             col = "#619CFF",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[2,4],
             col = "#619CFF",
             linetype = 2) +
  theme_light() +
  theme(legend.position = c(0.8, 0.8)) +
  labs(title = "Posterior Density of the Effect of TestSpeaker for different priors")

# plot posterior density for effect Group
ggplot() + 
  geom_density(data = filter(m_sens_orig_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Orig: normal(3.5, 20)"), alpha = .5) +
  geom_density(data = filter(m_sens_1_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 1: normal(0, 20)"), alpha = .5) +
  geom_density(data = filter(m_sens_2_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 2: normal(0, 30)"), alpha = .5) +
  geom_density(data = filter(m_sens_3_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Alt 3: normal(0, 50)"),  alpha = .5) +
  scale_x_continuous(name   = "Value",
                     limits = c(-13, 8)) + 
  scale_fill_manual(name='Priors', values = legend_colors,
                    breaks = c("Orig: normal(3.5, 20)", "Alt 1: normal(0, 20)", 
                               "Alt 2: normal(0, 30)", "Alt 3: normal(0, 50)")) +
  #set v-lines for the CIs
  geom_vline(xintercept = summary(m_sens_orig)$fixed[3,3],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_orig)$fixed[3,4],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_1)$fixed[3,3],
             col = "#F8766D",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_1)$fixed[3,4],
             col = "#F8766D",
             linetype = 2) +  
  geom_vline(xintercept = summary(m_sens_2)$fixed[3,3],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_2)$fixed[3,4],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[3,3],
             col = "#619CFF",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[3,4],
             col = "#619CFF",
             linetype = 2) +
  theme_light() +
  theme(legend.position = c(0.8, 0.8)) +
  labs(title = "Posterior Density of the Effect of Group for different priors")



## CONCLUSION
# The priors barely have any effect on the estimates of the model

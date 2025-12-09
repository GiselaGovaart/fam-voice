
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
num_iter <- 60000 
num_warmup <- num_iter / 2 
num_thin <- 1 

# Priors for sensitivity analysis ------------------------------------------
priors_orig <- 
  c(set_prior("normal(3.5, 20)",  
              class = "Intercept"),
    set_prior("normal(0, 10)",  
              class = "b"),
    set_prior("normal(0, 20)",  
              class = "sigma"))

priors1 <- 
  c(set_prior("normal(0, 20)",  # changing the mean of the intercept to 0
              class = "Intercept"),
    set_prior("normal(0, 10)",  
              class = "b"),
    set_prior("normal(0, 20)",  
              class = "sigma"))
priors2 <-
  c(set_prior("normal(0, 30)",  
              class = "Intercept"),
    set_prior("normal(0, 20)",  
              class = "b"), # weakly informative prior on intercept & slopes: this is still biologically plausible
    set_prior("normal(0, 30)", 
              class = "sigma")) 

priors3 <-
  c(set_prior("normal(0, 50)",  
              class = "Intercept"),
    set_prior("normal(0, 40)",  
              class = "b"), # uninformative prior on intercept & slopes: this is not biologically plausible
    set_prior("normal(0, 50)", 
              class = "sigma")) 

# Plot the priors  ------------------------------------------------------------
# (code adapted from https://osf.io/eyd4r/)
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
  scale_fill_manual(name='Priors on the intercept', values = legend_colors,
                    breaks = c("Orig: normal(3.5, 20)", "Alt 1: normal(0, 20)",
                               "Alt 2: normal(0, 30)", "Alt 3: normal(0, 50)")) +
  ggtitle("Comparison of priors on the intercept") +
  xlab(bquote(beta[Intercept])) +
  theme_light() +    
  theme(legend.position = c(0.8, 0.8),
        axis.title.x=element_text(family = "sans", size = 18),
        axis.title.y=element_blank(),
        plot.title = element_text(hjust = 0.5, family="sans", size = 18))
# Print the plot
plot(p)
png(file=here("data", "sensitivity_analysis", "R1_plotpriors.png"),
    width=4500, height=3000,res=600)
plot(p)
dev.off()


### Model orig prior  ------------------------------------------------------------
m_orig  <- brm(MMR ~ 1 + TestSpeaker * Group +
                 mumDist +
                 nrSpeakersDaily +
                 sleepState +
                 age +
                 (1 + TestSpeaker | Subj),
               data = data_rec,
               prior = priors_orig,
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
               file = here("data", "model_output", "R1_model_sensitivity_rec.rds"),
               file_refit = "on_change",
               save_pars = save_pars(all = TRUE)
)

m_orig <- readRDS(here("data", "model_output", "R1_model_sensitivity_rec.rds"))

plot(m_orig) # looks good

### Model alternative priors 1 ------------------------------------------------------------
m_alt_1 <- brm(MMR ~ 1 + TestSpeaker * Group +
                 mumDist +
                 nrSpeakersDaily +
                 sleepState +
                 age +
                 (1 + TestSpeaker | Subj),
               data = data_rec,
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
               file = here("data", "model_output", "R1_model_sensitivity_altern1_rec.rds"),
               file_refit = "on_change",
               save_pars = save_pars(all = TRUE)
)

m_alt_1 <- readRDS(here("data", "model_output", "R1_model_sensitivity_altern1_rec.rds"))

plot(m_alt_1) # looks good


  ### Model alternative priors 2 ------------------------------------------------------------
m_alt_2 <- brm(MMR ~ 1 + TestSpeaker * Group +
                 mumDist +
                 nrSpeakersDaily +
                 sleepState + age +
                 (1 + TestSpeaker | Subj),
               data = data_rec,
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
               file = here("data", "model_output", "R1_model_sensitivity_altern2_rec.rds"),
               file_refit = "on_change",
               save_pars = save_pars(all = TRUE)
)

m_alt_2 <- readRDS(here("data", "model_output", "R1_model_sensitivity_altern2_rec.rds"))

plot(m_alt_2) # looks good


### Model alternative priors 3 ------------------------------------------------------------
m_alt_3 <-brm(MMR ~ 1 + TestSpeaker * Group +
                mumDist +
                nrSpeakersDaily +
                sleepState +
                age +
                (1 + TestSpeaker | Subj),
              data = data_rec,
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
               file = here("data", "model_output", "R1_model_sensitivity_altern3_rec.rds"),
               file_refit = "on_change",
               save_pars = save_pars(all = TRUE)
)
m_alt_3 <- readRDS(here("data", "model_output", "R1_model_sensitivity_altern3_rec.rds"))

plot(m_alt_3) # looks good

summary(m_orig) # 47 divergent transitions after warmup. Rhat and ESS everywhere good.
summary(m_alt_1) # 1 divergent transitions after warmup. Rhat and ESS everywhere good.
summary(m_alt_2) # 62 divergent transitions after warmup. Rhat and ESS everywhere good.
summary(m_alt_3) # 4 divergent transitions after warmup. Rhat everywhere good, ESS a bit low for sigma and some sds.

posterior_summary(m_orig, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_alt_1, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_alt_2, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_alt_3, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))

### Visualize posterior distributions ------------------------------------------------------------

m_orig <- readRDS(here("data", "model_output", "R1_model_sensitivity_rec.rds"))
m_orig_tranformed <- ggs(m_orig) # the ggs function transforms the brms output into a longformat tibble, that we can use to make different types of plots.
m_alt_1 <- readRDS(here("data", "model_output", "R1_model_sensitivity_altern1_rec.rds"))
m_alt_1_tranformed <- ggs(m_alt_1)

m_alt_2 <- readRDS(here("data", "model_output", "R1_model_sensitivity_altern2_rec.rds")) # to free up disk space
m_alt_2_tranformed <- ggs(m_alt_2)
m_alt_3 <- readRDS(here("data", "model_output", "R1_model_sensitivity_altern3_rec.rds")) # to free up disk space
m_alt_3_tranformed <- ggs(m_alt_3)

legend_colors <- c("Original" = col1, "Alternative 1" = col2, "Alternative 2" = col3, "Alternative 3" = col4)

# plot posterior density for Intercept
p = ggplot() + 
  geom_density(data = filter(m_orig_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Original"), alpha = 1) +
  geom_density(data = filter(m_alt_1_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 1"), alpha = .5) +
  geom_density(data = filter(m_alt_2_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 2"), alpha = .5) +
  geom_density(data = filter(m_alt_3_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 3"),  alpha = .5) +
  scale_x_continuous(name   = "Value",
                     limits = c(-3, 13)) + 
  scale_fill_manual(name='Priors', values = legend_colors, 
                    breaks = c("Original", "Alternative 1", 
                               "Alternative 2", "Alternative 3")) +
  # set v-lines for the CIs
  geom_vline(xintercept = summary(m_orig)$fixed[1,3],
             col = col1,
             linetype = 2) +
  geom_vline(xintercept = summary(m_orig)$fixed[1,4],
             col = col1,
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_1)$fixed[1,3],
             col = col2,
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_1)$fixed[1,4],
             col = col2,
             linetype = 2) +  
  geom_vline(xintercept = summary(m_alt_2)$fixed[1,3],
             col = col3,
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_2)$fixed[1,4],
             col = col3,
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_3)$fixed[1,3],
             col = col4,
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_3)$fixed[1,4],
             col = col4,
             linetype = 2) +
  theme_light() +
  theme(legend.position = c(0.8, 0.8)) +
  labs(title = "Posterior Density of the Intercept for different priors")

plot(p)
png(file=here("data", "sensitivity_analysis", "R1_postDens_Intercept_differentPriors.png"),
    width=4500, height=3000,res=600)
plot(p)
dev.off()


# plot posterior density for effect TestSpeaker
p = ggplot() + 
  geom_density(data = filter(m_orig_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Original"), alpha = .5) +
  geom_density(data = filter(m_alt_1_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 1"), alpha = .5) +
  geom_density(data = filter(m_alt_2_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 2"), alpha = .5) +
  geom_density(data = filter(m_alt_3_tranformed,
                             Parameter == "b_TestSpeaker1", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 3"),  alpha = .5) +
  scale_x_continuous(name   = "Value",
                     limits = c(-13, 8)) + 
  scale_fill_manual(name='Priors', values = legend_colors,
                    breaks = c("Original", "Alternative 1", 
                               "Alternative 2", "Alternative 3")) +
  #set v-lines for the CIs
  geom_vline(xintercept = summary(m_orig)$fixed[2,3],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_orig)$fixed[2,4],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_1)$fixed[2,3],
             col = "#F8766D",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_1)$fixed[2,4],
             col = "#F8766D",
             linetype = 2) +  
  geom_vline(xintercept = summary(m_alt_2)$fixed[2,3],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_2)$fixed[2,4],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_3)$fixed[2,3],
             col = "#619CFF",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_3)$fixed[2,4],
             col = "#619CFF",
             linetype = 2) +
  theme_light() +
  theme(legend.position = c(0.8, 0.8)) +
  labs(title = "Posterior Density of the Effect of TestSpeaker for different priors")

plot(p)
png(file=here("data", "sensitivity_analysis", "R1_postDens_TestSpeaker_differentPriors.png"),
    width=4500, height=3000,res=600)
plot(p)
dev.off()

# plot posterior density for effect Group
p = ggplot() + 
  geom_density(data = filter(m_orig_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Original"), alpha = .5) +
  geom_density(data = filter(m_alt_1_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 1"), alpha = .5) +
  geom_density(data = filter(m_alt_2_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 2"), alpha = .5) +
  geom_density(data = filter(m_alt_3_tranformed,
                             Parameter == "b_Group1", 
                             Iteration > 10000), aes(x = value, fill  = "Alternative 3"),  alpha = .5) +
  scale_x_continuous(name   = "Value",
                     limits = c(-13, 8)) + 
  scale_fill_manual(name='Priors', values = legend_colors,
                    breaks = c("Original", "Alternative 1", 
                               "Alternative 2", "Alternative 3")) +
  #set v-lines for the CIs
  geom_vline(xintercept = summary(m_orig)$fixed[3,3],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_orig)$fixed[3,4],
             col = "yellow",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_1)$fixed[3,3],
             col = "#F8766D",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_1)$fixed[3,4],
             col = "#F8766D",
             linetype = 2) +  
  geom_vline(xintercept = summary(m_alt_2)$fixed[3,3],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_2)$fixed[3,4],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_3)$fixed[3,3],
             col = "#619CFF",
             linetype = 2) +
  geom_vline(xintercept = summary(m_alt_3)$fixed[3,4],
             col = "#619CFF",
             linetype = 2) +
  theme_light() +
  theme(legend.position = c(0.8, 0.8)) +
  labs(title = "Posterior Density of the Effect of Group for different priors")

plot(p)
png(file=here("data", "sensitivity_analysis", "R1_postDens_Group_differentPriors.png"),
    width=4500, height=3000,res=600)
plot(p)
dev.off()


## CONCLUSION ------------------------------------------------------------
# The priors barely have any effect on the estimates of the model


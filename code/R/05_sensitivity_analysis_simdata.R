# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(ggplot2)
library(brms)
library(ggmcmc)
library(RColorBrewer)

# formula ----------
formula = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  mumDistNovelS * TestSpeaker + 
  timeVoiceFam * TestSpeaker * Group +
  nrSpeakersDaily * TestSpeaker * Group + 
  sleepState * TestSpeaker * Group + 
  (1 | Subj) + (1 | TestSpeaker*Group)


# sensitivity analysis --------------------------------------------------------------------
# other priors:
priors_orig <-
  c(set_prior("normal(2.92, 14)",  
              class = "Intercept"),
    set_prior("normal(0, 14)",  
              class = "b"),
    set_prior("normal(0, 14)", 
              class = "sigma")) 

priors2 <-
  c(set_prior("normal(0, 28)",  
              class = "Intercept"),
    set_prior("normal(0, 28)",  
              class = "b"), # weakly informative prior on intercept & slopes: this is still biologically plausible
    set_prior("normal(0, 14)", 
              class = "sigma")) 
priors3 <-
  c(set_prior("normal(0, 50)",  
              class = "Intercept"),
    set_prior("normal(0, 50)",  
              class = "b"), # uninformative prior on intercept & slopes: this is not biologically plausible
    set_prior("normal(0, 14)", 
              class = "sigma")) 

# Plot the priors (code adapted from https://osf.io/eyd4r/)
# Save the x-axis limits in a dataframe
df <- data.frame(x = c(-50, 50))
p <- ggplot(df, aes(x=x)) +
  # First, add the prior distribution of the original prior. 
  # The first line creates an area (filled in with color), the second line creates a line graph
  stat_function(fun = dnorm, n = 1001, args = list(mean = 2.92, sd = sqrt(14)), geom = "area", aes(fill = "Original Prior: normal(2.92, 14)"), alpha = .5) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 2.92, sd = sqrt(14))) +
  # Repeat the above for each of the two alternative priors
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(28)), geom = "area", aes(fill = "Alternative 1: normal(0, 28)"), alpha = .5) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(28))) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(50)), geom = "area", aes(fill = "Alternative 2: normal(0, 50)"), alpha = .5) +
  stat_function(fun = dnorm, n = 1001, args = list(mean = 0, sd = sqrt(50))) +
  #scale_fill_brewer(palette = "Blues", name = "") +
  scale_fill_manual(values = c("#F8766D", "#00BA38", "#619CFF")) +
  ggtitle("Comparison of Priors") +
  xlab(bquote(beta[Intercept])) +
  theme_classic() +  
  theme(legend.position="bottom", 
        axis.title.x=element_text(family = "sans", size = 18),
        axis.title.y=element_blank(),
        plot.title = element_text(hjust = 0.5, family="sans", size = 18),
        legend.text=element_text(size=14))
# Print the plot
p

# model orig prior (1 divergent transition after warmup)
m_sens_orig <- brm(formula,
                   data = dat,
                   prior = priors_orig,
                   iter = 4000, chains = 4, warmup = 2000, thin = 1,
                   family = gaussian(), 
                   control = list(adapt_delta = 0.99, max_treedepth = 15))

plot(m_sens_orig) # looks good

# model alternative priors 2 (0 divergent transitions after warmup)
m_sens_2 <- brm(formula,
                data = dat,
                prior = priors2,
                iter = 4000, chains = 4, warmup = 2000, thin = 1,
                family = gaussian(), 
                control = list(adapt_delta = 0.99, max_treedepth = 15))

plot(m_sens_2) # looks good

# model alternative priors 3 (1 divergent transitions after warmup)
m_sens_3 <- brm(formula,
                data = dat,
                prior = priors3,
                iter = 4000, chains = 4, warmup = 2000, thin = 1,
                family = gaussian(), 
                control = list(adapt_delta = 0.99, max_treedepth = 15))

plot(m_sens_3) # looks good

summary(m_sens_orig) # Rhat and ESS'es look good
summary(m_sens_2) # Rhat and ESS'es look good
summary(m_sens_3) # Rhat and ESS'es look good

posterior_summary(m_sens_orig, variable=c("b_Intercept","b_TestSpeaker2", "b_Groupunfam", "sigma"))
posterior_summary(m_sens_2, variable=c("b_Intercept","b_TestSpeaker2", "b_Groupunfam", "sigma"))
posterior_summary(m_sens_3, variable=c("b_Intercept","b_TestSpeaker2", "b_Groupunfam", "sigma"))

# Visualize posterior distributions
# for prior_orig
m_sens_orig_tranformed <- ggs(m_sens_orig) # the ggs function transforms the brms output into a longformat tibble, that we can use to make different types of plots.
m_sens_2_tranformed <- ggs(m_sens_2)
m_sens_3_tranformed <- ggs(m_sens_3)

legend_colors <- c("Orig: normal(2.92, 14)" = "#F8766D", "Alt 1: normal(0, 28)" = "#00BA38", "Alt 2: normal(0, 50)" = "#619CFF")

ggplot() + 
  geom_density(data = filter(m_sens_orig_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 1000), aes(x = value, fill  = "Orig: normal(2.92, 14)"), alpha = .5) +
  geom_density(data = filter(m_sens_2_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 1000), aes(x = value, fill  = "Alt 1: normal(0, 28)"), alpha = .5) +
  geom_density(data = filter(m_sens_3_tranformed,
                             Parameter == "b_Intercept", 
                             Iteration > 1000), aes(x = value, fill  = "Alt 2: normal(0, 50)"),  alpha = .5) +
  scale_x_continuous(name   = "Value",
                     limits = c(-80, 80)) + 
  scale_fill_manual(name='Priors', values = legend_colors, breaks = c("Orig: normal(2.92, 14)", "Alt 1: normal(0, 28)", "Alt 2: normal(0, 50)")) +
  #set v-lines for the CIs
  geom_vline(xintercept = summary(m_sens_orig)$fixed[1,3],
             col = "#F8766D",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_orig)$fixed[1,4],
             col = "#F8766D",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_2)$fixed[1,3],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_2)$fixed[1,4],
             col = "#00BA38",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[1,3],
             col = "#619CFF",
             linetype = 2) +
  geom_vline(xintercept = summary(m_sens_3)$fixed[1,4],
             col = "#619CFF",
             linetype = 2) +
  theme_light() +
  labs(title = "Posterior Density of the Intercept for different priors") 

## CONCLUSION
# the priors do not seem to have a too large influence?


# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(ggplot2)
library(designr)
library(worcs)
library(ggmcmc)
library(RColorBrewer)

# I need this weird hack because otherwise it does not find the codebooks to load the data
setwd(here("data"))
load_data()
setwd(here())

# Specify a likelihood function  --------------------------------------------------------------------
# Plot the pilot data:
plot(density(data_pilot$MMR),
     main="Pilot data",xlab="MMR")
# --> the pilot data are normally distributed.
# We will thus take a gaussian function for the likelihood function

# CHECK with experimental data whether it's also normally distributed
# Plot the experimental data:
# XXXXXXXX
# Distribution experimental data = XXX
# We will thus take a XXXX function for the likelihood function


# Set priors  --------------------------------------------------------------------
# Define priors for the 0.4 Hz filtered data:
# We do that based on the pilot data:
plot(density(data_pilot$MMR),
     main="Pilot data",xlab="MMR")
mean(data_pilot$MMR)
sd(data_pilot$MMR)
# the data are normally distributed, the mean = 2.266946, SD = 11.74134

# let model run with default priors
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              data = data_pilot)
summary(pilot_m)
# Intercept = 2.89
# sigma = 10.64 

# let model run with weakly informative priors
prior_p <-
  c(
    prior("normal(0, 30)", class = "Intercept") #  weakly informative prior on intercept 
  , prior("normal(0, 30)", class = "b") #  weakly informative prior on slope
)
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              prior = prior_p,
               data = data_pilot)
summary(pilot_m)
# Intercept = 2.92
# sigma = 10.57

# So we set the following prior (we add some uncertainty, so a larger SD):
priors <- c(set_prior("normal(2.92, 14)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 14)",  # this is the prior on the slope
                      class = "b"),  
            set_prior("normal(0, 14)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case
                      class = "sigma")) #  sigma represents the standard deviation of the response variable, mmr in this case. 
                                        # it's a bit strange because of course, sigma cannot be smaller than zero..
                                        # an alternative to incorporate that would be normal(14,5)

# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(2.92, 14)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 14)",  # this is the prior on the slope
                      class = "b"))

validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot
)
# prior for sigma: student_t(3, 0, 9). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom


# Visualize the priors
dpri <- data.frame(x = seq(-50,50,by=1))
dpri$y1 <- dnorm(dpri$x,mean=2.92,sd=14)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=14)
#dpri$y3 <- dnorm(dpri$x,mean=14,sd=5)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=14)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=2.92, sd=14)", "Prior for slope\ndnorm(x, mean=0, sd=14)", "Prior for sigma\ndnorm(x, mean=0, sd=14)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")

##### Set priors based only on Sp1 and Sp4
data_pilot_ss = subset(data_pilot, TestSpeaker !=3)

plot(density(data_pilot_ss$MMR),
     main="Pilot data",xlab="MMR")
mean(data_pilot_ss$MMR)
sd(data_pilot_ss$MMR)
# the data are normally distributed (but bump around 28), the mean = 2.881777, SD = 10.92288

# let model run with default priors
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              data = data_pilot_ss)
summary(pilot_m)
# Intercept = 2.84
# sigma = 8.94

# let model run with weakly informative priors
prior_p <-
  c(
    prior("normal(0, 30)", class = "Intercept") #  weakly informative prior on intercept 
    , prior("normal(0, 30)", class = "b") #  weakly informative prior on slope
  )
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              prior = prior_p,
              data = data_pilot_ss)
summary(pilot_m)
# Intercept = 2.83
# sigma = 8.95

# --> adapt accordingly??


# Simulate some data --------------------------------------------------------------------
# create experimental design for ACQUISITION
design <-
  fixed.factor("Group", levels=c("fam", "unfam")) +
  fixed.factor("TestSpeaker", levels=c("1", "2")) +
  random.factor("Subj", groups="Group", instances=32)

dat <- design.codes(design)
# define a sum contrast. I take 0.5 instead of 1 because it's nicer for two levels (https://phillipalday.com/stats/coding.html)
dat$TestSpeaker_n <- ifelse(dat$TestSpeaker=="1", +0.5, -0.5)
dat$Group_n <- ifelse(dat$Group=="fam", +0.5, -0.5)

# simulate data
dat$MMR <- 2.92 + 5*dat$TestSpeaker_n + rnorm(nrow(dat),0,14) # 1st part: the mean of the MMR for all groups together, 2nd part: making sure the groups are different, 3rd part: adding noise: the SD of the MMR is 14

# now add dummy values for the other variables
dat$mumDistTrainS = NA
dat$mumDistNovelS = NA
dat$timeVoiceFam = NA
dat$nrSpeakersDaily = NA
dat$sleepState = NA

dat$mumDistTrainS = rep(abs(rnorm(nrow(dat)/2,1,2)), each=2)
dat$mumDistNovelS = rep(abs(rnorm(nrow(dat)/2,1,2.5)), each=2)
dat$timeVoiceFam = rep(round(rnorm(nrow(dat)/2,21,2)), each=2)
dat$nrSpeakersDaily = rep(round(rnorm(nrow(dat)/2,4,1)), each=2)
dat$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat)/2, replace = TRUE), each=2)

# centering the covariates -  CHECK WHETHER THIS IS NECESSARY
(dat <- dat %>%
    mutate(mumDistTrainS = mumDistTrainS - mean(mumDistTrainS)))
(dat <- dat %>%
    mutate(mumDistNovelS = mumDistNovelS - mean(mumDistNovelS)))
(dat <- dat %>%
    mutate(timeVoiceFam = timeVoiceFam - mean(timeVoiceFam)))
(dat <- dat %>%
    mutate(nrSpeakersDaily = nrSpeakersDaily - mean(nrSpeakersDaily)))


# create experimental design for RECOGNITION
design <-
  fixed.factor("Group", levels=c("fam", "unfam")) +
  fixed.factor("TestSpeaker", levels=c("1", "2")) +
  random.factor("Subj", groups="Group", instances=32)

dat_rec <- design.codes(design)
# define a sum contrast. I take 0.5 instead of 1 because it's nicer for two levels (https://phillipalday.com/stats/coding.html)
dat$TestSpeaker_n <- ifelse(dat$TestSpeaker=="1", +0.5, -0.5)
dat$Group_n <- ifelse(dat$Group=="fam", +0.5, -0.5)

# simulate data
dat_rec$MMR <- 2.92 + 5*dat_rec$TestSpeaker_n + rnorm(nrow(dat_rec),0,14) # 1st part: the mean of the MMR for all groups together, 2nd part: making sure the groups are different, 3rd part: adding noise: the SD of the MMR is 14

# now add dummy values for the other variables
dat$mumDistTrainS = NA
dat$mumDistNovelS = NA
dat$timeVoiceFam = NA
dat$nrSpeakersDaily = NA
dat$sleepState = NA

dat$mumDistTrainS = rep(abs(rnorm(nrow(dat)/2,1,2)), each=2)
dat$mumDistNovelS = rep(abs(rnorm(nrow(dat)/2,1,2.5)), each=2)
dat$timeVoiceFam = rep(round(rnorm(nrow(dat)/2,21,2)), each=2)
dat$nrSpeakersDaily = rep(round(rnorm(nrow(dat)/2,4,1)), each=2)
dat$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat)/2, replace = TRUE), each=2)

# centering the covariates -  CHECK WHETHER THIS IS NECESSARY
(dat <- dat %>%
    mutate(mumDistTrainS = mumDistTrainS - mean(mumDistTrainS)))
(dat <- dat %>%
    mutate(mumDistNovelS = mumDistNovelS - mean(mumDistNovelS)))
(dat <- dat %>%
    mutate(timeVoiceFam = timeVoiceFam - mean(timeVoiceFam)))
(dat <- dat %>%
    mutate(nrSpeakersDaily = nrSpeakersDaily - mean(nrSpeakersDaily)))


# # Now we add the contrasts to the factors itself: 
# ### CHECK WHETHER THIS IS NECESSARY
# contrasts(dat$Group) <- c(-0.5, +0.5)
# contrasts(dat$TestSpeaker) <- c(-0.5, +0.5)

# Prior predictive check --------------------------------------------------------------------
# Performing prior predictive simulations using brms
pm1 <- brm(MMR ~ 1 + Group * TestSpeaker + (1 | Subj), data = dat,
           prior = priors,
           iter = 2000, chains = 4,family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))
pp <- posterior_predict(pm1) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp), breaks = 40)
# distribution of the effect of TestSpeaker
TestSpeakerEffect <- colMeans(pp[dat$TestSpeaker=="2",]) - colMeans(pp[dat$TestSpeaker=="1",])
hist(TestSpeakerEffect, breaks = 40)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat$Group=="fam",]) - colMeans(pp[dat$Group=="unfam",])
hist(GroupEffect)

# This looks good, we see that in the distribution of the mean MMR, the value that is most often found is between 0-5, and our priors said that 
# the mean is 2.92. The SD also looks fine. Actually, this distribution looks a lot like the histogram for the actual pilot MMR data:
plot(hist(data_pilot$MMR),
     main="Pilot data",xlab="MMR")
# also, the effect of TestSpeaker (simulated as 5) seems to be retrieved, and the non-effect of Group is also retrieved

# Performing prior predictive simulations using brms with covariates
pm2 <- brm(MMR ~ 1 + TestSpeaker * Group + 
             mumDistTrainS * TestSpeaker + 
             mumDistNovelS * TestSpeaker + 
             timeVoiceFam * TestSpeaker * Group +
             nrSpeakersDaily * TestSpeaker * Group + 
             (1 | Subj) + (1 | TestSpeaker:Group),
           data = dat,
           prior = priors,
           iter = 2000, chains = 4,
           family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))

pp <- posterior_predict(pm2) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp), breaks = 40)
# distribution of the effect of TestSpeaker
TestSpeakerEffect <- colMeans(pp[dat$TestSpeaker=="2",]) - colMeans(pp[dat$TestSpeaker=="1",])
hist(TestSpeakerEffect, breaks = 40)
# distribution of the effect of Group
GroupEffect <- colMeans(pp[dat$Group=="fam",]) - colMeans(pp[dat$Group=="unfam",])
hist(GroupEffect)

# This looks good, we see that in the distribution of the mean MMR, the value that is most often found is between 0-5, and our priors said that 
# the mean is 2.92. The SD also looks fine. Actually, this distribution looks a lot like the histogram for the actual pilot MMR data:
plot(hist(data_pilot$MMR),
     main="Pilot data",xlab="MMR")
# also, the effect of TestSpeaker (simulated as 5) seems to be retrieved, and the non-effect of Group is also retrieved

# --> we see that added covariates to this check does not really change the results.


# sensitivity analysis --------------------------------------------------------------------
# other priors:
priors_orig <-
  c(set_prior("normal(2.92, 14)",  
              class = "Intercept"),
    set_prior("normal(0, 14)",  
              class = "b"))

priors2 <-
  c(set_prior("normal(0, 28)",  
                class = "Intercept"),
      set_prior("normal(0, 28)",  
                class = "b")) # weakly informative prior on intercept & slopes: this is still biologically plausible

priors3 <-
  c(set_prior("normal(0, 50)",  
              class = "Intercept"),
    set_prior("normal(0, 50)",  
              class = "b")) # uninformative prior on intercept & slopes: this is not biologically plausible


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

# model orig prior (converges)
m_sens_orig <- brm(MMR ~ 1 + TestSpeaker * Group + 
             mumDistTrainS * TestSpeaker + 
             mumDistNovelS * TestSpeaker + 
             timeVoiceFam * TestSpeaker * Group +
             nrSpeakersDaily * TestSpeaker * Group + 
             (1 | Subj) + (1 | TestSpeaker*Group),
           data = dat,
           prior = priors_orig,
           iter = 4000, chains = 4, warmup = 2000, thin = 1,
           family = gaussian(), 
           control = list(adapt_delta = 0.99, max_treedepth = 15))
plot(m_sens_orig) # looks good

# model alternative priors 2 (4 divergent transitions after warmup)
m_sens_2 <- brm(MMR ~ 1 + TestSpeaker * Group + 
                  mumDistTrainS * TestSpeaker + 
                  mumDistNovelS * TestSpeaker + 
                  timeVoiceFam * TestSpeaker * Group +
                  nrSpeakersDaily * TestSpeaker * Group + 
                  (1 | Subj) + (1 | TestSpeaker*Group),
                data = dat,
                prior = priors2,
                iter = 4000, chains = 4, warmup = 2000, thin = 1,
                family = gaussian(), 
                control = list(adapt_delta = 0.99, max_treedepth = 15))

plot(m_sens_2)

# model alternative priors 3 (4 divergent transitions after warmup)
m_sens_3 <- brm(MMR ~ 1 + TestSpeaker * Group + 
                  mumDistTrainS * TestSpeaker + 
                  mumDistNovelS * TestSpeaker + 
                  timeVoiceFam * TestSpeaker * Group +
                  nrSpeakersDaily * TestSpeaker * Group + 
                  (1 | Subj) + (1 | TestSpeaker*Group),
                data = dat,
                prior = priors3,
                iter = 4000, chains = 4, warmup = 2000, thin = 1,
                family = gaussian(), 
                control = list(adapt_delta = 0.99, max_treedepth = 15))
plot(m_sens_3)

summary(m_sens_orig)
summary(m_sens_2)
summary(m_sens_3)

posterior_summary(m_sens_orig, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_sens_2, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))
posterior_summary(m_sens_3, variable=c("b_Intercept","b_TestSpeaker1", "b_Group1", "sigma"))

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


# Posterior checks --------------------------------------------------------------------
# Now we check whether the model can also recover the underlying data (with our simulated data)
# define and fit model
m1 <- brm(MMR ~ 1 + TestSpeaker_n + (1 | Subj), data = dat,
          prior = priors,
          iter = 2000, chains = 4, family = gaussian(), 
          control = list(adapt_delta = 0.99))
# check traces and posterior distributions
plot(m1)
# the traces look like good hairy caterpillars
# since we simulated the data ourselves, we know the true values that the model needs to recover, 
# and we can check whether these distributions make sense: 
# the simulated data was: dat$MMR <- 2.92 + 5*dat$TestSpeaker_n + rnorm(nrow(dat),0,14)
# so the mean (intercept) should be ~2.92
# wordFreq (beta) shoud be ~ 5
# sigma should be ~14
# the posterior distributions look quite close to this! They are also normally distributed, and for example do not have 2 bumps

# Posterior check
pp_check(m1, ndraws=50)
# here we check whether the model is able to retrieve the underlying data. y is the observed data, so the data that we inputted, 
# and y' is the simulated data from the posterior predictive distribution. This looks good.

# look at summary (including Rhat + ESS)
summary(m1)
# posterior summary for reporting
posterior_summary(m1, variable="b_TestSpeaker_n")


# Posterior checks WITH COVARIATES--------------------------------------------------------------------
# Now we check whether the model can also recover the underlying data (with our simulated data)
# define and fit model
m1 <- brm(MMR ~ 1 + TestSpeaker * Group + 
            mumDistTrainS * TestSpeaker + 
            mumDistNovelS * TestSpeaker + 
            timeVoiceFam * TestSpeaker * Group +
            nrSpeakersDaily * TestSpeaker * Group + 
            (1 | Subj) + (1 | TestSpeaker*Group),
          data = dat,
          prior = priors,
          iter = 2000, chains = 4, family = gaussian(), 
          control = list(adapt_delta = 0.99))


# check traces and posterior distributions
plot(m1)
# the traces look like good hairy caterpillars
# since we simulated the data ourselves, we know the true values that the model needs to recover, 
# and we can check whether these distributions make sense: 
# the simulated data was: dat$MMR <- 2.92 + 5*dat$TestSpeaker_n + rnorm(nrow(dat),0,14)
# so the mean (intercept) should be ~2.92
# wordFreq (beta) shoud be ~ 5
# sigma should be ~14

#check this:
# the posterior distributions look quite close to this! They are also normally distributed, and for example do not have 2 bumps

# Posterior check
pp_check(m1, ndraws=50)
# here we check whether the model is able to retrieve the underlying data. y is the observed data, so the data that we inputted, 
# and y' is the simulated data from the posterior predictive distribution. This looks good.

# look at summary (including Rhat + ESS)
summary(m1)
# posterior summary for reporting
posterior_summary(m1, variable="b_TestSpeaker_n")





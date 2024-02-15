# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(brms)


# Posterior recovery checks WIHTOUT covariates --------------------------------------------------------------------
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





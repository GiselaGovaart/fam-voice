# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(brms)


# Set priors ------------------------------------------------------------
# priors 0.4 Hz filter
priors_acq_low <- c(set_prior("normal(5.94, 20.52)",  
                              class = "Intercept"),
                    set_prior("normal(0, 20.52)",  
                              class = "b"),
                    set_prior("normal(0, 20.52)",  
                              class = "sigma"))

priors_rec_low <- c(set_prior("normal(5.97, 23.34)",  
                              class = "Intercept"),
                    set_prior("normal(0, 23.34)",  
                              class = "b"),
                    set_prior("normal(0, 23.34)",  
                              class = "sigma")) 
# priors 1 Hz filter

## Checks for now with REC data:
# Posterior recovery checks WIHTOUT covariates --------------------------------------------------------------------
# Now we check whether the model can also recover the underlying data (with our simulated data)
# define and fit model
m1 <- brm(MMR ~ 1 + Group * TestSpeaker + (1 | Subj), data = dat_rec,
          prior = priors_rec_low,
          iter = 2000, chains = 4, family = gaussian(), 
          control = list(adapt_delta = 0.99))
# check traces and posterior distributions
plot(m1)
# the traces look like good hairy caterpillars
# since we simulated the data ourselves, we know the true values that the model needs to recover, 
# and we can check whether these distributions make sense: 
# the simulated data was: dat$MMR <- 6 + 5*dat$TestSpeaker_n + rnorm(nrow(dat),0,22)
# so the mean (intercept) should be ~ 6
# TestSpeaker (beta) shoud be ~ 5
# sigma should be ~ 22
# the posterior distributions look quite close to this:
# They are also normally distributed, and for example do not have 2 bumps
# b_Intercept is around 6
# It seems to retrieve an effect for TestSpeaker, and no effect for group
# sigma is around 20

# Posterior check
pp_check(m1, ndraws=50)
# here we check whether the model is able to retrieve the underlying data. y is the observed data, so the data that we inputted, 
# and y' is the simulated data from the posterior predictive distribution. This looks very good.

# look at summary (including Rhat + ESS)
summary(m1)
# --> these values are also good

# # posterior summary for reporting
# posterior_summary(m1, variable="b_TestSpeaker2")


# Posterior checks WITH COVARIATES--------------------------------------------------------------------
# Now we check whether the model can also recover the underlying data (with our simulated data)
# define and fit model
m2 <- brm(MMR ~ 1 + TestSpeaker * Group + 
            mumDistTrainS * TestSpeaker + 
            mumDistNovelS * TestSpeaker + 
            timeVoiceFam * Group +
            nrSpeakersDaily + 
            sleepState + 
            (1 + TestSpeaker * Group | Subj) ,
          data = dat_rec,
          prior = priors_rec_low,
          iter = 2000, chains = 4, family = gaussian(), 
          control = list(adapt_delta = 0.99))

# check traces and posterior distributions
plot(m2)
# the traces look like good hairy caterpillars
# since we simulated the data ourselves, we know the true values that the model needs to recover, 
# and we can check whether these distributions make sense: 
# the simulated data was: dat$MMR <- 6 + 5*dat$TestSpeaker_n + rnorm(nrow(dat),0,22)
# so the mean (intercept) should be ~6
# TestSpeaker (beta) shoud be ~ 5
# sigma should be ~22
# the posterior distributions look quite close to this:
# They are also normally distributed, and for example do not have 2 bumps
# b_Intercept is around 10
# It seems to retrieve a very small effect for TestSpeaker, and no effect for group
# sigma is around 20
# for the interactions, at least 0 is always in the distribution, it does not hallucinate crazy things (except may an effect for nrSpeakersDaily awake?)
# sigma for TestSpeaker and for Group seem to be okay, and the effect of sigma is around 20


# Posterior check
pp_check(m2, ndraws=50)
# here we check whether the model is able to retrieve the underlying data. y is the observed data, so the data that we inputted, 
# and y' is the simulated data from the posterior predictive distribution. This looks good.

# look at summary (including Rhat + ESS)
summary(m2)
# --> these values are also good


# # posterior summary for reporting
# posterior_summary(m1, variable="b_TestSpeaker2")





# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(brms)
library(here)
library(bayesplot)

# Set priors ------------------------------------------------------------
priors <- c(set_prior("normal(3.5, 20)", 
                      class = "Intercept"),
            set_prior("normal(0, 20)",  
                      class = "b"),
            set_prior("normal(0, 20)",  
                      class = "sigma")) 

# Set up sampling ------------------------------------------------------------
num_chains <- 4 
num_iter <- 10000 
num_warmup <- num_iter / 2 
num_thin <- 1 

# Posterior checks --------------------------------------------------------------------
# Now we check whether the model can also recover the underlying data (with our simulated data)

# ACQUISITION ----------------------------------------------------------------------------------------------------------------------------------
# define and fit model.
postpredcheck_intslope_acq_m <- brm(MMR ~ 1 + TestSpeaker * Group + 
                            mumDist +
                            nrSpeakersDaily +
                            sleepState +
                             age +
                             (1 + TestSpeaker | Subj),
                           data = dat_acq,
                           prior = priors,
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
                           file = here("data", "model_output", "04_model_posteriorpredcheck_randominterceptslope_acq.rds"),
                           file_refit = "on_change",
                           save_pars = save_pars(all = TRUE)
)

postpredcheck_intonly_acq_m <- brm(MMR ~ 1 + TestSpeaker * Group + 
                             mumDist +
                             nrSpeakersDaily +
                             sleepState +
                             age +
                             (1 | Subj),
                           data = dat_acq,
                           prior = priors,
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
                           file = here("data", "model_output", "04_model_posteriorpredcheck_randomintercept_acq.rds"),
                           file_refit = "on_change",
                           save_pars = save_pars(all = TRUE)
)

## First, check the residuals:
# Check for non-linearity and heteroskedasticy: Residuals vs. fitted values. 
# We want a random scatter of points, no pattern or funnel shape
residuals <- residuals(postpredcheck_intslope_acq_m)
fitted_values <- fitted(postpredcheck_intslope_acq_m)
plot(fitted_values, residuals, xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red")

# Scale location plot: Squared Residuals vs. fitted values to also check for heteroskedasticy.
# We want a random scatter of points, no pattern or funnel shape
sqrt_res <- sqrt(abs(residuals))
plot(fitted_values, sqrt_res, xlab = "Fitted Values", ylab = "Sqrt(|Residuals|)")

# QQ plot of residuals
# Residuals should closely follow th eline, Deviations, especially in the tails, suggest non-normality
mcmc_areas(as.array(residuals), prob = 0.5)

# Distributions of residuals
# We want a normal distribution centered around zero
hist(residuals, breaks = "Scott", main = "Histogram of Residuals", xlab = "Residuals")

# Autocorrelation check
# Significant autocorrelation at lags greater than zero suggest that residuals are not independent
acf(residuals)



# Check for non-linearity and heteroskedasticy: Residuals vs. fitted values. 
# We want a random scatter of points, no pattern or funnel shape
residuals <- residuals(postpredcheck_intonly_acq_m)
fitted_values <- fitted(postpredcheck_intonly_acq_m)
plot(fitted_values, residuals, xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red")

# Scale location plot: Squared Residuals vs. fitted values to also check for heteroskedasticy.
# We want a random scatter of points, no pattern or funnel shape
sqrt_res <- sqrt(abs(residuals))
plot(fitted_values, sqrt_res, xlab = "Fitted Values", ylab = "Sqrt(|Residuals|)")

# QQ plot of residuals
# Residuals should closely follow th eline, Deviations, especially in the tails, suggest non-normality
mcmc_areas(as.array(residuals), prob = 0.5)

# Distributions of residuals
# We want a normal distribution centered around zero
hist(residuals, breaks = "Scott", main = "Histogram of Residuals", xlab = "Residuals")

# Autocorrelation check
# Significant autocorrelation at lags greater than zero suggest that residuals are not independent
acf(residuals)

# check traces and posterior distributions
plot(postpredcheck_intslope_acq_m)
# the traces look like good hairy caterpillars, except for sigma
# since we simulated the data ourselves, we know the true values that the model needs to recover, 
# and we can check whether these distributions make sense: 
# so the mean (intercept) should be ~6
# Group (beta) should be ~ 5
# TestSpeaker (beta) should be ~ 5
# sigma should be ~15
# the posterior distributions look quite close to this:
# They are also normally distributed, and for example do not have 2 bumps
# b_Intercept is 7.63
# It retrieves an effect of 4.09 for TestSpeaker
# It retrieves an effect of 3.41 for Group
# It also hallucinates some effects for the covariates
# sigma is 11.78

# Posterior check
pp_check(postpredcheck_intslope_acq_m, ndraws=50)
# here we check whether the model is able to retrieve the underlying data. y is the observed data, so the data that we inputted, 
# and y' is the simulated data from the posterior predictive distribution. This looks very good.

# look at summary (including Rhat + ESS)
summary(postpredcheck_intslope_acq_m)
# --> these values are also good



# RECOGNITION ----------------------------------------------------------------------------------------------------------------------------------
# define and fit model.
postpredcheck_rec_m <- brm(MMR ~ 1 + TestSpeaker * Group + 
                             mumDist +
                             nrSpeakersDaily  + 
                             sleepState + 
                             age +
                             (1 + TestSpeaker | Subj),
                           data = dat_rec,
                           prior = priors,
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
                           file = here("data", "model_output", "04_model_posteriorpredcheck_rec.rds"),
                           file_refit = "on_change",
                           save_pars = save_pars(all = TRUE)
)
# check traces and posterior distributions
plot(postpredcheck_rec_m)

# the traces look like good hairy caterpillars
# since we simulated the data ourselves, we know the true values that the model needs to recover, 
# and we can check whether these distributions make sense: 
# the simulated data was: dat_rec$MMR <- 6 + 5*dat_rec$Group_n + rnorm(nrow(dat_rec),0,15)
# so the mean (intercept) should be ~6
# Group (beta) shoud be ~ 10
# sigma should be ~15
# the posterior distributions look quite close to this:
# They are also normally distributed, and for example do not have 2 bumps
# b_Intercept is around 10
# It seems to retrieve a very small effect for TestSpeaker, and no effect for group
# sigma is around 20
# for the interactions, at least 0 is always in the distribution, it does not hallucinate crazy things (except may an effect for nrSpeakersDaily awake?)
# sigma for TestSpeaker and for Group seem to be okay, and the effect of sigma is around 20


# Posterior check
pp_check(postpredcheck_rec_m, ndraws=50)
# here we check whether the model is able to retrieve the underlying data. y is the observed data, so the data that we inputted, 
# and y' is the simulated data from the posterior predictive distribution. This looks good.

# look at summary (including Rhat + ESS)
summary(postpredcheck_rec_m)
# --> these values are also good


# # posterior summary for reporting
# posterior_summary(m1, variable="b_TestSpeaker2")





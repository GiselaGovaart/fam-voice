
## most of this is copied in 00_priors.R

# RNG --------------------------------------------------------

project_seed <- 2049
set.seed(project_seed) # set seed

# install packages --------------------------------------------------------------------

# install.packages(worcs)
# install.packages("here")
# install.packages("tidyverse")

# load packages -----------------------------------------------------------------------
library(worcs)
library(here)
library(tidyverse)
library(designr)
library(brms)

# load data ---------------------------------------------------------------------------
# this data is the pilot data, which has the MMR
# - per TestSpeaker (1/2 coded as 1, 3 and 4)
# - for each subject

# I need this weird hack because otherwise it does not find the codebooks to load the data
setwd(here("data"))
load_data()
setwd(here())

# SIMULATE some data
# create experimental design
design <-
  fixed.factor("TestSpeaker", levels=c("train", "novel")) +
  fixed.factor("Group", levels=c("fam", "unfam")) +
  random.factor("Subj", groups="Group", instances=30)
dat <- design.codes(design)
# define a sum contrast
dat$TestSpeaker_n <- ifelse(dat$TestSpeaker=="train", +1, -1)
# simulate data. Here I simulate only positivities
set.seed(1)
dat$MMRsim <- rnorm(nrow(dat),10,10)
#dat$MMRsim <- 200 + 10*dat$TestSpeaker_n + rnorm(nrow(dat),0,50)

# Define priors and the likelihood -----------------------------------------
# visualize data
plot(density(dat$MMRsim),
     main="FamVoice",xlab="MMRsim")
# it looks normally distributed (a big surprise), so we assume normal distr for the likelihood 


# Priors:

# What do I expect
# - I expect the mean of my data somewhere between -10 and 10. 


priors <- c(set_prior("normal(0, 10)",  # sd=20 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      # in other words: # - I expect the mean of my data somewhere between -10 and 10. 
                      class = "Intercept"),
            set_prior("normal(0, 15)",  # 
                      class = "b",
                      coef="TestSpeaker_n"),
            set_prior("normal(0, 20)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case
                      # the mean of sigma = 0 means that we expect a mean SD of the MMR of 0, with and SD of the SD of 20 (that's how much uncertainty we have about the value zero)
                      class = "sigma", 
                      lb=0)) # I think this should be truncated, because the residual noise cant be negative

# we can also visualize the priors
dpri <- data.frame(x = seq(-20,20,by=1))
dpri$y1 <- dnorm(dpri$x,mean=0,sd=10)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=20)
dprig <- dpri %>% gather(y1, y2, key="Prior", value="Density")
dprig$Density[dprig$x<0 & dprig$Prior=="y2"] <- NA # truncate
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=0, sd=10)", "Prior for sigma\ndnorm(x, mean=0, sd=20)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")

# Performing prior predictive simulations using brms
# here it only uses the priors, not the data
pm1 <- brm(MMRsim ~ 1  + TestSpeaker_n, data = dat,   # You prob have to add group here
           prior = priors,
           iter = 2000, chains = 4,family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))
pp <- posterior_predict(pm1) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp))
# distribution of TestSpeaker effect
effectTestSpeaker <- colMeans(pp[dat$TestSpeaker=="train",]) - colMeans(pp[dat$TestSpeaker=="novel",])
hist(effectTestSpeaker)


# now play around, see if you set the prior for TestSpeaker_n to (15, 10), whether you get a bigger effect
priors <- c(set_prior("normal(0, 10)",  # sd=20 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      # in other words: # - I expect the mean of my data somewhere between -10 and 10. 
                      class = "Intercept"),
            set_prior("normal(15,10)",  # 
                      class = "b",
                      coef="TestSpeaker_n"),
            set_prior("normal(0, 20)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case
                      # the mean of sigma = 0 means that we expect a mean SD of the MMR of 0, with and SD of the SD of 20 (that's how much uncertainty we have about the value zero)
                      class = "sigma", 
                      lb=0)) # I think this should be truncated, because the residual noise cant be negative

pm2 <- brm(MMRsim ~ 1  + TestSpeaker_n, data = dat,   # You prob have to add group here
           prior = priors,
           iter = 2000, chains = 4,family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))
pp <- posterior_predict(pm2) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp))
# distribution of word frequency effects
effectTestSpeaker <- colMeans(pp[dat$TestSpeaker=="train",]) - colMeans(pp[dat$TestSpeaker=="novel",])
hist(effectTestSpeaker)

# --> this seems to work! but now you also want to think about how to interpret these effects
# and try to add an effet for group via the priors

priors <- c(set_prior("normal(0, 10)",  # sd=20 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      # in other words: # - I expect the mean of my data somewhere between -10 and 10. 
                      class = "Intercept"),
            set_prior("normal(0,15)",  # 
                      class = "b",
                      coef="TestSpeaker_n"),
            set_prior("normal(0, 20)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case
                      # the mean of sigma = 0 means that we expect a mean SD of the MMR of 0, with and SD of the SD of 20 (that's how much uncertainty we have about the value zero)
                      class = "sigma", 
                      lb=0)) # I think this should be truncated, because the residual noise cant be negative


pm3 <- brm(MMRsim ~ 1  + TestSpeaker_n * Group, data = dat,   # You prob have to add group here
           prior = priors,
           iter = 8000, chains = 4,family = gaussian(), 
           sample_prior = "only",
           control = list(adapt_delta = 0.99))
pp <- posterior_predict(pm3) 
pp <- t(pp)
# distribution of mean MMR
hist(colMeans(pp))
# distribution of word frequency effects
effectTestSpeaker <- colMeans(pp[dat$TestSpeaker=="train",]) - colMeans(pp[dat$TestSpeaker=="novel",])
hist(effectTestSpeaker)







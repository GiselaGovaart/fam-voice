# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(worcs)

# I need this weird hack because otherwise it does not find the codebooks to load the data
setwd(here("data"))
load_data()
setwd(here())

# remove S3 from acquisition data
data_pilot_acq_low = subset(data_pilot_acq_low, TestSpeaker == "S1" |TestSpeaker == "S4")
data_pilot_acq_high = subset(data_pilot_acq_high, TestSpeaker == "S1" |TestSpeaker == "S4")


# Specify a likelihood function  --------------------------------------------------------------------
# Plot the pilot data:
# ACQ LOW
plot(density(data_pilot_acq_low$MMR),
     main="Pilot data - ACQ, filter low",xlab="MMR")
# REC LOW
plot(density(data_pilot_rec_low$MMR),
     main="Pilot data - REC, filter low",xlab="MMR")
# ACQ HIGH
plot(density(data_pilot_acq_high$MMR),
     main="Pilot data - ACQ, filter high",xlab="MMR")
# REC HIGH
plot(density(data_pilot_rec_high$MMR),
     main="Pilot data - REC, filter high",xlab="MMR")

# --> all pilot data are normally distributed.
# We will thus take a gaussian function for the likelihood function for all models


# Plot the pilot data per speaker:
data_pilot_acq_low_s1 = subset(data_pilot_acq_low, TestSpeaker == "S1")
data_pilot_acq_low_s4 = subset(data_pilot_acq_low, TestSpeaker == "S4")

data_pilot_acq_high_s1 = subset(data_pilot_acq_high, TestSpeaker == "S1")
data_pilot_acq_high_s4 = subset(data_pilot_acq_high, TestSpeaker == "S4")

data_pilot_rec_low_s1 = subset(data_pilot_rec_low, TestSpeaker == "S1")
data_pilot_rec_low_s3 = subset(data_pilot_rec_low, TestSpeaker == "S3")
data_pilot_rec_low_s4 = subset(data_pilot_rec_low, TestSpeaker == "S4")

data_pilot_rec_high_s1 = subset(data_pilot_rec_high, TestSpeaker == "S1")
data_pilot_rec_high_s3 = subset(data_pilot_rec_high, TestSpeaker == "S3")
data_pilot_rec_high_s4 = subset(data_pilot_rec_high, TestSpeaker == "S4")

plot(density(data_pilot_acq_low_s1$MMR),
     main="Pilot ACQ filter low - S1",xlab="MMR")
plot(density(data_pilot_acq_low_s4$MMR),
     main="Pilot ACQ filter low - S4",xlab="MMR")
plot(density(data_pilot_acq_high_s1$MMR),
     main="Pilot ACQ filter high - S1",xlab="MMR")
plot(density(data_pilot_acq_high_s4$MMR),
     main="Pilot ACQ filter high - S4",xlab="MMR")
plot(density(data_pilot_rec_low_s1$MMR),
     main="Pilot REC filter low - S1",xlab="MMR")
plot(density(data_pilot_rec_low_s4$MMR),
     main="Pilot REC filter low - S4",xlab="MMR")
plot(density(data_pilot_rec_low_s3$MMR),
     main="Pilot REC filter low - S3",xlab="MMR")
plot(density(data_pilot_rec_high_s1$MMR),
     main="Pilot REC filter high - S1",xlab="MMR")
plot(density(data_pilot_rec_high_s4$MMR),
     main="Pilot REC filter high - S4",xlab="MMR")
plot(density(data_pilot_rec_high_s3$MMR),
     main="Pilot REC filter high - S3",xlab="MMR")


# CHECK with experimental data whether it's also normally distributed
# Plot the experimental data:
# XXXXXXXX
# Distribution experimental data = XXX
# We will thus take a XXXX function for the likelihood function

# Testing signs -----------------------------
sign_acq_low_s1 = sign(data_pilot_acq_low_s1$MMR)
nrnegs_acq_low_s1 = sum(sign_acq_low_s1<0)
totobs_acq_low_s1 = length(sign_acq_low_s1)
percnegs_acq_low_s1 = (nrnegs_acq_low_s1/totobs_acq_low_s1)*100

sign_acq_low_s4 = sign(data_pilot_acq_low_s4$MMR)
nrnegs_acq_low_s4 = sum(sign_acq_low_s4<0)
totobs_acq_low_s4 = length(sign_acq_low_s4)
percnegs_acq_low_s4 = (nrnegs_acq_low_s4/totobs_acq_low_s4)*100

sign_acq_high_s1 = sign(data_pilot_acq_high_s1$MMR)
nrnegs_acq_high_s1 = sum(sign_acq_high_s1<0)
totobs_acq_high_s1 = length(sign_acq_high_s1)
percnegs_acq_high_s1 = (nrnegs_acq_high_s1/totobs_acq_high_s1)*100

sign_acq_high_s4 = sign(data_pilot_acq_high_s4$MMR)
nrnegs_acq_high_s4 = sum(sign_acq_high_s4<0)
totobs_acq_high_s4 = length(sign_acq_high_s4)
percnegs_acq_high_s4 = (nrnegs_acq_high_s4/totobs_acq_high_s4)*100

sign_rec_low_s1 = sign(data_pilot_rec_low_s1$MMR)
nrnegs_rec_low_s1 = sum(sign_rec_low_s1<0)
totobs_rec_low_s1 = length(sign_rec_low_s1)
percnegs_rec_low_s1 = (nrnegs_rec_low_s1/totobs_rec_low_s1)*100

sign_rec_low_s4 = sign(data_pilot_rec_low_s4$MMR)
nrnegs_rec_low_s4 = sum(sign_rec_low_s4<0)
totobs_rec_low_s4 = length(sign_rec_low_s4)
percnegs_rec_low_s4 = (nrnegs_rec_low_s4/totobs_rec_low_s4)*100

sign_rec_low_s3 = sign(data_pilot_rec_low_s3$MMR)
nrnegs_rec_low_s3 = sum(sign_rec_low_s3<0)
totobs_rec_low_s3 = length(sign_rec_low_s3)
percnegs_rec_low_s3 = (nrnegs_rec_low_s3/totobs_rec_low_s3)*100

sign_rec_high_s1 = sign(data_pilot_rec_high_s1$MMR)
nrnegs_rec_high_s1 = sum(sign_rec_high_s1<0)
totobs_rec_high_s1 = length(sign_rec_high_s1)
percnegs_rec_high_s1 = (nrnegs_rec_high_s1/totobs_rec_high_s1)*100

sign_rec_high_s4 = sign(data_pilot_rec_high_s4$MMR)
nrnegs_rec_high_s4 = sum(sign_rec_high_s4<0)
totobs_rec_high_s4 = length(sign_rec_high_s4)
percnegs_rec_high_s4 = (nrnegs_rec_high_s4/totobs_rec_high_s4)*100

sign_rec_high_s3 = sign(data_pilot_rec_high_s3$MMR)
nrnegs_rec_high_s3 = sum(sign_rec_high_s3<0)
totobs_rec_high_s3 = length(sign_rec_high_s3)
percnegs_rec_high_s3 = (nrnegs_rec_high_s3/totobs_rec_high_s3)*100

percnegs_acq_low = mean(c(percnegs_acq_low_s1, percnegs_acq_low_s4))
percnegs_acq_high = mean(c(percnegs_acq_high_s1, percnegs_acq_high_s4))
percnegs_rec_low = mean(c(percnegs_rec_low_s1, percnegs_rec_low_s4, percnegs_rec_low_s3))
percnegs_rec_high = mean(c(percnegs_rec_high_s1, percnegs_rec_high_s4, percnegs_rec_high_s3))

percnegs_acq_low
percnegs_acq_high
percnegs_rec_low
percnegs_rec_high

# Set priors  --------------------------------------------------------------------
# We do that based on the pilot data:
# ACQUISITION LOW ----------------------------------------------------------------
plot(density(data_pilot_acq_low$MMR),
     main="Pilot data ACQ filter low",xlab="MMR")
mean(data_pilot_acq_low$MMR)
sd(data_pilot_acq_low$MMR)
# the data are normally distributed, the mean = 4.890247, SD = 15.08655

# let model run with default priors
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              data = data_pilot_acq_low)
summary(pilot_m)
# Intercept = 6.09
# sigma = 13.94 

# let model run with weakly informative priors
prior_p <-
  c(
    prior("normal(0, 30)", class = "Intercept") #  weakly informative prior on intercept 
  , prior("normal(0, 30)", class = "b") #  weakly informative prior on slope
)
pilot_m2 = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              prior = prior_p,
              data = data_pilot_acq_low,
              control = list(
                adapt_delta = .99, 
                max_treedepth = 15))
summary(pilot_m2)
# Intercept = 5.94
# sigma = 13.68

# So we set the following prior (we add some uncertainty, so a larger SD: *1.5):
priors <- c(set_prior("normal(5.94, 20.52)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 20.52)",  # this is the prior on the slope
                      class = "b"),
            set_prior("normal(0, 20.52)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case sigma represents the standard deviation of the response variable, mmr in this cas
                      class = "sigma")) # brms will automatically truncate the prior specification for σ and allow only positive values (https://vasishth.github.io/bayescogsci/book/ch-reg.html), so we don't have to truncate the distribution ourselves


# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(5.94, 20.52)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 20.52)",  # this is the prior on the slope
                      class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot_acq_low
)
# prior for sigma: student_t(3, 0, 10.3). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom


# Visualize the priors
dpri <- data.frame(x = seq(-70,70,by=1))
dpri$y1 <- dnorm(dpri$x,mean=5.94,sd=20.52)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=20.52)
#dpri$y3 <- dnorm(dpri$x,mean=14,sd=5)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=20.52)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=5.94, sd=20.52)", "Prior for slope\ndnorm(x, mean=0, sd=20.52)", "Prior for sigma\ndnorm(x, mean=0, sd=20.52)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")

# RECOGNITION LOW ----------------------------------------------------------------
plot(density(data_pilot_rec_low$MMR),
     main="Pilot data REC filter low",xlab="MMR")
mean(data_pilot_rec_low$MMR)
sd(data_pilot_rec_low$MMR)
# the data are normally distributed, the mean = 4.379175, SD = 15.3796

# let model run with default priors
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              data = data_pilot_rec_low)
summary(pilot_m)
# Intercept = 6.22
# sigma = 15.58 

# let model run with weakly informative priors
prior_p <-
  c(
    prior("normal(0, 30)", class = "Intercept"), #  weakly informative prior on intercept 
    prior("normal(0, 30)", class = "b") #  weakly informative prior on slope
  )
pilot_m2 = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
               prior = prior_p,
               data = data_pilot_rec_low,
               control = list(
                 adapt_delta = .99, 
                 max_treedepth = 15))
summary(pilot_m2)
# Intercept = 5.97
# sigma = 15.56

# So we set the following prior (we add some uncertainty, so a larger SD: *1.5):
priors <- c(set_prior("normal(5.97, 23.34)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 23.34)",  # this is the prior on the slope
                      class = "b"),
            set_prior("normal(0, 23.34)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case sigma represents the standard deviation of the response variable, mmr in this cas
                      class = "sigma")) # it's a bit strange because of course, sigma cannot be smaller than zero..an alternative to incorporate that would be normal(14,5)
# alternative for sigma:
# prior_sigma <- set_prior("student_t(3, 0, 23.34)", class = "sigma")


# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(5.97, 23.34)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                              class = "Intercept"),
                    set_prior("normal(0, 23.34)",  # this is the prior on the slope
                              class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot_rec_low
)
# prior for sigma: student_t(3, 0, 7.9). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom

# Visualize the priors
dpri <- data.frame(x = seq(-70,70,by=1))
dpri$y1 <- dnorm(dpri$x,mean=5.97,sd=23.34)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=23.34)
#dpri$y3 <- dnorm(dpri$x,mean=14,sd=5)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=23.34)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=5.97, sd=23.34)", "Prior for slope\ndnorm(x, mean=0, sd=23.34)", "Prior for sigma\ndnorm(x, mean=0, sd=23.34)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")


# ACQUISITION HIGH ----------------------------------------------------------------
plot(density(data_pilot_acq_high$MMR),
     main="Pilot data ACQ filter high",xlab="MMR")
mean(data_pilot_acq_high$MMR)
sd(data_pilot_acq_high$MMR)
# the data are more or less normally distributed, the mean = 2.844452, SD = 6.36463

# let model run with default priors
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              data = data_pilot_acq_high)
summary(pilot_m)
# Intercept = 2.74
# sigma = 5.68 

# let model run with weakly informative priors
prior_p <-
  c(
    prior("normal(0, 30)", class = "Intercept") #  weakly informative prior on intercept 
    , prior("normal(0, 30)", class = "b") #  weakly informative prior on slope
  )
pilot_m2 = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
               prior = prior_p,
               data = data_pilot_acq_high,
               control = list(
                 adapt_delta = .99, 
                 max_treedepth = 15))
summary(pilot_m2)
# Intercept = 2.83
# sigma = 5.67


# So we set the following prior (we add some uncertainty, so a larger SD):
priors <- c(set_prior("normal(2.83, 8.56)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 8.56)",  # this is the prior on the slope
                      class = "b"),
            set_prior("normal(0, 8.56)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case sigma represents the standard deviation of the response variable, mmr in this cas
                      class = "sigma")) # it's a bit strange because of course, sigma cannot be smaller than zero..an alternative to incorporate that would be normal(14,5)
# alternative for sigma:
# prior_sigma <- set_prior("student_t(3, 0, 8.56)", class = "sigma")


# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(2.83,8.56)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                              class = "Intercept"),
                    set_prior("normal(0, 8.56)",  # this is the prior on the slope
                              class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot_acq_high
)
# prior for sigma: student_t(3, 0, 3.6). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom

# Visualize the priors
dpri <- data.frame(x = seq(-70,70,by=1))
dpri$y1 <- dnorm(dpri$x,mean=2.83,sd=8.56)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=8.56)
#dpri$y3 <- dnorm(dpri$x,mean=14,sd=5)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=8.56)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=2.83, sd=8.56)", "Prior for slope\ndnorm(x, mean=0, sd=8.56)", "Prior for sigma\ndnorm(8.56)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")


# RECOGNITION HIGH ----------------------------------------------------------------
plot(density(data_pilot_rec_high$MMR),
     main="Pilot data REC filter high",xlab="MMR")
mean(data_pilot_rec_high$MMR)
sd(data_pilot_rec_high$MMR)
# the data are more or less normally distributed, the mean = 2.273048, SD = 7.195947

# let model run with default priors
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              data = data_pilot_rec_high,
              control = list(
                adapt_delta = .99, 
                max_treedepth = 15))
summary(pilot_m)
# Intercept = 3.18
# sigma = 7.29 

# let model run with weakly informative priors
prior_p <-
  c(
    prior("normal(0, 30)", class = "Intercept") #  weakly informative prior on intercept 
    , prior("normal(0, 30)", class = "b") #  weakly informative prior on slope
  )
pilot_m2 = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
               prior = prior_p,
               data = data_pilot_rec_high,
               control = list(
                 adapt_delta = .99, 
                 max_treedepth = 15))
summary(pilot_m2)
# Intercept = 3.18
# sigma = 7.32


# So we set the following prior (we add some uncertainty, so a larger SD: *1.5):
priors <- c(set_prior("normal(3.18, 10.98)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 10.98)",  # this is the prior on the slope
                      class = "b"),
            set_prior("normal(0, 10.98)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case sigma represents the standard deviation of the response variable, mmr in this cas
                      class = "sigma")) # it's a bit strange because of course, sigma cannot be smaller than zero..an alternative to incorporate that would be normal(14,5)
# alternative for sigma:
# prior_sigma <- set_prior("student_t(3, 0, 10.98)", class = "sigma")


# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(3.18,10.98)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                              class = "Intercept"),
                    set_prior("normal(0, 10.98)",  # this is the prior on the slope
                              class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot_acq_high
)
# prior for sigma: student_t(3, 0, 3.6). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom

# Visualize the priors
dpri <- data.frame(x = seq(-70,70,by=1))
dpri$y1 <- dnorm(dpri$x,mean=3.18,sd=10.98)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=10.98)
#dpri$y3 <- dnorm(dpri$x,mean=14,sd=5)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=10.98)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=3.18, sd=10.98)", "Prior for slope\ndnorm(x, mean=0, sd=10.98)", "Prior for sigma\ndnorm(x, mean=0, sd=10.98)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")


## SUMMARY -------------------------------------------------------------------------------------------------------------------------

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



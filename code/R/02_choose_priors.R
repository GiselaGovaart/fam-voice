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

# Specify a likelihood function  --------------------------------------------------------------------
# Plot the pilot data:
plot(density(data_pilot$MMR),
     main="Pilot data - all (REC)",xlab="MMR")
# --> the pilot data are normally distributed.
# We will thus take a gaussian function for the likelihood function

# Plot only S1 and S4 (ACQ)
pilot_s14 = subset(data_pilot, TestSpeaker == 1|TestSpeaker == 4)
plot(density(pilot_s14$MMR),
     main="Pilot data - S1&S4 (ACQ)",xlab="MMR")

# Plot the pilot data per speaker:
pilot_s1 = subset(data_pilot, TestSpeaker == 1)
pilot_s3 = subset(data_pilot, TestSpeaker == 3)
pilot_s4 = subset(data_pilot, TestSpeaker == 4)

plot(density(pilot_s1$MMR),
     main="Pilot data - S1",xlab="MMR")
plot(density(pilot_s3$MMR),
     main="Pilot data - S3",xlab="MMR")
plot(density(pilot_s4$MMR),
     main="Pilot data - S4",xlab="MMR")

# CHECK with experimental data whether it's also normally distributed
# Plot the experimental data:
# XXXXXXXX
# Distribution experimental data = XXX
# We will thus take a XXXX function for the likelihood function

# Testing signs -----------------------------
sign_s1 = sign(data_pilot$MMR[data_pilot$TestSpeaker==1])
sign_s3 = sign(data_pilot$MMR[data_pilot$TestSpeaker==3])
sign_s4 = sign(data_pilot$MMR[data_pilot$TestSpeaker==4])

nrnegs_s1 = sum(sign_s1<0)
totobs_s1 = length(sign_s1)
percnegs_s1 = (nrnegs_s1/totobs_s1)*100

nrnegs_s3 = sum(sign_s3<0)
totobs_s3 = length(sign_s3)
percnegs_s3 = (nrnegs_s3/totobs_s3)*100

nrnegs_s4 = sum(sign_s4<0)
totobs_s4 = length(sign_s4)
percnegs_s4 = (nrnegs_s4/totobs_s4)*100

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
            set_prior("normal(0, 14)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this casesigma represents the standard deviation of the response variable, mmr in this cas
                      class = "sigma")) # it's a bit strange because of course, sigma cannot be smaller than zero..an alternative to incorporate that would be normal(14,5)
         
# altermnative for sigma:
#prior_sigma <- set_prior("student_t(3, 0, 20)", class = "sigma")






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





# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(worcs)

# load data --------------------------------------------------------------------
data_pilot_acq = read_csv(here("data","data_pilot_acq.csv"))
data_pilot_rec = read_csv(here("data","data_pilot_rec.csv"))
# remove S3 from acquisition data
data_pilot_acq = subset(data_pilot_acq, TestSpeaker == "S1" |TestSpeaker == "S4")

data_pilot_acq$TestSpeaker = as.factor(data_pilot_acq$TestSpeaker)
data_pilot_rec$TestSpeaker = as.factor(data_pilot_rec$TestSpeaker)


# Specify a likelihood function  --------------------------------------------------------------------
# Plot the pilot data:
# ACQ 
p_acq = plot(density(data_pilot_acq$MMR),
     main="Pilot data - ACQ",xlab="MMR")
# REC 
p_rec = plot(density(data_pilot_rec$MMR),
     main="Pilot data - REC",xlab="MMR")

# --> the pilot data are normally distributed.
# We will thus take a gaussian function for the likelihood function for all models

# Plot the pilot data per speaker:
data_pilot_acq_s1 = subset(data_pilot_acq, TestSpeaker == "S1")
data_pilot_acq_s4 = subset(data_pilot_acq, TestSpeaker == "S4")

data_pilot_rec_s1 = subset(data_pilot_rec, TestSpeaker == "S1")
data_pilot_rec_s3 = subset(data_pilot_rec, TestSpeaker == "S3")
data_pilot_rec_s4 = subset(data_pilot_rec, TestSpeaker == "S4")

p_acq_s1 = plot(density(data_pilot_acq_s1$MMR),
     main="Pilot ACQ- S1",xlab="MMR")
p_acq_s4 =plot(density(data_pilot_acq_s4$MMR),
     main="Pilot ACQ - S4",xlab="MMR")

p_rec_s1 = plot(density(data_pilot_rec_s1$MMR),
     main="Pilot REC - S1",xlab="MMR")
p_rec_s4 = plot(density(data_pilot_rec_s4$MMR),
     main="Pilot REC - S4",xlab="MMR")
p_rec_s3 = plot(density(data_pilot_rec_s3$MMR),
     main="Pilot REC - S3",xlab="MMR")


# CHECK with experimental data whether it's also normally distributed
# Plot the experimental data:
# XXXXXXXX
# Distribution experimental data = XXX
# We will thus take a XXXX function for the likelihood function

# Testing signs -------------------------------------------------------------------
sign_acq_s1 = sign(data_pilot_acq_s1$MMR)
nrnegs_acq_s1 = sum(sign_acq_s1<0)
totobs_acq_s1 = length(sign_acq_s1)
percnegs_acq_s1 = (nrnegs_acq_s1/totobs_acq_s1)*100

sign_acq_s4 = sign(data_pilot_acq_s4$MMR)
nrnegs_acq_s4 = sum(sign_acq_s4<0)
totobs_acq_s4 = length(sign_acq_s4)
percnegs_acq_s4 = (nrnegs_acq_s4/totobs_acq_s4)*100

sign_rec_s1 = sign(data_pilot_rec_s1$MMR)
nrnegs_rec_s1 = sum(sign_rec_s1<0)
totobs_rec_s1 = length(sign_rec_s1)
percnegs_rec_s1 = (nrnegs_rec_s1/totobs_rec_s1)*100

sign_rec_s4 = sign(data_pilot_rec_s4$MMR)
nrnegs_rec_s4 = sum(sign_rec_s4<0)
totobs_rec_s4 = length(sign_rec_s4)
percnegs_rec_s4 = (nrnegs_rec_s4/totobs_rec_s4)*100

sign_rec_s3 = sign(data_pilot_rec_s3$MMR)
nrnegs_rec_s3 = sum(sign_rec_s3<0)
totobs_rec_s3 = length(sign_rec_s3)
percnegs_rec_s3 = (nrnegs_rec_s3/totobs_rec_s3)*100

percnegs_acq = mean(c(percnegs_acq_s1, percnegs_acq_s4))
percnegs_rec = mean(c(percnegs_rec_s1, percnegs_rec_s4, percnegs_rec_s3))


# Set priors  --------------------------------------------------------------------
# We do that based on the pilot data:
# ACQUISITION ----------------------------------------------------------------
plot(density(data_pilot_acq$MMR),
     main="Pilot data ACQ",xlab="MMR")
mean(data_pilot_acq$MMR)
sd(data_pilot_acq$MMR)
# the data are normally distributed, the mean = 4.326752, SD = 17.58751

contrasts(data_pilot_acq$TestSpeaker) = contr.sum(2)

# let model run with very weakly informative priors
prior_p <-
  c(
    prior("normal(0, 35)", class = "Intercept") #  weakly informative prior on intercept 
  , prior("normal(0, 35)", class = "b") #  weakly informative prior on slope
)
pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
              prior = prior_p,
              data = data_pilot_acq,
              control = list(
                adapt_delta = .99, 
                max_treedepth = 15),
              file = here("data", "model_output", "02_pilot_acq.rds"))
summary(pilot_m)
# Intercept = 4.22
# sigma = 14.01

# So we set the following prior (we add some uncertainty, so a larger SD: 14*1.5):
priors_acq <- c(set_prior("normal(4.22, 21)",  # sd=21 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 21)",  # this is the prior on the slope
                      class = "b"),
            set_prior("normal(0, 21)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case sigma represents the standard deviation of the response variable, mmr in this case
                      class = "sigma")) # brms will automatically truncate the prior specification for σ and allow only positive values (https://vasishth.github.io/bayescogsci/book/ch-reg.html), so we don't have to truncate the distribution ourselves

# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(4.22, 21)",  
                      class = "Intercept"),
            set_prior("normal(0, 21)",  # this is the prior on the slope
                      class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot_acq
)
# prior for sigma: student_t(3, 0, 9.8). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom



# let's check the default prior for the other coefficients, using our simulated data
priors_test <- c(set_prior("normal(4.22, 17.5)",  
                              class = "Intercept"),
                    # set_prior("normal(0, 17.5)",  # this is the prior on the slope
                    #           class = "b"),
                    set_prior("normal(0, 17.5)",  
                              class = "sigma")
                 )
validate_prior(priors_test, 
               MMR ~ 1 + TestSpeaker * Group + 
                 mumDist +
                 nrSpeakersDaily  + 
                 sleepState + 
                 age +
                 (1 + TestSpeaker * Group | Subj), 
               data = dat_acq
)



# Visualize the priors
dpri <- data.frame(x = seq(-70,70,by=1))
dpri$y1 <- dnorm(dpri$x,mean=4.22,sd=21)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=21)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=21)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=4.22, sd=21)", "Prior for slope\ndnorm(x, mean=0, sd=21)", "Prior for sigma\ndnorm(x, mean=0, sd=21)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")

# RECOGNITION  ----------------------------------------------------------------
plot(density(data_pilot_rec$MMR),
     main="Pilot data REC filter low",xlab="MMR")
mean(data_pilot_rec$MMR)
sd(data_pilot_rec$MMR)
# the data are normally distributed, the mean = 3.546836, SD = 16.40196

contrasts(data_pilot_rec$TestSpeaker) = contr.sum(3)


# let model run with weakly informative priors
prior_p <-
  c(
    prior("normal(0, 35)", class = "Intercept"), #  weakly informative prior on intercept 
    prior("normal(0, 35)", class = "b") #  weakly informative prior on slope
  )
pilot_m2 = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
               prior = prior_p,
               data = data_pilot_rec,
               control = list(
                 adapt_delta = .99, 
                 max_treedepth = 15),
               file = here("data", "model_output", "02_pilot_rec.rds")
               )
summary(pilot_m2)
# Intercept = 3.5
# sigma = 16.12

# So we set the following prior (we add some uncertainty, so a larger SD: 16*1.5):
priors_rec <- c(set_prior("normal(3.5, 24)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 24)",  # this is the prior on the slope
                      class = "b"),
            set_prior("normal(0, 24)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case sigma represents the standard deviation of the response variable, mmr in this cas
                      class = "sigma")) # it's a bit strange because of course, sigma cannot be smaller than zero..an alternative to incorporate that would be normal(14,5)

# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(3.5, 24)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                              class = "Intercept"),
                    set_prior("normal(0, 24)",  # this is the prior on the slope
                              class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot_rec
)
# prior for sigma: student_t(3, 0, 9.8). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom

# Visualize the priors
dpri <- data.frame(x = seq(-70,70,by=1))
dpri$y1 <- dnorm(dpri$x,mean=3.5,sd=24)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=24)
#dpri$y3 <- dnorm(dpri$x,mean=14,sd=5)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=24)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=3.5, sd=24)", "Prior for slope\ndnorm(x, mean=0, sd=24)", "Prior for sigma\ndnorm(x, mean=0, sd=24)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")


## SUMMARY -------------------------------------------------------------------------------------------------------------------------

priors_acq <- c(set_prior("normal(4.22, 21)",  
                              class = "Intercept"),
                    set_prior("normal(0, 21)",  
                              class = "b"),
                    set_prior("normal(0, 21)",  
                              class = "sigma"))

priors_rec <- c(set_prior("normal(3.5, 24)", 
                          class = "Intercept"),
                set_prior("normal(0, 24)",  
                          class = "b"),
                set_prior("normal(0, 24)", 
                          class = "sigma")) 



# We now set a prior of "normal(0, 21)" on every slope. This is strange because we do not expect effects that large.
# We would rather expect effects of normal(0,10) max.
# moreover, we would need to scale these priors for the scaled predictors
# Assuming an SD of:
# age: SD=10
# mumDist: SD = 2
# nrSpeakersDaily: SD=2
# we would need to adjust our priors on those coefficients:
# age: normal(0, 1)
# mumDist: normal(0, 5)
# nrSpeakersDaily: normal(0, 5)

priors_acq <- c(set_prior("normal(4.22, 17.5)",  
                          class = "Intercept"),
                set_prior("normal(0, 1)",  
                          class = "b", coef = "age"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "Group1"),
                set_prior("normal(0, 5)",  
                          class = "b", coef = "mumDist"),
                set_prior("normal(0, 5)",  
                          class = "b", coef = "nrSpeakersDaily"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "sleepStateawake"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "sleepStatequietsleep"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "TestSpeaker1"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "TestSpeaker1:Group1" ),
                set_prior("normal(0, 17.5)",  
                          class = "sigma"))



priors_nosigma <- c(set_prior("normal(3.5, 24)",  # sd=14 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                              class = "Intercept"),
                    set_prior("normal(0, 24)",  # this is the prior on the slope
                              class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker * Group + 
                 mumDist +
                 nrSpeakersDaily +
                 sleepState +
                 age +
                 (1 + TestSpeaker | Subj),
               data = dat_acq
)



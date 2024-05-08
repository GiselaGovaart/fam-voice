# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------
library(here)
library(tidyverse)
library(brms)
library(worcs)

# load data --------------------------------------------------------------------
data_pilot = read_csv(here("data","data_pilot.csv"))
data_pilot$TestSpeaker = as.factor(data_pilot$TestSpeaker)


# Specify a likelihood function  --------------------------------------------------------------------
# Plot the pilot data:
# ACQ 
p = plot(density(data_pilot$MMR),
     main="Pilot data",xlab="MMR")

# --> the pilot data are normally distributed.
# We will thus take a gaussian function for the likelihood function for all models

# Plot the pilot data per speaker:
data_pilot_s1 = subset(data_pilot, TestSpeaker == "S1")
data_pilot_s3 = subset(data_pilot, TestSpeaker == "S3")
data_pilot_s4 = subset(data_pilot, TestSpeaker == "S4")

p_s1 = plot(density(data_pilot_s1$MMR),
     main="Pilot - S1",xlab="MMR")
p_s4 = plot(density(data_pilot_s4$MMR),
     main="Pilot - S4",xlab="MMR")
p_s3 = plot(density(data_pilot_s3$MMR),
     main="Pilot - S3",xlab="MMR")


# CHECK with experimental data whether it's also normally distributed
# Plot the experimental data:
# XXXXXXXX
# Distribution experimental data = XXX
# We will thus take a XXXX function for the likelihood function

# Testing signs ------------------------------------------------------------------
sign_s1 = sign(data_pilot_s1$MMR)
nrnegs_s1 = sum(sign_s1<0)
totobs_s1 = length(sign_s1)
percnegs_s1 = (nrnegs_s1/totobs_s1)*100

sign_s4 = sign(data_pilot_s4$MMR)
nrnegs_s4 = sum(sign_s4<0)
totobs_s4 = length(sign_s4)
percnegs_s4 = (nrnegs_s4/totobs_s4)*100

sign_s3 = sign(data_pilot_s3$MMR)
nrnegs_s3 = sum(sign_s3<0)
totobs_s3 = length(sign_s3)
percnegs_s3 = (nrnegs_s3/totobs_s3)*100

percnegs = mean(c(percnegs_s1, percnegs_s4, percnegs_s3))

# Set priors  --------------------------------------------------------------------
# We do that based on the pilot data:
plot(density(data_pilot$MMR),
     main="Pilot data",xlab="MMR")
mean(data_pilot$MMR)
sd(data_pilot$MMR)
# the data are normally distributed, the mean = 3.546836, SD = 16.40196

contrasts(data_pilot$TestSpeaker) = contr.sum(3)

# let model run with weakly informative priors
prior_pilot <-
  c(
    prior("normal(0, 35)", class = "Intercept"), #  weakly informative prior on intercept 
    prior("normal(0, 35)", class = "b") #  weakly informative prior on slope
  )

pilot_m = brm(MMR ~ 1 + TestSpeaker + (1 | Subj), 
               prior = prior_pilot,
               data = data_pilot,
               control = list(
                 adapt_delta = .99, 
                 max_treedepth = 15),
               file = here("data", "model_output", "02_pilot.rds")
               )
summary(pilot_m)
# Intercept = 3.5
# sigma = 16.12

# So we set the following prior (we add some uncertainty, so a larger SD: 16*1.25):
priors <- c(set_prior("normal(3.5, 20)",  # sd=20 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                      class = "Intercept"),
            set_prior("normal(0, 20)",  # this is the prior on the slope
                      class = "b"),
            set_prior("normal(0, 20)",  # this is our expectation about the error in the model, so the residual noise. it's the SD of the likelihood. It's the SD of the MMR in this case sigma represents the standard deviation of the response variable, mmr in this case
                      class = "sigma")) # brms will automatically truncate the prior specification for σ and allow only positive values (https://vasishth.github.io/bayescogsci/book/ch-reg.html), so we don't have to truncate the distribution ourselves

# let's check the default prior for sigma in brms:
priors_nosigma <- c(set_prior("normal(3.5, 20)",  # sd=20 is here the SD of the distribution of the prior on mu, so how uncertain we are about the value of mu
                              class = "Intercept"),
                    set_prior("normal(0, 20)",  # this is the prior on the slope
                              class = "b"))
validate_prior(priors_nosigma, 
               MMR ~ 1 + TestSpeaker + (1 | Subj), 
               data = data_pilot_rec
)
# prior for sigma: student_t(3, 0, 9.8). student_t is a bell-shaped distribution but with heavier tails than normal distribution. this one has 3 degrees of freedom

# Visualize the priors
dpri <- data.frame(x = seq(-70,70,by=1))
dpri$y1 <- dnorm(dpri$x,mean=3.5,sd=20)
dpri$y2 <- dnorm(dpri$x,mean=0,sd=20)
dpri$y3 <- dnorm(dpri$x,mean=0,sd=20)

dprig <- dpri %>% gather(y1, y2, y3, key="Prior", value="Density")
dprig$Prior <- factor(dprig$Prior)
levels(dprig$Prior) <- c("Prior for mu\ndnorm(x, mean=3.5, sd=20)", "Prior for slope\ndnorm(x, mean=0, sd=20)", "Prior for sigma\ndnorm(x, mean=0, sd=20)")
ggplot(data=dprig, aes(x=x, y=Density)) + geom_line() + facet_wrap(~Prior, scales="free")


# We now set a prior of "normal(0, 20)" on every slope. This is strange because we do not expect effects that large.
# We would rather expect effects of normal(0,10) max.
# so we could also do this:
priors_alt <- c(set_prior("normal(3.5, 20)",  
                          class = "Intercept"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "age"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "Group1"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "mumDist"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "nrSpeakersDaily"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "sleepState1"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "sleepState2"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "TestSpeaker1"),
                set_prior("normal(0, 10)",  
                          class = "b", coef = "TestSpeaker1:Group1" ),
                set_prior("normal(0, 20)",  
                          class = "sigma"))
# However, this does not really seem to make a difference, so we will leave it.


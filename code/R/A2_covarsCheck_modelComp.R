
# 8/2: look at whether you need to implement this: https://www.flutterbys.com.au/stats/tut/tut7.5b.html



# RNG --------------------------------------------------------
project_seed <- 2049
set.seed(project_seed) # set seed

# load packages --------------------------------------------------------------------

library(here)
library(tidyverse)
library(brms)
library(easystats)
library(loo)

# setup: STAN --------------------------------------------------------------------
num_chains <- 4 # number of chains = number of processor cores
num_iter <- 4000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain


# load data  --------------------------------------------------------------------
# I need this weird hack because otherwise it does not find the codebooks
# setwd(here("data"))
# load_data()
# setwd(here())

# centering the covariates -----------------------------------------------------

# Center and scale: this subtracts the mean from each value and then divides by the SD
dat$mumDistTrainS <- scale(dat$mumDistTrainS)
dat$mumDistNovelS <- scale(dat$mumDistNovelS)
dat$timeVoiceFam <- scale(dat$timeVoiceFam)
dat$nrSpeakersDaily <- scale(dat$nrSpeakersDaily)

dat_rec$mumDistTrainS <- scale(dat_rec$mumDistTrainS)
dat_rec$mumDistNovelS <- scale(dat_rec$mumDistNovelS)
dat_rec$timeVoiceFam <- scale(dat_rec$timeVoiceFam)
dat_rec$nrSpeakersDaily <- scale(dat_rec$nrSpeakersDaily)

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





# check for collinearity ----------------------------------------------
# Make correlation matrix
correlation_matrix <- cor(dat[, c("mumDistTrainS", "mumDistNovelS", "timeVoiceFam", "nrSpeakersDaily")])
print(correlation_matrix)
corrplot(correlation_matrix, method = "circle")
# check with in-built check_collinearity function --> 
# It calculates the variance inflation factors (VIF) for each covariate, 
# with values greater than 10 indicating potential collinearity issues.
collinearity_results <- check_collinearity(MMR_m)
print(collinearity_results)

# END --------------------------------------------------------



# Setting up contrasts for during the model fitting -------------
contrasts(dat$TestSpeaker) <- contr.equalprior
contrasts(dat$Group) <- contr.equalprior
contrasts(dat$sleepState) <- contr.equalprior

contrasts(dat_rec$TestSpeaker) <- contr.equalprior
contrasts(dat_rec$Group) <- contr.equalprior
contrasts(dat_rec$sleepState) <- contr.equalprior

# formulas ----------
f_all = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  mumDistNovelS * TestSpeaker + 
  timeVoiceFam * Group +
  nrSpeakersDaily + 
  sleepState + 
  (1 + TestSpeaker * Group | Subj) 

f_wo_sleep = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  mumDistNovelS * TestSpeaker + 
  timeVoiceFam * Group +
  nrSpeakersDaily + 
  (1 + TestSpeaker * Group | Subj) 

f_wo_nrSp = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  mumDistNovelS * TestSpeaker + 
  timeVoiceFam * Group +
  sleepState + 
  (1 + TestSpeaker * Group | Subj) 

f_wo_timeV = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  mumDistNovelS * TestSpeaker + 
  nrSpeakersDaily + 
  sleepState + 
  (1 + TestSpeaker * Group | Subj) 

f_wo_distNov = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  timeVoiceFam * Group +
  nrSpeakersDaily + 
  sleepState + 
  (1 + TestSpeaker * Group | Subj) 

f_wo_distTr = MMR ~ 1 + TestSpeaker * Group + 
  mumDistNovelS * TestSpeaker + 
  timeVoiceFam * Group +
  nrSpeakersDaily + 
  sleepState + 
  (1 + TestSpeaker * Group | Subj) 

f_wo_distBoth = MMR ~ 1 + TestSpeaker * Group + 
  timeVoiceFam * Group +
  nrSpeakersDaily + 
  sleepState + 
  (1 + TestSpeaker * Group | Subj) 

f_w_distBoth = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  mumDistNovelS * TestSpeaker + 
  (1 + TestSpeaker * Group | Subj) 

f_w_distTr = MMR ~ 1 + TestSpeaker * Group + 
  mumDistTrainS * TestSpeaker + 
  (1 + TestSpeaker * Group | Subj) 

f_w_distNov = MMR ~ 1 + TestSpeaker * Group + 
  mumDistNovelS * TestSpeaker + 
  (1 + TestSpeaker * Group | Subj) 

f_w_timeV = MMR ~ 1 + TestSpeaker * Group + 
  timeVoiceFam * Group +
  (1 + TestSpeaker * Group | Subj) 

f_w_nrSp = MMR ~ 1 + TestSpeaker * Group + 
  nrSpeakersDaily + 
  (1 + TestSpeaker * Group | Subj) 

f_w_sleep = MMR ~ 1 + TestSpeaker * Group + 
  sleepState + 
  (1 + TestSpeaker * Group | Subj) 

f_none = MMR ~ 1 + TestSpeaker * Group + 
  (1 + TestSpeaker * Group | Subj) 

formulas = c(f_all,
             f_wo_sleep,
             f_wo_nrSp,
             f_wo_timeV,
             f_wo_distNov,
             f_wo_distTr,
             f_wo_distBoth,
             f_w_distBoth,
             f_w_distTr,
             f_w_distNov,
             f_w_timeV,
             f_w_nrSp,
             f_w_sleep,
             f_none)

formulas_names = c("f_all",
                   "f_wo_sleep",
                   "f_wo_nrSp",
                   "f_wo_timeV",
                   'f_wo_distNov',
                   "f_wo_distTr",
                   'f_wo_distBoth',
                   "f_w_distBoth",
                   "f_w_distTr",
                   "f_w_distNov",
                   "f_w_timeV",
                   "f_w_nrSp",
                   "f_w_sleep",
                   "f_none")

# sampling --------------------------------------------------------------------
### Model ACQUISITION
for (i in 1:length(formulas)){
  modelMMR <-
    brm(formulas[[i]],  
        data = dat,
        family = gaussian(), 
        prior = priors_acq_low,
        init = "random",
        control = list(
          adapt_delta = .99, 
          max_treedepth = 15
        ),
        chains = num_chains,
        iter = num_iter,
        warmup = num_warmup,
        thin = num_thin,
        algorithm = "sampling", 
        cores = num_chains, 
        seed = project_seed,
        file = here("data", "model_output", paste("samples_MMR_acq_", formulas_names[i] ,".rds", sep = "")),
        file_refit = "on_change",
        save_pars = save_pars(all = TRUE)
    )
  name = paste("modelMMR_acq_", formulas_names[i], sep = "") 
  assign(name, modelMMR)
}

### Model RECOGNITION
for (i in 1:length(formulas)){
  modelMMR <-
    brm(formulas[[i]],  
        data = dat_rec,
        family = gaussian(), 
        prior = priors_rec_low,
        init = "random",
        control = list(
          adapt_delta = .99, 
          max_treedepth = 15
        ),
        chains = num_chains,
        iter = num_iter,
        warmup = num_warmup,
        thin = num_thin,
        algorithm = "sampling", 
        cores = num_chains, 
        seed = project_seed,
        file = here("data", "model_output", paste("samples_MMR_rec_", formulas_names[i] ,".rds", sep = "")),
        file_refit = "on_change",
        save_pars = save_pars(all = TRUE)
    )
  name = paste("modelMMR_rec_", formulas_names[i], sep = "") 
  assign(name, modelMMR)
}

# Model comparisons --------------------------------------------------------------------

#### ACQUISITION

### Set criterions
modelMMR_acq_f_all = add_criterion(modelMMR_acq_f_all, "loo",moment_match = TRUE)
modelMMR_acq_f_wo_sleep = add_criterion(modelMMR_acq_f_wo_sleep, "loo", moment_match = TRUE)
modelMMR_acq_f_wo_nrSp = add_criterion(modelMMR_acq_f_wo_nrSp, "loo",moment_match = TRUE)
modelMMR_acq_f_wo_timeV = add_criterion(modelMMR_acq_f_wo_timeV, "loo",moment_match = TRUE)
modelMMR_acq_f_wo_distNov = add_criterion(modelMMR_acq_f_wo_distNov, "loo",moment_match = TRUE)
modelMMR_acq_f_wo_distTr = add_criterion(modelMMR_acq_f_wo_distTr, "loo",moment_match = TRUE)
modelMMR_acq_f_wo_distBoth = add_criterion(modelMMR_acq_f_wo_distBoth,"loo",moment_match = TRUE)
modelMMR_acq_f_w_distBoth = add_criterion(modelMMR_acq_f_w_distBoth, "loo",moment_match = TRUE)
modelMMR_acq_f_w_distTr = add_criterion(modelMMR_acq_f_w_distTr, "loo",moment_match = TRUE)
modelMMR_acq_f_w_distNov = add_criterion(modelMMR_acq_f_w_distNov, "loo",moment_match = TRUE)
modelMMR_acq_f_w_timeV = add_criterion(modelMMR_acq_f_w_timeV, "loo",moment_match = TRUE)
modelMMR_acq_f_w_nrSp = add_criterion(modelMMR_acq_f_w_nrSp, "loo",moment_match = TRUE)
modelMMR_acq_f_w_sleep = add_criterion(modelMMR_acq_f_w_sleep, "loo",moment_match = TRUE)
modelMMR_acq_f_none = add_criterion(modelMMR_acq_f_none, "loo",,moment_match = TRUE)

### Leave out
comp = loo_compare(modelMMR_acq_f_all, 
            modelMMR_acq_f_wo_sleep,
            modelMMR_acq_f_wo_nrSp,
            modelMMR_acq_f_wo_timeV,
            modelMMR_acq_f_wo_distNov,
            modelMMR_acq_f_wo_distTr,
            modelMMR_acq_f_wo_distBoth,
            criterion = "loo")
print(comp, simplify = FALSE, digits = 3)
## W/o sleep
loo_compare(modelMMR_acq_f_all, modelMMR_acq_f_wo_sleep, criterion = "loo")
## W/o NrSpeakersDaily
loo_compare(modelMMR_acq_f_all, modelMMR_acq_f_wo_nrSp, criterion = "loo")
## W/o TimeVoiceFame
loo_compare(modelMMR_acq_f_all, modelMMR_acq_f_wo_timeV, criterion = "loo")
## W/o mumDistNov
loo_compare(modelMMR_acq_f_all, modelMMR_acq_f_wo_distNov, criterion = "loo")
## W/o mumDistTrain
loo_compare(modelMMR_acq_f_all, modelMMR_acq_f_wo_distTr, criterion = "loo")
## W/o mumDistNov & mumDistTrain
loo_compare(modelMMR_acq_f_all, modelMMR_acq_f_wo_distBoth, criterion = "loo")

### Add in
comp = loo_compare(modelMMR_acq_f_none, 
            modelMMR_acq_f_w_sleep,
            modelMMR_acq_f_w_nrSp,
            modelMMR_acq_f_w_timeV,
            modelMMR_acq_f_w_distNov,
            modelMMR_acq_f_w_distTr,
            modelMMR_acq_f_w_distBoth,
            criterion = "loo")
print(comp, simplify = FALSE, digits = 3)
## W sleep
loo_compare(modelMMR_acq_f_none, modelMMR_acq_f_w_sleep, criterion = "loo")
## W NrSpeakersDaily
loo_compare(modelMMR_acq_f_none, modelMMR_acq_f_w_nrSp, criterion = "loo")
## W TimeVoiceFame
loo_compare(modelMMR_acq_f_none, modelMMR_acq_f_w_timeV, criterion = "loo")
## W mumDistNov
loo_compare(modelMMR_acq_f_none, modelMMR_acq_f_w_distNov, criterion = "loo")
## W mumDistTrain
loo_compare(modelMMR_acq_f_none, modelMMR_acq_f_w_distTr, criterion = "loo")
## W mumDistNov & mumDistTrain
loo_compare(modelMMR_acq_f_none, modelMMR_acq_f_w_distBoth, criterion = "loo")


# RECOGNITION
### Set criterions
modelMMR_rec_f_all = add_criterion(modelMMR_rec_f_all, "loo",moment_match = TRUE)
modelMMR_rec_f_wo_sleep = add_criterion(modelMMR_rec_f_wo_sleep, "loo", moment_match = TRUE)
modelMMR_rec_f_wo_nrSp = add_criterion(modelMMR_rec_f_wo_nrSp, "loo",moment_match = TRUE)
modelMMR_rec_f_wo_timeV = add_criterion(modelMMR_rec_f_wo_timeV, "loo",moment_match = TRUE)
modelMMR_rec_f_wo_distNov = add_criterion(modelMMR_rec_f_wo_distNov, "loo",moment_match = TRUE)
modelMMR_rec_f_wo_distTr = add_criterion(modelMMR_rec_f_wo_distTr, "loo",moment_match = TRUE)
modelMMR_rec_f_wo_distBoth = add_criterion(modelMMR_rec_f_wo_distBoth,"loo",moment_match = TRUE)
modelMMR_rec_f_w_distBoth = add_criterion(modelMMR_rec_f_w_distBoth, "loo",moment_match = TRUE)
modelMMR_rec_f_w_distTr = add_criterion(modelMMR_rec_f_w_distTr, "loo",moment_match = TRUE)
modelMMR_rec_f_w_distNov = add_criterion(modelMMR_rec_f_w_distNov, "loo",moment_match = TRUE)
modelMMR_rec_f_w_timeV = add_criterion(modelMMR_rec_f_w_timeV, "loo",moment_match = TRUE)
modelMMR_rec_f_w_nrSp = add_criterion(modelMMR_rec_f_w_nrSp, "loo",moment_match = TRUE)
modelMMR_rec_f_w_sleep = add_criterion(modelMMR_rec_f_w_sleep, "loo",moment_match = TRUE)
modelMMR_rec_f_none = add_criterion(modelMMR_rec_f_none, "loo",,moment_match = TRUE))

### Leave out
comp = loo_compare(modelMMR_rec_f_all, 
                   modelMMR_rec_f_wo_sleep,
                   modelMMR_rec_f_wo_nrSp,
                   modelMMR_rec_f_wo_timeV,
                   modelMMR_rec_f_wo_distNov,
                   modelMMR_rec_f_wo_distTr,
                   modelMMR_rec_f_wo_distBoth,
                   criterion = "loo")
print(comp, simplify = FALSE, digits = 3)
## W/o sleep
loo_compare(modelMMR_rec_f_all, modelMMR_rec_f_wo_sleep, criterion = "loo")
## W/o NrSpeakersDaily
loo_compare(modelMMR_rec_f_all, modelMMR_rec_f_wo_nrSp, criterion = "loo")
## W/o TimeVoiceFame
loo_compare(modelMMR_rec_f_all, modelMMR_rec_f_wo_timeV, criterion = "loo")
## W/o mumDistNov
loo_compare(modelMMR_rec_f_all, modelMMR_rec_f_wo_distNov, criterion = "loo")
## W/o mumDistTrain
loo_compare(modelMMR_rec_f_all, modelMMR_rec_f_wo_distTr, criterion = "loo")
## W/o mumDistNov & mumDistTrain
loo_compare(modelMMR_rec_f_all, modelMMR_rec_f_wo_distBoth, criterion = "loo")

### Add in
comp = loo_compare(modelMMR_rec_f_none, 
                   modelMMR_rec_f_w_sleep,
                   modelMMR_rec_f_w_nrSp,
                   modelMMR_rec_f_w_timeV,
                   modelMMR_rec_f_w_distNov,
                   modelMMR_rec_f_w_distTr,
                   modelMMR_rec_f_w_distBoth,
                   criterion = "loo")
print(comp, simplify = FALSE, digits = 3)
## W sleep
loo_compare(modelMMR_rec_f_none, modelMMR_rec_f_w_sleep, criterion = "loo")
## W NrSpeakersDaily
loo_compare(modelMMR_rec_f_none, modelMMR_rec_f_w_nrSp, criterion = "loo")
## W TimeVoiceFame
loo_compare(modelMMR_rec_f_none, modelMMR_rec_f_w_timeV, criterion = "loo")
## W mumDistNov
loo_compare(modelMMR_rec_f_none, modelMMR_rec_f_w_distNov, criterion = "loo")
## W mumDistTrain
loo_compare(modelMMR_rec_f_none, modelMMR_rec_f_w_distTr, criterion = "loo")
## W mumDistNov & mumDistTrain
loo_compare(modelMMR_rec_f_none, modelMMR_rec_f_w_distBoth, criterion = "loo")


# END  --------------------------------------------------------------------







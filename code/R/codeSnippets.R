## Posterior predictive check:
pp_check(fit_press, ndraws = 100, type = "dens_overlay")
## Plot posterior predictive distribution of statistical summaries:
pp_check(fit_press, ndraws = 100, type = "stat", stat = "mean")
## Plot prior predictive distribution of statistical summaries:
pp_check(fit_press, ndraws = 100, type = "stat", stat = "mean",
         prefix = "ppd")


# for only the density plots, without the caterpillars
mcmc_dens(fit_N400_v, pars = variables(fit_N400_v)[1:5])








### FROM HERE DOWNWARDS, THIS CAN GO TO 01_parameter_estimation.R
# Contrast coding ---------------------------------

# Here's an example of how you can estimate the effect of speaker 1 compared to speaker 4:
# 
# ```R library(emmeans) emm <- emmeans(model, ~ test_speaker) contrast(emm, method = "pairwise", ref = "4") ```
# 
# This will provide you with the estimated differences between speaker 1 and speaker 4, along with their standard errors and p-values.
# df$group <- factor(df$group, contrasts = contr.sum)
# df$test_speaker <- factor(df$test_speaker, contrasts = contr.sum)
# 


# For the Acquisiton RQ, we want the following comparisons
# 1. For test_speaker = Speaker1, the mmr is different for group=fam vs group = unfam. 
# 2. For test_speaker = Speaker2, the mmr is different for group=fam vs group = unfam. 
# 3. For both groups together: mmr is larger for test_speaker = S1 as for test_speaker = S2

# For our hypotheses, we can use a nested model instead of a complicated contrast matrix. This gives us the coefficients we are interested in
contrasts(dat$Group) <- c(-0.5, +0.5)
contrasts(dat$TestSpeaker) <- c(-0.5, +0.5)
fit_Nest <- brm(MMR ~ 1 + TestSpeaker / Group,
                data = dat,
                family = gaussian(),
                prior = priors
)

summary(fit_Nest)

# Our output:
# Intercept = the intercept term represents the estimated mean response when both the test_speaker and group variables are at their reference levels. In this case, the reference levels are Group=2 and Testpeaker=2
# TestSpeaker1 = comparison 3:  The estimated coefficient represents the difference in the average mmr between test_speaker1 and test_speaker2, regardless of the group
# TestSpeaker1:Group1 = Comparison 1. The estimated coefficient represents the difference in the average mmr between group=fam and group=unfam when test_speaker is Speaker1.
# TestSpeaker2:Group1 = Comparison 2. The estimated coefficient represents the difference in the average mmr between group=fam and group=unfam when test_speaker is Speaker2

# So what can we interpret from this data:
# TestSpeaker1 = -5.74 indicated that the MMR is lower for Speaker1 as compared to Speaker2 regardless of group
# For Speaker=1, MMR is higher for infants with a training with a familiar voice
# For Speaker=2, MMR is lower for infants with a training with a familiar voice

plot(fit_Nest)
#The regression coefficients estimate the grand mean, the difference for the main effect of TestSpeaker and the two differences (for Group; 
# i.e., simple main effects) within the two levels (TestSpeaker 1 and TestSpeaker 4) of TestSpeaker



num_chains <- 4 # number of chains = number of processor cores
num_iter <- 4000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain


fit_Nest2 <- brm(MMR ~ 1 + TestSpeaker / Group + 
                   mumDistTrainS * TestSpeaker + 
                   mumDistNovelS * TestSpeaker + 
                   timeVoiceFam * TestSpeaker * Group +
                   nrSpeakersDaily * TestSpeaker * Group + 
                   (1 | Subj) + (1 | TestSpeaker/Group),
                 chains = num_chains,
                 iter = num_iter,
                 warmup = num_warmup,
                 thin = num_thin,
                 control = list(
                   adapt_delta = .99, 
                   max_treedepth = 15
                   # These are the parameters of the algorithms. Here A changed the default values (to make more precise but less fast).
                   # Check which ones are possible!
                 ),                 data = dat,
                 family = gaussian(),
                 prior = priors)


pairs(fit_Nest2)
plot(fit_Nest2)
summary(fit_Nest2)

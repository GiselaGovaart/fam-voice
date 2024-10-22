

# Simulate  data --------------------------------------------------------------------
design <-
  fixed.factor("Group", levels=c("fam", "unfam")) +
  fixed.factor("TestSpeaker", levels=c("1", "2", "3")) +
  random.factor("Subj", groups="Group", instances=6)

dat_test <- design.codes(design)

dat_test$TestSpeaker_n <- NA
for(i in 1:nrow(dat_test)){
  if(dat_test$TestSpeaker[i]=="1"){
    dat_test$TestSpeaker_n[i] = 0.1
  }else if(dat_test$TestSpeaker[i]=="2"){
    dat_test$TestSpeaker_n[i] = 0.4
  }else{
    dat_test$TestSpeaker_n[i] = -.5
  }
}

dat_test$Group_n <- ifelse(dat_test$Group=="fam", +0.5, -0.5)

# simulate data
dat_test$MMR <- 6 + 5*dat_test$TestSpeaker_n + rnorm(nrow(dat_test),0,22) # 1st part: the mean of the MMR for all groups together, 2nd part: making sure the groups are different, 3rd part: adding noise: the SD of the MMR is 14

dat_test$timeVoiceFam = NA
dat_test$nrSpeakersDaily = NA
dat_test$sleepState = NA
dat_test$sleepState = rep(sample(c("awake", "activesleep", "quietsleep"), nrow(dat_test)/3, replace = TRUE), each=3)

dat_test$timeVoiceFam = rep(round(rnorm(nrow(dat_test)/3,21,2)), each=3)
dat_test$nrSpeakersDaily = rep(round(rnorm(nrow(dat_test)/3,4,1)), each=3)
dat_test = subset(dat_test, select = -c(TestSpeaker_n,Group_n) ) # remove these "contrast coding columns" because we only use them for data simulation

dat_test$sleepState = as.factor(dat_test$sleepState)

rm(design,i)

# Save output reproducibily:
dput(dat_test)


dput(dat_rec)




## START -------

# set seed
project_seed = 20
set.seed(project_seed) 

# Make df, with 12 subjects, with:
# Group (between subj factor): levels "fam" and "unfam"
# TestSpeaker (within): levels 1,2,3
# sleepState (between): levels awake, activesleep, quietsleep
# MMR: dependent variable
df = structure(list(Subj = structure(c(1L, 1L, 1L, 2L, 2L, 2L, 3L, 
                                       3L, 3L, 4L, 4L, 4L, 5L, 5L, 5L, 6L, 6L, 6L, 7L, 7L, 7L, 8L, 8L, 
                                       8L, 9L, 9L, 9L, 10L, 10L, 10L, 11L, 11L, 11L, 12L, 12L, 12L), 
                                     levels = c("Subj01","Subj02", "Subj03", "Subj04", "Subj05", "Subj06", 
                                                "Subj07", "Subj08","Subj09", "Subj10", "Subj11", "Subj12"), 
                                     class = "factor"),
                    Group = structure(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
                                        1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
                                        2L, 2L, 2L), levels = c("fam", "unfam"), class = "factor"), 
                    TestSpeaker = structure(c(1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 
                                              3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L, 
                                              1L, 2L, 3L), levels = c("1", "2", "3"), class = "factor"),
                    MMR = c(38.3193739833394,-26.3345733319488, -36.5391489690257, 17.6727210461579, 13.0723969801114, 
                            -4.24116674572545, 21.2481968372323, 11.4709975141478, 1.82856457361663, 
                            43.7294164718069, 20.3131479540544, 0.785675781481198, -2.15902787287105, 
                            -25.4903371611785, 61.873025266565, 9.06733331354276, -18.7574284113092, 
                            6.33216574768327, -34.9097027199614, -3.96327639212982, 15.9747552016853, 
                            -38.801070417319, -6.46518128748102, -22.630432474398, 21.9291933267653, 
                            24.4946719999554, -31.2847387815119, -8.04032285881707, 14.2321054924562, 
                            8.80183458992482, 18.9550435474235, 33.2621031208136, -11.4198082197363, 
                            -14.7150081652997, 29.2510483128696, -31.1494998323233), 
                    sleepState = structure(c(2L,2L, 2L, 3L, 3L, 3L, 2L, 2L, 2L, 2L, 2L, 2L, 3L, 3L, 3L, 1L, 1L, 
                                             1L, 1L, 1L, 1L, 1L, 1L, 1L, 3L, 3L, 3L, 1L, 1L, 1L, 2L, 2L, 2L, 
                                             1L, 1L, 1L), levels = c("activesleep", "awake", "quietsleep"), class = "factor")),
               row.names = c(NA,-36L), class = c("tbl_df", "tbl", "data.frame"))

model = brm(MMR ~ 1 + TestSpeaker * Group + 
        sleepState + 
        (1 + TestSpeaker * Group | Subj),
      data = df,
      family = gaussian(), 
      prior = c(set_prior("normal(5.97, 23.34)",  
                          class = "Intercept"),
                set_prior("normal(0, 23.34)",  
                          class = "b"),
                set_prior("normal(0, 23.34)",  
                          class = "sigma")),
      init = "random",
      control = list(
        adapt_delta = .99, 
        max_treedepth = 15
      ),
      chains = 4,
      iter = 4000,
      warmup = 2000,
      thin = 1,
      algorithm = "sampling", 
      cores = 4, 
      seed = project_seed,
      save_pars = save_pars(all = TRUE)
  )




# 
# Questions:
#   - I don't understand why the contrasts for contr.equalprior and contr.equalprior_pairs are different
#  - 
# 
# 
# 
# 
# 
#                     

df=dat_rec
df = df[1:30,]

m1 = brm(MMR ~ 1 + TestSpeaker * Group + 
              sleepState + 
              (1 + TestSpeaker * Group | Subj),
            data = df,
            family = gaussian(), 
            prior = c(set_prior("normal(5.97, 23.34)",  
                                class = "Intercept"),
                      set_prior("normal(0, 23.34)",  
                                class = "b"),
                      set_prior("normal(0, 23.34)",  
                                class = "sigma")),
            init = "random",
            control = list(
              adapt_delta = .99, 
              max_treedepth = 15
            ),
            chains = 4,
            iter = 4000,
            warmup = 2000,
            thin = 1,
            algorithm = "sampling", 
            cores = 4, 
            seed = project_seed,
            save_pars = save_pars(all = TRUE)
)

summary(m1)


# setup custom contrasts:
unfam2 = c(0,0,0,1,0,0)
fam1 = c(1,0,0,0,0,0)
unfam3 = c(0,0,0,0,0,1)
unfam1 = c(0,1,0,0,0,0)

custom_contrasts_group_speaker <- list(
  list("unfam2-fam1" = unfam2 - fam1),
  list("unfam2-unfam3" = unfam2 - unfam3),
  list("unfam1-unfam2" = unfam1 - unfam2)
) 

custom_contrasts_sleep <- list(
  list("awake - activesleep and quietsleep" = c(1, -1/2, -1/2)),
  list("quietsleep - awake and activesleep" = c(-1/2, -1/2, 1)),
  list("quietsleep vs activesleep" =c(0, 1, -1))
)

options(contrasts = c("contr.equalprior", "contr.poly"))
MMR_m_prior <- unupdate(modelMMR_rec) # sample priors from model
MMR_m_prior_pairwise <-
  MMR_m_prior %>%
  emmeans(~ Group:TestSpeaker) 

contrast(MMR_m_prior_pairwise, method = custom_contrasts_group_speaker)
est = contrast(MMR_m_prior_pairwise, method = custom_contrasts_group_speaker)

point_estimate(est, centr = "mean", disp = TRUE)






















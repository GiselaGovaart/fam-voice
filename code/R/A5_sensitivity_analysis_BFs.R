# sensitivity analysis for BF

# code adapted from Nicenboim, Bruno, Daniel Schad, and Shravan Vasishth. "An introduction to Bayesian data analysis for cognitive science.
# https://vasishth.github.io/bayescogsci/book/

### load packages ------------------------
library(brms)

### set values ----------------------------
num_chains <- 4 # number of chains = number of processor cores
num_iter <- 4000 # number of samples per chain
num_warmup <- num_iter / 2 # number of warm-up samples per chain
num_thin <- 1 # thinning: extract one out of x samples per chain



### Contrast 1:  unfam2-fam1 -------------------------

# prior_sd <- c(1, 1.5, 2, 2.5, 5, 8, 10, 20, 40, 50, 100)
prior_sd <- c(1, 20)
BF <- c()
for (i in 1:length(prior_sd)) {
  psd <- prior_sd[i]
  # for each prior we fit the model
  fit <-  brm(MMR ~ 1 + TestSpeaker * Group + 
                mumDist  + 
                nrSpeakersDaily +
                sleepState +
                age +
                (1 + TestSpeaker  | Subj),
              data = dat_rec,
              family = gaussian(), 
              prior =
                c(
                  prior(normal(3.5, 20), class = Intercept),
                  set_prior(paste0("normal(0,", psd, ")"), class = "b"),
                  set_prior("normal(0, 20)", class = "sigma")
                ),
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
              cores = num_chains, # you want to use one core per chain, so keep same value as num_chains here
              seed = project_seed,
              save_pars = save_pars(all = TRUE)
      )
  # compute BF
  m_prior <-
    fit %>%
    emmeans(~ Group:TestSpeaker)
  m_prior = contrast(m_prior, method = list("unfam2-fam1" = unfam2 - fam1))
  
  m_post <-
    fit %>%
    emmeans(~ TestSpeaker:Group) 
  m_post = contrast(m_post, method = list("unfam2-fam1" = unfam2 - fam1))
  BF_current = bf_parameters(m_post, prior = m_prior) 
  BF_current = as.numeric(BF_current)
  BF_current = BF_current
  # we store the Bayes factor
  BF <- c(BF, BF_current)
}

res <- data.frame(prior_sd, BF, logBF=log10(BF))
save(res, file="05_modelcomparison.rda")
#load("05_modelcomparison.rda")

breaks <- c(1 / 100, 1 / 50, 1 / 20, 1 / 10, 1 / 3, 1, 3, 5, 10, 20, 50, 100)
ggplot(res, aes(x = prior_sd, y = BF)) +
  geom_point(size = 2) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_x_continuous("Normal prior width (SD)\n") +
  scale_y_log10("BF10", breaks = breaks, labels = MASS::fractions(breaks)) +
  coord_cartesian(ylim = c(1 / 100, 100)) +
  annotate("text", x = 30 * 2, y = 30, label = "Evidence in favor of H1", size = 5) +
  annotate("text", x = 30 * 2, y = 1 / 30, label = "Evidence in favor of H0", size = 5) +
  theme(axis.text.y = element_text(size = 8)) +
  ggtitle("Bayes factors")
# We plot on a logscale, such that the BFs for the M1 and M0 are symmetrical. 
# We will most likely find something like:
# What we see is that if we assume a very low effect size (SD is low), 
# we have support for M1, but if we assume a very big effect size (SD is very high) we find support for the M0.
# This is always the case --> if you assume a very big effect size (a very broad prior) we will per definition
# find support for the H0.
# So we just need to describe what we see in this plot to make sure that our BF is not solely dependent on our priors




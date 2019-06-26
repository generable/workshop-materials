#!/usr/local/bin/R

library(rstan)
options(mc.cores = parallel::detectCores())

## generate data
fit_sim <- stan("sim_data.stan", algorithm = "Fixed_param", seed = 06182019)

x <- extract(fit_sim)[[1]][1,]
stan_data = list(x = x, N = length(x))

## export data
saveRDS(stan_data, "data.rds")
stan_rdump(ls(stan_data), "data.R", envir = list2env(stan_data))


## set up all the models
fit_1 <- stan("poisson_1.stan", data = stan_data)
fit_2 <- stan("poisson_2.stan", data = stan_data)
fit_3 <- stan("poisson_3.stan", data = stan_data)

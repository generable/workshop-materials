#!/usr/local/bin/R

library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)
options(width = 90)

################################################################################

posterior_predictive_plot <- function(fit, stan_data) {
    par(mfrow=c(2, 1))

    x = stan_data$x
    x_ppc = extract(fit)$x_ppc
    
    hi = max(x, x_ppc)
    hist(x, xlim=c(0, hi), main = "data", 
         freq = FALSE, breaks = max(x) + 1)
    hist(x_ppc, xlim=c(0, hi), main = "posterior predictive",
         freq = FALSE, breaks = max(x_ppc) + 1)
}

################################################################################

## read data
stan_data = readRDS("data.rds")

## look at data
str(stan_data)
head(stan_data$x)
summary(stan_data$x)

## plot count data
par(mfrow=c(1, 1))
hist(stan_data$x, main = "data", freq = FALSE, breaks = 9)


################################################################################

## open model 1: poisson_1.stan

fit1 <- stan("poisson_1.stan", data = stan_data)

## check diagnostics

print(fit1)

stan_dens(fit1, "lambda")

stan_hist(fit1, "lambda")

stan_trace(fit1, "lambda")

mean(stan_data$x)
lambda = extract(fit1, "lambda")$lambda
mean(lambda)


## runs ok, but is it a good model?
## look at posterior predictive
posterior_predictive_plot(fit1, stan_data)


################################################################################

## open model 2: poisson_2.stan

fit2 <- stan("poisson_2.stan", data = stan_data)

## check diagnostics

print(fit2)
stan_hist(fit2, c("lambda", "theta"))

## closer? what's off?
## look at posterior predictive
posterior_predictive_plot(fit2, stan_data)


################################################################################

## open model 3: poisson_3.stan

fit3 <- stan("poisson_3.stan", data = stan_data)

## check diagnostics

print(fit3)
stan_hist(fit3, c("lambda", "theta"))

## look at posterior predictive
posterior_predictive_plot(fit3, stan_data)

stan_hist(fit3, c("lambda", "theta"))







################################################################################


## simulated parameters:
##   lambda = 5.5
##   theta = 0.3
print(fit3)

################################################################################

## repeat whole thing with only 40 data points.


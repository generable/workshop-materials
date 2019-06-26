data {
  int N;
  int x[N];
}
transformed data {
  int upper_bound;
  upper_bound = max(x);
}
parameters {
  real<lower=0, upper=1> theta;
  real<lower=0> lambda;
}
model {
  lambda ~ normal(0, 1);
  
  for (n in 1:N) {
    real log_trunc_poisson;
    log_trunc_poisson = poisson_lpmf(x[n] | lambda) - poisson_lcdf(upper_bound | lambda);
    if (x[n] == 0)
      target += log_sum_exp(log(theta), log1m(theta) + log_trunc_poisson);
    else
      target += log1m(theta) + log_trunc_poisson;
  }
}

generated quantities {
  int b = bernoulli_rng(theta);
  int x_ppc;
  if (b) {
    x_ppc = 0;
  } else {
    x_ppc = upper_bound + 1;
    while (x_ppc > upper_bound)
      x_ppc = poisson_rng(lambda);
  }
}

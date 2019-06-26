data {
  int N;
  int x[N];
}
parameters {
  real<lower=0> lambda;
  real<lower=0, upper=1> theta;
}
model {
  lambda ~ normal(0, 1);

  for (n in 1:N) {
    if (x[n] == 0) {
      target += log_sum_exp(log(theta), log1m(theta) + poisson_lpmf(x[n] | lambda));
      // target += log( theta + (1 - theta) * exp(poisson_lpmf(x[n], lambda)) )
    } else {
      target += log1m(theta) + poisson_lpmf(x[n] | lambda);
    }
  }
}
generated quantities {
  int b = bernoulli_rng(theta);
  int x_ppc;
  if (b)
    x_ppc = 0;
  else
    x_ppc = poisson_rng(lambda);
}

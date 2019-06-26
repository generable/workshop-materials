data {
  int N;
  int x[N];
}
parameters {
  real<lower=0> lambda;
}
model {
  lambda ~ normal(0, 1);
  x ~ poisson(lambda);
}
generated quantities {
  int x_ppc;
  x_ppc = poisson_rng(lambda);
}

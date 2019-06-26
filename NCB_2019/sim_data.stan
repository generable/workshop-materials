transformed data {
  int N = 1000;
  real lambda = 5.5;
  real theta = 0.3;
  int x_max = 8;
}
model {
}
generated quantities {
  int x[N];
  
  for (n in 1:N) {
    x[n] = x_max + 1;
    if (bernoulli_rng(theta)) {
      x[n] = 0;
    } else {
      while (x[n] > x_max)
        x[n] = poisson_rng(lambda);
    }
  }
}

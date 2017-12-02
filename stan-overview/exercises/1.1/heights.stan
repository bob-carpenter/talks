data {
  int num_heights;
  real heights[num_heights];
}

parameters {
  real height_mean;
  real<lower=0> height_variability;
}

model {
  heights ~ normal(height_mean, height_stdev);
}

generated quantities {
  int N = 25;
  real height_ppc[N];
  for (n in 1:N)
    height_ppc[n] ~ normal_rng(height_mean, height_stdev);
}

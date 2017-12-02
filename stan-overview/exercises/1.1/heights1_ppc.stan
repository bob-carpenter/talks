data {
  int num_people;
  real heights[num_people];
}

parameters {
  real height_mean;
  real<lower=0> height_stdev;
}

model {
  heights ~ normal(height_mean, height_stdev);
}

generated quantities {
  real height_ppc[num_people];
  for (n in 1:num_people)
    height_ppc[n] = normal_rng(height_mean, height_stdev);
}

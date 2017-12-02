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
  height_mean ~ normal(183, 120);
  height_stdev ~ normal(0, 20);
}

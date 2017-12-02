data {
  int num_people;
  real heights[num_people];
}
parameters {
  real height_location;
  real<lower=0> height_stdev;
}
model {
  heights ~ normal(height_location, height_stdev);
  height_location ~ normal(183, 120);
  height_stdev ~ normal(0, 20);
}

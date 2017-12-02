data {
  int num_people;
  real heights[num_people];
}
parameters {
  real height_location;
  real<lower=0> height_scale;
}
model {
  heights ~ normal(height_location, height_scale);
  height_location ~ normal(183, 120);
  height_scale ~ normal(0, 20);
}

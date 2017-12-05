data {
  int num_people;
  vector[num_people] weights;
  real heights[num_people];
}
transformed data {
  vector[num_people] std_weights =
      (weights - mean(weights)) / sd(weights);
}
parameters {
  real height_location_avg_weight;
  real weight_coeff;
  real<lower=0> height_scale;
}
model {
  heights ~ normal(height_location_avg_weight + weight_coeff * weights
                   , height_scale);
  height_location_avg_weight ~ normal(183, 120);
  height_scale ~ normal(0, 20);
  weight_coeff ~ normal(7, 10);
}

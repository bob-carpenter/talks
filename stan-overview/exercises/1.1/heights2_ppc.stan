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
  real height_mean_avg_weight;
  real weight_coeff;
  real<lower=0> height_stdev;
}

model {
  heights ~ normal(height_mean_avg_weight
                   + weight_coeff * weights
                   , height_stdev);
  height_mean_avg_weight ~ normal(183, 120);
  height_stdev ~ normal(0, 20);
  weight_coeff ~ normal(7, 10);
}

generated quantities {
  vector[num_people] hppc;
  for (n in 1:num_people)
    hppc[n] = normal_rng(height_mean_avg_weight
                         + weight_coeff * weights[n]
                         , height_stdev);
}

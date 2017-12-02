data {
  int num_people;
  vector[num_people] weights;
  vector[num_people] male;
  real heights[num_people];
}

transformed data {
  vector[num_people] std_weights =
      (weights - mean(weights)) / sd(weights);
}

parameters {
  real non_male_height_mean_avg_weight;
  real weight_coeff;
  real male_coeff;
  real<lower=0> height_stdev;
}

model {
  heights ~ normal(non_male_height_mean_avg_weight
                   + weight_coeff * weights
                   + male_coeff * male
                   , height_stdev);
  non_male_height_mean_avg_weight ~ normal(183, 120);
  height_stdev ~ normal(0, 20);
  weight_coeff ~ normal(7, 10);
  male_coeff ~ normal(10, 20);
}

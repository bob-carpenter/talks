// simulate one roll of a fair D6
transformed data {
  vector[6] theta = rep_vector(1.0 / 6.0, 6);
}
generated quantities {
  int roll_d6 = categorical_rng(theta);
}

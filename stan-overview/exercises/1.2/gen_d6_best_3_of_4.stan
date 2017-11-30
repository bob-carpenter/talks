// simulate best 3 out of 4 rolls of a fair D6
transformed data {
  int N = 4;
  vector[6] theta = rep_vector(1.0 / 6.0, 6);
}
generated quantities {
  int best3;
  int rolls[N];
  for (i in 1:N) {
    rolls[i] = categorical_rng(theta);
  }
  best3 = sum(rolls) - min(rolls);
}

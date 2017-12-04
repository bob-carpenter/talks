// simulate N rolls of a platonic solid with K faces, report total
data {
  int<lower=4,upper=20> K;
  int<lower=1> N;
}
transformed data {
  vector[K] theta = rep_vector(1.0 / (1.0 * K), K);
  // platonic solids restrict K to be in { 4, 6, 8, 12, 20 }
  if (! (K == 4 || K == 6 || K == 8 || K == 12 || K == 20 ))
    reject("K must be one of { 4, 6, 8, 12, 20 }, found K=", K);
  print("K: ", K, " theta: ", theta);
}
generated quantities {
  int total;
  // use local scope to do the work
  {
    int outcomes[N];
    for (i in 1:N) {
      outcomes[i] = categorical_rng(theta);
    }
    total = sum(outcomes);
  }
}

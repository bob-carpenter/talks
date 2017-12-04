data {
  int N;  // number of obs
  int N_sides;  // number of obs
  int<lower=1, upper=N_sides> obs[N];
}
parameters {
  simplex[N_sides] theta;
}
model {
  obs ~ categorical(theta);
}

data {
  int N;
  int K;
  matrix[N, K] X;
  real y[N];
}
parameters {
  real alpha;
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  y ~ normal(X * beta + alpha, sigma);
}

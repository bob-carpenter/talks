data {
  int<lower=0> N; int<lower=0> J;
  vector[N] y; vector[N] x;
  int county[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=0> sigma_a;
  vector[J] a;
  real mu_a;
  real beta;
}
model {
  mu_a ~ normal(0, 100);
  sigma ~ normal(0, 10);
  sigma_a ~ normal(0, 10);
  a ~ normal(mu_a, sigma_a);
  beta ~ normal(0, 10);
  y ~ normal(a[county] + beta * x, sigma);
}

data {
  int<lower=0> N; int<lower=0> J;
  vector[N] y; vector[N] x;
  int county[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=0> sigma_a; real<lower=0> sigma_b;
  vector[J] a; vector[J] b;
  real mu_a; real mu_b;
}
model {
  mu_a ~ normal(0, 100); mu_b ~ normal(0, 100);
  sigma ~ normal(0, 10);
  sigma_a ~ normal(0, 10); sigma_b ~ normal(0, 10);
  a ~ normal(mu_a, sigma_a); b ~ normal(mu_b, sigma_b);
  y ~ normal(a[county] + b[county] .* x, sigma);
}

data {
  int<lower=0> N;
  int<lower=0> J;
  vector[N] y;
  vector[N] x;
  int county[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=0> tau_a;
  real<lower=0> tau_b;
  real mu_a;
  real mu_b;

  vector[J] eta_a;
  vector[J] eta_b;
}
transformed parameters {
  vector[J] a = mu_a + tau_a * eta_a;
  vector[J] b = mu_b + tau_b * eta_b;
}

model {
  mu_a ~ normal(0, 100);
  eta_a ~ normal(0, 1);
  mu_b ~ normal(0, 100);
  eta_b ~ normal(0, 1);

  y ~ normal(a[county] + b[county] .* x, sigma);
}

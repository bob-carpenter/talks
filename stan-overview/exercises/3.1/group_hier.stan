data {
  int<lower=0> N;
  int<lower=0> J;
  vector[N] y;
  vector[N] x;
  vector[N] u;
  int county[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=0> sigma_a;
  real mu_a;
  vector[J] a;
  real floor_coeff;
  real u_coeff;
}
model {
  mu_a ~ normal(0, 100);
  sigma ~ normal(0, 5);
  sigma_a ~ normal(0, 20);
  a ~ normal(mu_a, sigma_a);
  u_coeff ~ normal(0, 2);
  floor_coeff ~ normal(0, 2);
  y ~ normal(a[county] + floor_coeff * x + u_coeff * u, sigma);
}
generated quantities {
  vector[N] yppc;
  for (i in 1:N)
    yppc[i] = normal_rng(a[county[i]] + floor_coeff * x[i] + u_coeff * u[i]
                         , sigma);
}

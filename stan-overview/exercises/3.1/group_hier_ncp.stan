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
  real mu_a; vector[J] a_std; real<lower=0> sigma_a;
  real floor_coeff;
  real u_coeff;
}
transformed parameters {
  vector[J] a = mu_a + sigma_a * a_std;
}
model {
  mu_a ~ normal(0, 5); sigma_a ~ normal(0, 10);
  a_std ~ normal(0, 1);
  sigma ~ normal(0, 5);
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

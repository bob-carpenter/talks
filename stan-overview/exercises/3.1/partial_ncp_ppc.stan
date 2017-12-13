data {
  int<lower=0> N; int<lower=0> J;
  vector[N] y; vector[N] x;
  int county[N];
}
parameters {
  real<lower=0> sigma;
  real<lower=0> sigma_a;
  real<lower=0> sigma_b;
  real mu_a; real mu_b;
  vector[J] b_std;
  vector[J] a;
}
transformed parameters {
  vector[J] b = mu_b + sigma_b * b_std;
}
model {
  mu_a ~ normal(0, 100); mu_b ~ normal(0, 100);
  sigma_b ~ normal(0, 20); b_std ~ normal(0, 1);
  sigma ~ normal(0, 5);
  sigma_a ~ normal(0, 20);
  a ~ normal(mu_a, sigma_a);
  y ~ normal(a[county] + b[county] .* x, sigma);
}
generated quantities {
  vector[N] yppc;
  for (i in 1:N)
    yppc[i] = normal_rng(a[county[i]] + b[county[i]] * x[i], sigma);
}

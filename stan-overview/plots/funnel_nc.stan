data {
  int<lower=0> N_groups;
  int<lower=0> N_obs;
  int<lower=0,upper=N_obs> y[N_groups]; 
}
parameters {
  real mu;
  real<lower=0> sigma;
  vector[N_groups] theta_std;
}
transformed parameters {
  vector[N_groups] theta = mu + sigma * theta_std;
}
model {
  mu ~ normal(0, 2);
  sigma ~ lognormal(0, 3);
  theta_std ~ normal(0, 1);
  y ~ binomial_logit(N_obs, theta);
}

data {
  int<lower=0> N;
  int<lower=0> N_trials;
  int<lower=0,upper=N_trials> y[N]; 
}
parameters {
  real mu;
  real<lower=0> sigma;
  vector[N] theta_std;
}
transformed parameters {
  vector[N] theta = mu + sigma * theta_std;
}
model {
  mu ~ normal(0, 2);
  sigma ~ lognormal(0, 3);
  theta_std ~ normal(0, 1);
  y ~ binomial_logit(N_trials, theta);
}

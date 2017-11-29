data {
  int<lower=0> N;
  int<lower=0> N_trials;
  int<lower=0,upper=N_trials> y[N]; 
}
parameters {
  real mu;
  real<lower=0> sigma;
  vector[N] theta;  // log odds success
}
model {
  mu ~ normal(0, 2);
  sigma ~ lognormal(0, 3);
  theta ~ normal(mu, sigma);
  y ~ binomial_logit(N_trials, theta);
}
generated quantities {
  vector[N] theta_std;
  for (i in 1:N) {
    theta_std[i] = ( theta[i] - mu ) / sigma;
  }
}

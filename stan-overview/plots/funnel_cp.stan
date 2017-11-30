data {
  int<lower=0> N_groups;
  int<lower=0> N_obs;  // observations/trials
  int<lower=0,upper=N_obs> y[N_groups]; 
}
parameters {
  real mu;
  real<lower=0> sigma;
  vector[N_groups] theta;  // log odds success
}
model {
  mu ~ normal(0, 2);
  sigma ~ lognormal(0, 3);
  theta ~ normal(mu, sigma);
  y ~ binomial_logit(N_obs, theta);
}
generated quantities {
  vector[N_groups] theta_std;
  for (i in 1:N_groups) {
    theta_std[i] = ( theta[i] - mu ) / sigma;
  }
}

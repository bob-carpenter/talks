data {
  real<lower=0> length, height; 
  int<lower=0> N;  vector<lower=0>[N] t_obs;
}
transformed data {
  real<lower=0> s = sqrt(length^2 + height^2);
  real<lower=0> h = height;
}
parameters {
  real<lower=0> g;      // gravity accel in m/s^2
  real<lower=0> sigma;  // measurement error
}
model {
  real log_t_true = 0.5 * (log(14) + 2 * log(s) - log(5) - log(g) - log(h));
  t_obs ~ lognormal(log_t_true, sigma);
  sigma ~ exponential(1);
  g ~ lognormal(log(10), 0.25);
}

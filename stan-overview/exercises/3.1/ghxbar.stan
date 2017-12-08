data {
  int<lower=0> N;
  int<lower=0> J;
  vector[N] y;
  vector[N] x;
  vector[N] u;
  int county[N];
}
transformed data{
  vector[N] avgx;
  {
    vector[J] county_avg = rep_vector(0, J);
    vector[J] num_houses_in_county = rep_vector(0, J);
    for (n in 1:N) {
      county_avg[county[n]] = county_avg[county[n]] + x[n];
      num_houses_in_county[county[n]] = num_houses_in_county[county[n]] + 1;
    }
    county_avg = county_avg ./ num_houses_in_county;
    avgx = county_avg[county];
  }
}
parameters {
  real<lower=0> sigma;
  real mu_a; vector[J] eta_a; real<lower=0> tau_a;
  real floor_coeff;
  real u_coeff;
  real avgx_coeff;
}
transformed parameters {
  vector[J] a = mu_a + tau_a * eta_a;
}
model {
  mu_a ~ normal(0, 5); tau_a ~ normal(0, 10);
  eta_a ~ normal(0, 1);
  sigma ~ normal(0, 5);
  u_coeff ~ normal(0, 2);
  floor_coeff ~ normal(0, 2);
  y ~ normal(a[county] + floor_coeff * x + u_coeff * u
             + avgx_coeff * avgx, sigma);
}
generated quantities {
  vector[N] yppc;
  for (i in 1:N)
    yppc[i] = normal_rng(a[county[i]] + floor_coeff * x[i] + u_coeff * u[i]
                         + avgx_coeff * avgx[county[i]], sigma);
}

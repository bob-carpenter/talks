data {
  int<lower=0> N;
  int<lower=1,upper=85> county[N];
  vector[N] x;
  vector[N] y;
}
parameters {
  vector[85] a;
  real beta;
  real<lower=0,upper=100> sigma;
}
model {
  y ~ normal(beta * x + a[county], sigma);
  //for (i in 1:N)
  //  y[i] ~ normal(beta * x[i] + a[county[i]], sigma);
}

functions {
  real my_normal_lpdf(real y, real mu, real sigma) {
    return - 0.5 * log(2 * pi())
           - 2 * log(sigma)
           - 0.5 * ((y - mu) / sigma)^2;
  }
}
parameters {
  real y;
}
model {
  y ~ my_normal(1.5, 3.2);
}

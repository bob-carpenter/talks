library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

y = scan("y.txt")
X = read.csv("X.csv")
model = stan_model("../model.stan")
fit = sampling(model, list(y=y, X=X, N=length(y)))
print(fit)

pairs(fit, pars = c('alpha', 'beta[1]', 'sigma'))

library(shinystan)
launch_shinystan(fit)
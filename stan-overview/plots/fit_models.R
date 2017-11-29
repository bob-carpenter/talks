library(rstan);
options(mc.cores = 2);
library(bayesplot);

invLogit = function(x) 1/(1 + exp(-x));

genData = function(N, N_trials) {
  mu = 0;
  sigma = 1;
  theta = rnorm(N, mu, sigma);
  y = rbinom(N, N_trials, invLogit(theta));
  return(list(mu=mu,sigma=sigma,theta=theta,N=N,N_trials=N_trials,y=y));
}

get_params_by_chain = function(x) {
  fit_params = as.data.frame(extract(x, permuted=FALSE))
  names(fit_params) <- gsub("chain:1.", "", names(fit_params), fixed = TRUE)
  names(fit_params) <- gsub("[", ".", names(fit_params), fixed = TRUE)
  names(fit_params) <- gsub("]", "", names(fit_params), fixed = TRUE)
  return(fit_params);
}

get_divergens = function(x, n) {
  result = vector("numeric");
  for (i in 1:n) {
    ds = get_sampler_params(x, inc_warmup=FALSE)[[i]][,'divergent__'];
    result = append(result,ds);
  }
  return(result);
}

d_0 = genData(20, 0);
d_10 = genData(20, 10);
d_100 = genData(20, 100);
d_1000 = genData(20, 1000);
d_10000 = genData(20, 10000);

niter=100000;
nthin=100;
nchains=4;

fit_cp_0 = stan(file="funnel_cp.stan", data=d_0,
          iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_cp_10 = stan(file="funnel_cp.stan", data=d_10,
         iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_cp_100 = stan(file="funnel_cp.stan", data=d_100,
           iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_cp_1000 = stan(file="funnel_cp.stan", data=d_1000,
            iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_cp_10000 = stan(file="funnel_cp.stan", data=d_10000,
            iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);


fit_nc_0 = stan(file="funnel_nc.stan", data=d_0,
         iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_nc_10 = stan(file="funnel_nc.stan", data=d_10,
          iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_nc_100 = stan(file="funnel_nc.stan", data=d_100,
           iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_nc_1000 = stan(file="funnel_nc.stan", data=d_1000,
            iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_nc_10000 = stan(file="funnel_nc.stan", data=d_10000,
            iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

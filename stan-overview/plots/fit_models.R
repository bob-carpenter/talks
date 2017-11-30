library(rstan);
options(mc.cores = 2);
library(bayesplot);

invLogit = function(x) 1/(1 + exp(-x));

genData = function(N_groups, N_obs) {
  mu = 0;
  sigma = 1;
  theta = rnorm(N_groups, mu, sigma);
  y = rbinom(N_groups, N_obs, invLogit(theta));
  return(list(mu=mu,sigma=sigma,theta=theta,N_groups=N_groups,N_obs=N_obs,y=y));
}

N_groups = 5;
d_0 = genData(N_groups, 0);
d_10 = genData(N_groups, 10);
d_100 = genData(N_groups, 100);
d_1000 = genData(N_groups, 1000);
d_10000 = genData(N_groups, 10000);

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

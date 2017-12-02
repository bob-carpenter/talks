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

N_groups = 12;
d_0 = genData(N_groups, 0);
d_4 = genData(N_groups, 4);
d_16 = genData(N_groups, 16);
d_4096 = genData(N_groups, 4096);

niter=10000;
nthin=1;
nchains=4;

fit_cp_0 = stan(file="funnel_cp.stan", data=d_0,
          iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_cp_4 = stan(file="funnel_cp.stan", data=d_4,
         iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_cp_16 = stan(file="funnel_cp.stan", data=d_16,
           iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_cp_4096 = stan(file="funnel_cp.stan", data=d_4096,
            iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);


fit_nc_0 = stan(file="funnel_nc.stan", data=d_0,
         iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_nc_4 = stan(file="funnel_nc.stan", data=d_4,
          iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_nc_16 = stan(file="funnel_nc.stan", data=d_16,
           iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

fit_nc_4096 = stan(file="funnel_nc.stan", data=d_4096,
            iter=niter, thin=nthin, chains=nchains, save_warmup=FALSE);

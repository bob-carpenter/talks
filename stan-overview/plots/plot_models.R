library(ggplot2);
library(rstan);
options(mc.cores = 2);

## assemble into obj for ggplot2 = 10 plots of theta_1 x log(sigma)  
## need columns:  theta/theta_raw, log(sigma), centered?, num_data

log_sigma_cp_0 = log(as.vector(as.array(fit_cp_0, pars=c("sigma"))));
theta_cp_0 = as.vector(as.array(fit_cp_0, pars=c("theta[1]")));
theta_std_cp_0 = as.vector(as.array(fit_cp_0, pars=c("theta_std[1]")));

log_sigma_cp_10 = log(as.vector(as.array(fit_cp_10, pars=c("sigma"))));
theta_cp_10 = as.vector(as.array(fit_cp_10, pars=c("theta[1]")));
theta_std_cp_10 = as.vector(as.array(fit_cp_10, pars=c("theta_std[1]")));

log_sigma_cp_100 = log(as.vector(as.array(fit_cp_100, pars=c("sigma"))));
theta_cp_100 = as.vector(as.array(fit_cp_100, pars=c("theta[1]")));
theta_std_cp_100 = as.vector(as.array(fit_cp_100, pars=c("theta_std[1]")));

log_sigma_cp_1000 = log(as.vector(as.array(fit_cp_1000, pars=c("sigma"))));
theta_cp_1000 = as.vector(as.array(fit_cp_1000, pars=c("theta[1]")));
theta_std_cp_1000 = as.vector(as.array(fit_cp_1000, pars=c("theta_std[1]")));

log_sigma_cp_10000 = log(as.vector(as.array(fit_cp_10000, pars=c("sigma"))));
theta_cp_10000 = as.vector(as.array(fit_cp_10000, pars=c("theta[1]")));
theta_std_cp_10000 = as.vector(as.array(fit_cp_10000, pars=c("theta_std[1]")));

log_sigma_nc_0 = log(as.vector(as.array(fit_nc_0, pars=c("sigma"))));
theta_std_nc_0 = as.vector(as.array(fit_nc_0, pars=c("theta_std[1]")));
theta_nc_0 = as.vector(as.array(fit_nc_0, pars=c("theta[1]")));

log_sigma_nc_10 = log(as.vector(as.array(fit_nc_10, pars=c("sigma"))));
theta_std_nc_10 = as.vector(as.array(fit_nc_10, pars=c("theta_std[1]")));
theta_nc_10 = as.vector(as.array(fit_nc_10, pars=c("theta[1]")));

log_sigma_nc_100 = log(as.vector(as.array(fit_nc_100, pars=c("sigma"))));
theta_std_nc_100 = as.vector(as.array(fit_nc_100, pars=c("theta_std[1]")));
theta_nc_100 = as.vector(as.array(fit_nc_100, pars=c("theta[1]")));

log_sigma_nc_1000 = log(as.vector(as.array(fit_nc_1000, pars=c("sigma"))));
theta_std_nc_1000 = as.vector(as.array(fit_nc_1000, pars=c("theta_std[1]")));
theta_nc_1000 = as.vector(as.array(fit_nc_1000, pars=c("theta[1]")));

log_sigma_nc_10000 = log(as.vector(as.array(fit_nc_10000, pars=c("sigma"))));
theta_nc_10000 = as.vector(as.array(fit_nc_10000, pars=c("theta[1]")));
theta_std_nc_10000 = as.vector(as.array(fit_nc_10000, pars=c("theta_std[1]")));


cp_0 = data.frame(size=0, par="centered", log_sigma=log_sigma_cp_0,
     theta=theta_cp_0, theta_std=theta_std_cp_0);
cp_10 = data.frame(size=10, par="centered", log_sigma=log_sigma_cp_10,
      theta=theta_cp_10, theta_std=theta_std_cp_0);
cp_100 = data.frame(size=100, par="centered", log_sigma=log_sigma_cp_100,
       theta=theta_cp_100, theta_std=theta_std_cp_0);
cp_1000 = data.frame(size=1000, par="centered", log_sigma=log_sigma_cp_1000,
        theta=theta_cp_1000, theta_std=theta_std_cp_0);
cp_10000 = data.frame(size=10000, par="centered", log_sigma=log_sigma_cp_10000,
         theta=theta_cp_10000, theta_std=theta_std_cp_0);

nc_0 = data.frame(size=0, par="non-centered", log_sigma=log_sigma_nc_0,
     theta=theta_nc_0, theta_std=theta_std_nc_0);
nc_10 = data.frame(size=10, par="non-centered", log_sigma=log_sigma_nc_10,
      theta=theta_nc_10, theta_std=theta_std_nc_0);
nc_100 = data.frame(size=100, par="non-centered", log_sigma=log_sigma_nc_100,
       theta=theta_nc_100, theta_std=theta_std_nc_0);
nc_1000 = data.frame(size=1000, par="non-centered", log_sigma=log_sigma_nc_1000,
        theta=theta_nc_1000, theta_std=theta_std_nc_0);
nc_10000 = data.frame(size=10000, par="non-centered", log_sigma=log_sigma_nc_10000,
         theta=theta_nc_10000, theta_std=theta_std_nc_0);

fitted_models = rbind(cp_0,cp_10,cp_100,cp_1000,cp_10000,
              nc_0,nc_10,nc_100,nc_1000,nc_10000);

cp_0_divergens = get_divergens(fit_cp_0, nchains);
cp_10_divergens = get_divergens(fit_cp_10, nchains);
cp_100_divergens = get_divergens(fit_cp_100, nchains);
cp_1000_divergens = get_divergens(fit_cp_1000, nchains);
cp_10000_divergens = get_divergens(fit_cp_10000, nchains);

nc_0_divergens = get_divergens(fit_nc_0, nchains);
nc_10_divergens = get_divergens(fit_nc_10, nchains);
nc_100_divergens = get_divergens(fit_nc_100, nchains);
nc_1000_divergens = get_divergens(fit_nc_1000, nchains);
nc_10000_divergens = get_divergens(fit_nc_10000, nchains);

cp_0_idx_divs = which(cp_0_divergens==1);
cp_10_idx_divs = which(cp_10_divergens==1);
cp_100_idx_divs = which(cp_100_divergens==1);
cp_1000_idx_divs = which(cp_1000_divergens==1);
cp_10000_idx_divs = which(cp_10000_divergens==1);

nc_0_idx_divs = which(nc_0_divergens==1);
nc_10_idx_divs = which(nc_10_divergens==1);
nc_100_idx_divs = which(nc_100_divergens==1);
nc_1000_idx_divs = which(nc_1000_divergens==1);
nc_10000_idx_divs = which(nc_10000_divergens==1);

cp_0_div = data.frame(size=0, par="centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(cp_0_idx_divs) > 0) {
   cp_0_div = data.frame(size=0, par="centered",
   log_sigma=log_sigma_cp_0[cp_0_idx_divs],
   theta=theta_cp_0[cp_0_idx_divs],
   theta_std=theta_std_cp_0[cp_0_idx_divs]);
}
cp_10_div = data.frame(size=10, par="centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(cp_10_idx_divs) > 0) {
   cp_10_div = data.frame(size=10, par="centered",
   log_sigma=log_sigma_cp_10[cp_10_idx_divs],
   theta=theta_cp_10[cp_10_idx_divs],
   theta_std=theta_std_cp_10[cp_10_idx_divs]);
}
cp_100_div = data.frame(size=100, par="centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(cp_100_idx_divs) > 0) {
   cp_100_div = data.frame(size=100, par="centered",
   log_sigma=log_sigma_cp_100[cp_100_idx_divs],
   theta=theta_cp_100[cp_100_idx_divs],
   theta_std=theta_std_cp_100[cp_100_idx_divs]);
}
cp_1000_div = data.frame(size=1000, par="centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(cp_1000_idx_divs) > 0) {
   cp_1000_div = data.frame(size=1000, par="centered",
   log_sigma=log_sigma_cp_1000[cp_1000_idx_divs],
   theta=theta_cp_1000[cp_1000_idx_divs],
   theta_std=theta_std_cp_1000[cp_1000_idx_divs]);
}
cp_10000_div = data.frame(size=10000, par="centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(cp_10000_idx_divs) > 0) {
   cp_10000_div = data.frame(size=10000, par="centered",
   log_sigma=log_sigma_cp_10000[cp_10000_idx_divs],
   theta=theta_cp_10000[cp_10000_idx_divs],
   theta_std=theta_std_cp_10000[cp_10000_idx_divs]);
}

nc_0_div = data.frame(size=0, par="non-centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(nc_0_idx_divs) > 0) {
   nc_0_div = data.frame(size=0, par="non-centered",
   log_sigma=log_sigma_nc_0[nc_0_idx_divs],
   theta=theta_nc_0[nc_0_idx_divs],
   theta_std=theta_std_nc_0[nc_0_idx_divs]);
}
nc_10_div = data.frame(size=10, par="non-centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(nc_10_idx_divs) > 0) {
   nc_10_div = data.frame(size=10, par="non-centered",
   log_sigma=log_sigma_nc_10[nc_10_idx_divs],
   theta=theta_nc_10[nc_10_idx_divs],
   theta_std=theta_std_nc_10[nc_10_idx_divs]);
}
nc_100_div = data.frame(size=100, par="non-centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(nc_100_idx_divs) > 0) {
   nc_100_div = data.frame(size=100, par="non-centered",
   log_sigma=log_sigma_nc_100[nc_100_idx_divs],
   theta=theta_nc_100[nc_100_idx_divs],
   theta_std=theta_std_nc_100[nc_100_idx_divs]);
}
nc_1000_div = data.frame(size=1000, par="non-centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(nc_1000_idx_divs) > 0) {
   nc_1000_div = data.frame(size=1000, par="non-centered",
   log_sigma=log_sigma_nc_1000[nc_1000_idx_divs],
   theta=theta_nc_1000[nc_1000_idx_divs],
   theta_std=theta_std_nc_1000[nc_1000_idx_divs]);
}
nc_10000_div = data.frame(size=10000, par="non-centered", log_sigma=NA, theta=NA, theta_std=NA);
if (length(nc_10000_idx_divs) > 0) {
   nc_10000_div = data.frame(size=10000, par="non-centered",
   log_sigma=log_sigma_nc_10000[nc_10000_idx_divs],
   theta=theta_nc_10000[nc_10000_idx_divs],
   theta_std=theta_std_nc_10000[nc_10000_idx_divs]);
}

divs = rbind(cp_0_div,cp_10_div,cp_100_div,cp_1000_div,cp_10000_div,
              nc_0_div,nc_10_div,nc_100_div,nc_1000_div,nc_10000_div);


# theta centered vs. theta non-centered
p1 = ggplot(fitted_models, aes(x=fitted_models$theta, y=fitted_models$log_sigma));
p1 = p1 + geom_point(colour="darkgrey", size=0.75, alpha=0.75);
p1 = p1 + geom_point(data=divs, aes(x=divs$theta, y=divs$log_sigma), colour="green");
p1 = p1 + facet_wrap(par ~ size, nrow=2, ncol=5, scales="free", labeller = labeller(par = label_value, size = label_both));

# theta_std centered vs. theta_std non-centered
p2 = ggplot(fitted_models, aes(x=fitted_models$theta_std, y=fitted_models$log_sigma));
p2 = p2 + geom_point(colour="darkgrey", size=0.75, alpha=0.75);
p2 = p2 + geom_point(data=divs, aes(x=divs$theta_std, y=divs$log_sigma), colour="green");
p2 = p2 + facet_wrap(par ~ size, nrow=2, ncol=5, scales="free", labeller = labeller(par = label_value, size = label_both));

cp2_0 = data.frame(size=0, par="centered", log_sigma=log_sigma_cp_0, par_theta=theta_cp_0);
cp2_10 = data.frame(size=10, par="centered", log_sigma=log_sigma_cp_10, par_theta=theta_cp_10);
cp2_100 = data.frame(size=100, par="centered", log_sigma=log_sigma_cp_100, par_theta=theta_cp_100);
cp2_1000 = data.frame(size=1000, par="centered", log_sigma=log_sigma_cp_1000, par_theta=theta_cp_1000);
cp2_10000 = data.frame(size=10000, par="centered", log_sigma=log_sigma_cp_10000, par_theta=theta_cp_10000);

nc2_0 = data.frame(size=0, par="non-centered", log_sigma=log_sigma_nc_0, par_theta=theta_std_nc_0);
nc2_10 = data.frame(size=10, par="non-centered", log_sigma=log_sigma_nc_10, par_theta=theta_std_nc_10);
nc2_100 = data.frame(size=100, par="non-centered", log_sigma=log_sigma_nc_100, par_theta=theta_std_nc_100);
nc2_1000 = data.frame(size=1000, par="non-centered", log_sigma=log_sigma_nc_1000, par_theta=theta_std_nc_1000);
nc2_10000 = data.frame(size=10000, par="non-centered", log_sigma=log_sigma_nc_10000, par_theta=theta_std_nc_10000);

fitted_models2 = rbind(cp2_0,cp2_10,cp2_100,cp2_1000,cp2_10000,
              nc2_0,nc2_10,nc2_100,nc2_1000,nc2_10000);

# theta centered vs. theta_std non-centered
p3 = ggplot(fitted_models2, aes(x=fitted_models2$par_theta, y=fitted_models$log_sigma));
p3 = p3 + geom_point(colour="darkgrey", size=0.75, alpha=0.75);
p3 = p3 + geom_point(data=divs, aes(x=divs$theta, y=divs$log_sigma), colour="green");
p3 = p3 + facet_wrap(par ~ size, nrow=2, ncol=5, scales="free", labeller = labeller(par = label_value, size = label_both));

